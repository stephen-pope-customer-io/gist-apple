import Foundation

public class Gist: GistDelegate {
    public var configuration: Configuration?
    private var messageManager: MessageManager?
    private var extensions: [GistExtendable] = []

    public let organizationId: String
    weak public var delegate: GistDelegate?

    public init(organizationId: String,
                extensions: [GistExtendable.Type] = [],
                logging: Bool = false,
                env: GistEnvironment = .production) {
        Settings.Environment = env
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

    // MARK: User

    public func setUserToken(_ userToken: String) {
        UserManager().setUserToken(userToken: userToken)
    }

    public func clearUserToken() {
        UserManager().clearUserToken()
    }

    // MARK: Route

    public func getCurrentRoute() -> String {
        return RouteManager.getCurrentRoute()
    }

    public func setCurrentRoute(_ currentRoute: String) {
        RouteManager.setCurrentRoute(currentRoute)
    }

    public func clearCurrentRoute() {
        RouteManager.clearCurrentRoute()
    }

    // MARK: Message Actions

    public func showMessage(_ message: Message, position: MessagePosition = .center) -> String? {
        if let configuration = self.configuration {
            if let messageManager = self.messageManager {
                Logger.instance.info(message:
                    "Message \(message.messageId) cannot be displayed, \(messageManager.currentMessage) is being displayed.")
            } else {
                self.messageManager = MessageManager(configuration: configuration, message: message)
                self.messageManager?.delegate = self
                self.messageManager?.showMessage(position: position)
                return self.messageManager?.instanceId
            }
        } else {
            Logger.instance.error(message:
                """
                Message not shown because configuration was not set, \
                make sure Gist.setup() is called before showing a message.
                """
            )
        }
        return nil
    }
    
    public func getMessageView(_ message: Message) -> UIView? {
        if let configuration = self.configuration {
            self.messageManager = MessageManager(configuration: configuration, message: message)
            self.messageManager?.delegate = self
            return self.messageManager?.getMessageView()
        }
        return nil
    }

    public func dismissMessage(completionHandler: (() -> Void)? = nil) {
        self.messageManager?.dismissMessage(completionHandler: completionHandler)
    }

    // MARK: Events

    public func messageShown(message: Message) {
        Logger.instance.debug(message: "Message with route: \(message.messageId) shown")
        let userToken = UserManager().getUserToken()
        LogManager(organizationId: organizationId)
            .logView(message: message, userToken: userToken) { response in
                if case let .failure(error) = response {
                    Logger.instance.error(message:
                        "Failed to log view for message: \(message.messageId) with error: \(error)")
                }
        }
        for gistExtension in extensions {
            Logger.instance.debug(message:
                    "Calling message shown for message: \(message.messageId) to \(gistExtension.name) extension")
            gistExtension.messageShown(message: message, userToken: userToken)
        }
        delegate?.messageShown(message: message)
    }

    public func messageDismissed(message: Message) {
        Logger.instance.debug(message: "Message with id: \(message.messageId) dismissed")
        let userToken = UserManager().getUserToken()
        for gistExtension in extensions {
            Logger.instance.debug(message:
                    "Calling message dismissed on message: \(message.messageId) to \(gistExtension.name) extension")
            gistExtension.messageDismissed(message: message, userToken: userToken)
        }
        self.messageManager = nil
        delegate?.messageDismissed(message: message)
    }

    public func messageError(message: Message) {
        self.messageManager = nil
        delegate?.messageError(message: message)
    }

    public func action(currentRoute: String, action: String) {
        for gistExtension in extensions {
            Logger.instance.debug(message:
                "Calling action \"\(action)\" performed event on route \(currentRoute) to \(gistExtension.name) extension")
            gistExtension.actionPerformed(currentRoute: currentRoute, action: action)
        }
        delegate?.action(currentRoute: currentRoute, action: action)
    }

    public func embedMessage(message: Message, elementId: String) {
        delegate?.embedMessage(message: message, elementId: elementId)
    }

    // MARK: Broadcast

    public func getTopics() -> [String] {
        return TopicsManager.getTopics()
    }

    public func subscribeToTopic(_ topic: String) {
        TopicsManager.subscribeToTopic(topic)
    }

    public func unsubscribeFromTopic(_ topic: String) {
        TopicsManager.unsubscribeFromTopic(topic)
    }

    public func clearTopics() {
        TopicsManager.clearTopics()
    }
}
