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
        let engineConfiguration = EngineConfiguration(organizationId: configuration.organizationId,
                                                      projectId: configuration.projectId,
                                                      engineEndpoint: configuration.engineEndpoint,
                                                      authenticationEndpoint: configuration.identityEndpoint,
                                                      mainRoute: messageId,
                                                      engineVersion: 1,
                                                      configurationVersion: 1)
        engine = BourbonEngine.init(configuration: engineConfiguration)
        self.messageId = messageId
    }

    func showMessage() {
        shouldShowMessage = true
        if messageLoaded {
            guard let engineViewController = engine.viewController else { return }
            modalViewManager = ModalViewManager(viewController: engineViewController)
            modalViewManager?.showModalView {
                self.delegate?.messageShown(messageId: self.messageId)
            }
        }
    }

    func dismissMessage(completionHandler: @escaping () -> Void) {
        if let modalViewManager = modalViewManager {
            modalViewManager.dismissModelView {
                completionHandler()
            }
        }
    }

    func bootstrapped() {
        Logger.instance.debug(message: "Bourbon Engine bootstrapped")
    }

    func tap(action: String) {
        Logger.instance.debug(message: "Action triggered: \(action)")
        delegate?.action(action: action)
    }

    func routeChanged(newRoute: String) {
        Logger.instance.debug(message: "Message route changed to: \(newRoute)")
    }

    func routeError(route: String) {
        Logger.instance.error(message: "Error loading message with id: \(route)")
    }

    func routeLoaded(route: String) {
        Logger.instance.debug(message: "Message loaded with id: \(route)")
        if route == messageId {
            messageLoaded = true
            showMessage()
        }
    }
}
