import Foundation
import BourbonEngine

class MessageManager: BourbonEngineDelegate {
    private let engine: BourbonEngine
    private let organizationId: String
    private var shouldShowMessage = false
    private var messageLoaded = false
    private var modalViewManager: ModalViewManager?
    let currentMessage: String
    weak var delegate: GistDelegate?

    init(configuration: Configuration, messageRoute: String) {
        self.organizationId = configuration.organizationId
        self.currentMessage = messageRoute
        let engineConfiguration = EngineConfiguration(organizationId: configuration.organizationId,
                                                      projectId: configuration.projectId,
                                                      engineEndpoint: configuration.engineEndpoint,
                                                      authenticationEndpoint: configuration.identityEndpoint,
                                                      mainRoute: messageRoute,
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
                self.delegate?.messageShown(messageRoute: self.currentMessage)
            }
        }
    }

    func dismissMessage() {
        if let modalViewManager = modalViewManager {
            modalViewManager.dismissModalView { [weak self] in
                guard let self = self else { return }
                self.delegate?.messageDismissed(messageRoute: self.currentMessage)
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
        Logger.instance.error(message: "Error loading message with route: \(route)")
        delegate?.messageError(messageRoute: route)
    }

    func error() {
        Logger.instance.error(message: "Error loading message with route: \(currentMessage)")
        delegate?.messageError(messageRoute: currentMessage)
    }

    func routeLoaded(route: String) {
        Logger.instance.debug(message: "Message loaded with route: \(route)")
        if route == currentMessage {
            messageLoaded = true
            showMessage()
        }
    }
}
