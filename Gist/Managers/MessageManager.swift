import Foundation
import UIKit

class MessageManager: EngineWebDelegate {
    private let engine: EngineWeb
    private let organizationId: String
    private var shouldShowMessage = false
    private var messagePosition: MessagePosition = .top
    private var messageLoaded = false
    private var modalViewManager: ModalViewManager?
    private let analyticsManager: AnalyticsManager?
    var isMessageEmbed = false
    let currentMessage: Message
    private var currentRoute: String
    weak var delegate: GistDelegate?

    init(configuration: Configuration, message: Message) {
        self.organizationId = configuration.organizationId
        self.currentMessage = message
        self.currentRoute = message.messageId

        self.analyticsManager = AnalyticsManager(organizationId: configuration.organizationId)

        let engineWebConfiguration = EngineWebConfiguration(
            organizationId: configuration.organizationId,
            messageId: message.messageId,
            instanceId: message.instanceId,
            endpoint: Settings.Network.gistAPI,
            properties: message.toEngineRoute().properties)

        engine = EngineWeb(configuration: engineWebConfiguration)
        engine.delegate = self
    }

    func showMessage(position: MessagePosition) {
        messagePosition = position
        shouldShowMessage = true
    }

    func getMessageView() -> UIView {
        isMessageEmbed = true
        self.delegate?.messageShown(message: self.currentMessage)
        return engine.view
    }

    private func loadModalMessage() {
        if messageLoaded {
            modalViewManager = ModalViewManager(view: engine.view, position: messagePosition)
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
        Logger.instance.debug(message: "Action triggered: \(action)")
        if action == "gist://close" {
            Logger.instance.debug(message: "Dismissing from action: \(action)")
            dismissMessage()
        } else if system {
            analyticsManager?.logEvent(name: .systemAction,
                                       route: currentRoute,
                                       instanceId: currentMessage.instanceId,
                                       queueId: currentMessage.queueId)

            if let url = URL(string: action), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url) { handled in
                    if handled {
                        Logger.instance.debug(message: "Dismissing from system action: \(action)")
                        self.dismissMessage()
                    } else {
                        Logger.instance.info(message: "System action not handled")
                    }
                }
            }
        } else {
            Logger.instance.debug(message: "Action selected: \(action)")
            analyticsManager?.logEvent(name: .action,
                                       route: currentRoute,
                                       instanceId: currentMessage.instanceId,
                                       queueId: currentMessage.queueId)
        }
        delegate?.action(message: currentMessage, currentRoute: self.currentRoute, action: action)
    }

    func routeChanged(newRoute: String) {
        Logger.instance.debug(message: "Message route changed to: \(newRoute)")
    }

    func sizeChanged(width: CGFloat, height: CGFloat) {
        modalViewManager?.sizeChange()
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
        Logger.instance.debug(message: "Message loaded with route: \(route)")

        self.currentRoute = route
        if route == currentMessage.messageId && !messageLoaded {
            messageLoaded = true
            if !isMessageEmbed {
                loadModalMessage()
            }
        }
        analyticsManager?.logEvent(name: .loaded,
                                   route: currentRoute,
                                   instanceId: currentMessage.instanceId,
                                   queueId: currentMessage.queueId)
    }
}
