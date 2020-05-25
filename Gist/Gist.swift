import Foundation

public class Gist: GistDelegate {
    private var configuration: Configuration?
    private var messageManager: MessageManager?
    private var extensions: [GistExtendable] = []

    public let organizationId: String
    weak public var delegate: GistDelegate?

    public init(organizationId: String, extensions: [GistExtendable.Type] = [], logging: Bool = false) {
        self.organizationId = organizationId
        self.extensions.append(GistMessageQueue(gist: self))
        for gistExtension in extensions {
            self.extensions.append(gistExtension.init(gist: self))
        }
        Logger.instance.enabled = logging
    }

    public func setup() {
        let bootstrap = Bootstrap(organizationId: organizationId, extensions: extensions)
        bootstrap.setup { [weak self] response in
            if case let Result.success(configuration) = response {
                self?.configuration = configuration
            }
        }
    }

    public func setUserToken(userToken: String) {
        UserManager().setUserToken(userToken: userToken)
    }

    public func clearUserToken() {
        UserManager().clearUserToken()
    }

    public func showMessage(messageRoute: String) -> Bool {
        if let configuration = self.configuration {
            if let messageManager = self.messageManager {
                Logger.instance.info(message:
                    "Message \(messageRoute) cannot be displayed, \(messageManager.currentMessage) is being displayed.")
            } else {
                self.messageManager = MessageManager(configuration: configuration, messageRoute: messageRoute)
                self.messageManager?.delegate = self
                self.messageManager?.showMessage()
                return true
            }
        } else {
            Logger.instance.error(message:
                """
                Message not shown because configuration was not set, \
                make sure Gist.setup() is called before showing a message.
                """
            )
        }
        return false
    }

    public func dismissMessage() {
        self.messageManager?.dismissMessage()
    }

    public func messageShown(messageRoute: String) {
        Logger.instance.debug(message: "Message with route: \(messageRoute) shown")
        let userToken = UserManager().getUserToken()
        for gistExtension in extensions {
            Logger.instance.debug(message:
                "Calling message shown for message: \(messageRoute) to \(gistExtension.name) extension")
            gistExtension.messageShown(messageRoute: messageRoute, userToken: userToken)
        }
        delegate?.messageShown(messageRoute: messageRoute)
    }

    public func messageDismissed(messageRoute: String) {
        Logger.instance.debug(message: "Message with id: \(messageRoute) dismissed")
        let userToken = UserManager().getUserToken()
        for gistExtension in extensions {
            Logger.instance.debug(message:
                "Calling message dismissed on message: \(messageRoute) to \(gistExtension.name) extension")
            gistExtension.messageDismissed(messageRoute: messageRoute, userToken: userToken)
        }
        self.messageManager = nil
        delegate?.messageDismissed(messageRoute: messageRoute)
    }

    public func messageError(messageRoute: String) {
        self.messageManager = nil
        delegate?.messageError(messageRoute: messageRoute)
    }

    public func action(currentRoute: String, action: String) {
        for gistExtension in extensions {
            Logger.instance.debug(message:
                "Calling action \"\(action)\" performed event on route \(currentRoute) to \(gistExtension.name) extension")
            gistExtension.actionPerformed(currentRoute: currentRoute, action: action)
        }
        delegate?.action(currentRoute: currentRoute, action: action)
    }
}
