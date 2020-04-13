import Foundation
import BourbonEngine

class MessageManager: BourbonEngineDelegate {
    private let engine: BourbonEngine
    private let organizationId: String
    private var shouldShowMessage = false
    private var messageLoaded = false
    private var modalViewManager: ModalViewManager?
    let messageId: String
    weak var delegate: GistDelegate?

    init(configuration: Configuration, messageId: String) {
        self.organizationId = configuration.organizationId
        self.messageId = messageId
        let engineConfiguration = EngineConfiguration(organizationId: configuration.organizationId,
                                                      projectId: configuration.projectId,
                                                      engineEndpoint: configuration.engineEndpoint,
                                                      authenticationEndpoint: configuration.identityEndpoint,
                                                      mainRoute: messageId,
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
                self.delegate?.messageShown(messageId: self.messageId)
            }
        }
    }

    func dismissMessage() {
        if let modalViewManager = modalViewManager {
            modalViewManager.dismissModalView { [weak self] in
                guard let self = self else { return }
                self.delegate?.messageDismissed(messageId: self.messageId)
            }
        }
    }

    func bootstrapped() {
        Logger.instance.debug(message: "Bourbon Engine bootstrapped")
    }

    func tap(action: String) {
        Logger.instance.debug(message: "Action triggered: \(action)")
        if action == "gist://close" {
            Logger.instance.debug(message: "Dismissing from action: \(action)")
            dismissMessage()
        }
        delegate?.action(action: action)
    }

    func routeChanged(newRoute: String) {
        Logger.instance.debug(message: "Message route changed to: \(newRoute)")
    }

    func routeError(route: String) {
        Logger.instance.error(message: "Error loading message with id: \(route)")
        delegate?.messageError(messageId: route)
    }

    func routeLoaded(route: String) {
        Logger.instance.debug(message: "Message loaded with id: \(route)")
        if route == messageId {
            messageLoaded = true
            showMessage()
        }
    }
}
