import Foundation
import BourbonEngine

class MessageManager: BourbonEngineDelegate {
    private let engine: BourbonEngine
    private let organizationId: String
    private var shouldShowMessage = false
    private var messageLoaded = false
    private var modalViewManager: ModalViewManager?
    private let analyticsManager: AnalyticsManager?
    let instanceId: String
    let currentMessage: Message
    private var currentRoute: String
    weak var delegate: GistDelegate?

    init(configuration: Configuration, message: Message) {
        self.organizationId = configuration.organizationId
        self.currentMessage = message
        self.currentRoute = message.messageId
        self.instanceId = UUID().uuidString.lowercased()

        self.analyticsManager = AnalyticsManager(organizationId: configuration.organizationId)

        let engineConfiguration = EngineConfiguration(organizationId: configuration.organizationId,
                                                      projectId: configuration.projectId,
                                                      engineEndpoint: configuration.engineEndpoint,
                                                      authenticationEndpoint: configuration.identityEndpoint,
                                                      mainRoute: message.toEngineRoute(),
                                                      engineVersion: 1,
                                                      configurationVersion: 1)
        engine = BourbonEngine(configuration: engineConfiguration)
        engine.delegate = self
    }

    func showMessage() {
        shouldShowMessage = true
        if messageLoaded {
            guard let engineViewController = engine.viewController else { return }
            modalViewManager = ModalViewManager(viewController: engineViewController)
            modalViewManager?.showModalView { [weak self] in
                guard let self = self else { return }
                self.delegate?.messageShown(message: self.currentMessage)
            }
        }
    }

    func dismissMessage(completionHandler: (() -> Void)? = nil) {
        if let modalViewManager = modalViewManager {
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
            analyticsManager?.logEvent(name: .dismissed,
                                       route: currentRoute,
                                       instanceId: instanceId,
                                       queueId: currentMessage.queueId)
        } else if system {
            Logger.instance.debug(message: "Dismissing from system action: \(action)")
            dismissMessage()
            analyticsManager?.logEvent(name: .systemAction,
                                       route: currentRoute,
                                       instanceId: instanceId,
                                       queueId: currentMessage.queueId)
        } else {
            Logger.instance.debug(message: "Action selected: \(action)")
            analyticsManager?.logEvent(name: .action,
                                       route: currentRoute,
                                       instanceId: instanceId,
                                       queueId: currentMessage.queueId)
        }
        delegate?.action(currentRoute: self.currentRoute, action: action)
    }

    func routeChanged(newRoute: String) {
        Logger.instance.debug(message: "Message route changed to: \(newRoute)")
    }

    func routeError(route: String) {
        Logger.instance.error(message: "Error loading message with route: \(route)")
        delegate?.messageError(message: self.currentMessage)
    }

    func error() {
        Logger.instance.error(message: "Error loading message with route: \(currentMessage)")
        delegate?.messageError(message: self.currentMessage)
    }

    func routeLoaded(route: String) {
        Logger.instance.debug(message: "Message loaded with route: \(route)")

        self.currentRoute = route
        if route == currentMessage.messageId && !messageLoaded {
            messageLoaded = true
            showMessage()
        }
        analyticsManager?.logEvent(name: .loaded,
                                   route: currentRoute,
                                   instanceId: instanceId,
                                   queueId: currentMessage.queueId)
    }
}
