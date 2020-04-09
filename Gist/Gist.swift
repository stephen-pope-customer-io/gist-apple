import Foundation

public class Gist: GistDelegate {
    private var configuration: Configuration?
    private var messageManager: MessageManager?
    private var extensions: [GistExtendable]

    public let organizationId: String
    weak public var delegate: GistDelegate?

    public init(organizationId: String, extensions: [GistExtendable] = [], logging: Bool = false) {
        self.organizationId = organizationId
        self.extensions = extensions
        self.extensions.append(GistMessageQueue(gist: self))
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

    public func showMessage(messageId: String) {
        if let configuration = self.configuration {
            if let messageManager = self.messageManager {
                Logger.instance.info(message:
                    "Message with id \(messageId) cannot be displayed, \(messageManager.messageId) is being displayed.")
            } else {
                self.messageManager = MessageManager(configuration: configuration, messageId: messageId)
                self.messageManager?.delegate = self
                self.messageManager?.showMessage()
            }
        } else {
            Logger.instance.error(message:
                """
                Message not shown because configuration was not set, \
                make sure Gist.setup() is called before showing a message.
                """
            )
        }
    }

    public func dismissMessage() {
        self.messageManager?.dismissMessage()
    }

    public func messageShown(messageId: String) {
        Logger.instance.debug(message: "Message with id: \(messageId) shown")
        let userToken = UserManager().getUserToken()
        LogManager(organizationId: organizationId)
            .logView(messageId: messageId, userToken: userToken) { response in
                if case let .failure(error) = response {
                    Logger.instance.error(message:
                        "Failed to log view for message id: \(messageId) with error: \(error)")
                }
        }
        for gistExtention in extensions {
            Logger.instance.debug(message:
                "Calling message shown event for message id: \(messageId) on gist extension: \(gistExtention.name)")
            gistExtention.messageShown(messageId: messageId, userToken: userToken)
        }
        delegate?.messageShown(messageId: messageId)
    }

    public func messageDismissed(messageId: String) {
        Logger.instance.debug(message: "Message with id: \(messageId) dismissed")
        let userToken = UserManager().getUserToken()
        for gistExtention in extensions {
            Logger.instance.debug(message:
                "Calling message dismissed event for message id: \(messageId) on gist extension: \(gistExtention.name)")
            gistExtention.messageShown(messageId: messageId, userToken: userToken)
        }
        self.messageManager = nil
        delegate?.messageDismissed(messageId: messageId)
    }

    public func action(action: String) {
        for gistExtention in extensions {
            Logger.instance.debug(message:
                "Calling action \"\(action)\" performed event on gist extension: \(gistExtention.name)")
            gistExtention.actionPerformed(action: action)
        }
        delegate?.action(action: action)
    }
}
