import Foundation
import UIKit

public enum GistMessageActions: String {
    case close = "gist://close"
}

class MessageManager: EngineWebDelegate {
    private var engine: EngineWeb?
    private let organizationId: String
    private var shouldShowMessage = false
    private var messagePosition: MessagePosition = .top
    private var messageLoaded = false
    private var modalViewManager: ModalViewManager?
    private let analyticsManager: AnalyticsManager?
    var isMessageEmbed = false
    let currentMessage: Message
    var gistView: GistView!
    private var currentRoute: String
    weak var delegate: GistDelegate?

    init(organizationId: String, message: Message) {
        self.organizationId = organizationId
        self.currentMessage = message
        self.currentRoute = message.messageId

        self.analyticsManager = AnalyticsManager(organizationId: self.organizationId)

        let engineWebConfiguration = EngineWebConfiguration(
            organizationId: self.organizationId,
            messageId: message.messageId,
            instanceId: message.instanceId,
            endpoint: Settings.Network.gistAPI,
            properties: message.toEngineRoute().properties)

        engine = EngineWeb(configuration: engineWebConfiguration)
        if let engine = engine {
            engine.delegate = self
            gistView = GistView(message: self.currentMessage, engineView: engine.view)
        }
    }

    func showMessage(position: MessagePosition) {
        messagePosition = position
        shouldShowMessage = true
    }

    func getMessageView() -> GistView {
        isMessageEmbed = true
        return gistView
    }

    private func loadModalMessage() {
        if messageLoaded {
            modalViewManager = ModalViewManager(gistView: gistView, position: messagePosition)
            modalViewManager?.showModalView { [weak self] in
                guard let self = self else { return }
                self.delegate?.messageShown(message: self.currentMessage)
            }
        }
    }

    func dismissMessage(completionHandler: (() -> Void)? = nil) {
        if let modalViewManager = modalViewManager {
            analyticsManager?.logEvent(name: .dismissed,
                                       route: currentRoute,
                                       instanceId: currentMessage.instanceId,
                                       queueId: currentMessage.queueId)
            modalViewManager.dismissModalView { [weak self] in
                guard let self = self else { return }
                self.delegate?.messageDismissed(message: self.currentMessage)
                completionHandler?()
            }
        }
    }

    func bootstrapped() {
        Logger.instance.debug(message: "Bourbon Engine bootstrapped")
    }

    func tap(action: String, system: Bool) {
        var shouldLogAction = true
        Logger.instance.info(message: "Action triggered: \(action)")
        delegate?.action(message: currentMessage, currentRoute: self.currentRoute, action: action)
        gistView.delegate?.action(message: currentMessage, currentRoute: self.currentRoute, action: action)

        if let url = URL(string: action), url.scheme == "gist" {
            switch url.host {
            case "close":
                shouldLogAction = false
                Logger.instance.info(message: "Dismissing from action: \(action)")
                dismissMessage()
            case "loadPage":
                if let page = url.queryParameters?["url"],
                   let pageUrl = URL(string: page),
                   UIApplication.shared.canOpenURL(pageUrl) {
                    UIApplication.shared.open(pageUrl)
                }
            case "showMessage":
                if currentMessage.isEmbedded {
                    self.showNewMessage(url: url)
                } else {
                    dismissMessage {
                        self.showNewMessage(url: url)
                    }
                }
            default: break
            }
        } else {
            if system {
                analyticsManager?.logEvent(name: .systemAction,
                                           route: currentRoute,
                                           instanceId: currentMessage.instanceId,
                                           queueId: currentMessage.queueId)

                if let url = URL(string: action), UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url) { handled in
                        if handled {
                            Logger.instance.info(message: "Dismissing from system action: \(action)")
                            self.dismissMessage()
                        } else {
                            Logger.instance.info(message: "System action not handled")
                        }
                    }
                }
                shouldLogAction = false
            }
        }

        if shouldLogAction {
            analyticsManager?.logEvent(name: .action,
                                       route: currentRoute,
                                       instanceId: currentMessage.instanceId,
                                       queueId: currentMessage.queueId)
        }
    }

    func routeChanged(newRoute: String) {
        Logger.instance.info(message: "Message route changed to: \(newRoute)")
    }

    func sizeChanged(width: CGFloat, height: CGFloat) {
        gistView.delegate?.sizeChanged(message: currentMessage, width: width, height: height)
        Logger.instance.debug(message: "Message size changed Width: \(width) - Height: \(height)")
    }

    func routeError(route: String) {
        Logger.instance.error(message: "Error loading message with route: \(route)")
        delegate?.messageError(message: self.currentMessage)
    }

    func error() {
        Logger.instance.error(message: "Error loading message with id: \(currentMessage.messageId)")
        delegate?.messageError(message: self.currentMessage)
    }

    func routeLoaded(route: String) {
        Logger.instance.info(message: "Message loaded with route: \(route)")

        var shouldLogEvent = true
        self.currentRoute = route
        if route == currentMessage.messageId && !messageLoaded {
            messageLoaded = true
            if isMessageEmbed {
                self.delegate?.messageShown(message: self.currentMessage)
            } else {
                if UIApplication.shared.applicationState == .active {
                    loadModalMessage()
                } else {
                    shouldLogEvent = false
                    Gist.shared.removeMessageManager(instanceId: currentMessage.instanceId)
                }
            }
        }

        if shouldLogEvent {
            analyticsManager?.logEvent(name: .loaded,
                                       route: currentRoute,
                                       instanceId: currentMessage.instanceId,
                                       queueId: currentMessage.queueId)
        }
    }

    deinit {
        engine?.cleanEngineWeb()
        engine = nil
    }
    
    private func showNewMessage(url: URL) {
        var properties: [String: Any]? = nil
        
        if let stringProps = url.queryParameters?["properties"],
           let decodedData = Data(base64Encoded: stringProps),
           let decodedString = String(data: decodedData, encoding: .utf8),
           let convertedProps = convertToDictionary(text: decodedString) {
            properties = convertedProps
        }
        
        if let messageId = url.queryParameters?["messageId"] {
            _ = Gist.shared.showMessage(Message(messageId: messageId, properties: properties))
        }
    }

    private func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}
