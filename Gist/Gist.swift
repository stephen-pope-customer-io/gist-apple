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

    public func showMessage(messageId: String) -> Bool {
        if let configuration = self.configuration {
            if let messageManager = self.messageManager {
                Logger.instance.info(message:
                    "Message with id \(messageId) cannot be displayed, \(messageManager.messageId) is being displayed.")
            } else {
                self.messageManager = MessageManager(configuration: configuration, messageId: messageId)
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

    public func messageShown(messageId: String) {
        Logger.instance.debug(message: "Message with id: \(messageId) shown")
        let userToken = UserManager().getUserToken()
        for gistExtension in extensions {
            Logger.instance.debug(message:
                "Calling message shown event for message id: \(messageId) on gist extension: \(gistExtension.name)")
            gistExtension.messageShown(messageId: messageId, userToken: userToken)
        }
        delegate?.messageShown(messageId: messageId)
    }

    public func messageDismissed(messageId: String) {
        Logger.instance.debug(message: "Message with id: \(messageId) dismissed")
        let userToken = UserManager().getUserToken()
        for gistExtension in extensions {
            Logger.instance.debug(message:
                "Calling message dismissed event for message id: \(messageId) on gist extension: \(gistExtension.name)")
            gistExtension.messageDismissed(messageId: messageId, userToken: userToken)
        }
        self.messageManager = nil
        delegate?.messageDismissed(messageId: messageId)
    }

    public func action(action: String) {
        for gistExtension in extensions {
            Logger.instance.debug(message:
                "Calling action \"\(action)\" performed event on gist extension: \(gistExtension.name)")
            gistExtension.actionPerformed(action: action)
        }
        delegate?.action(action: action)
    }
}
