import Foundation
import UIKit

public class Gist: GistDelegate {
    private var messageManagers: [MessageManager] = []
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
        Bootstrap(extensions: self.extensions).setup()
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

    public func showMessage(_ message: Message, position: MessagePosition = .center) -> Bool {
        if let messageManager = getModalMessageManager() {
            Logger.instance.info(message:
                "Message \(message.messageId) cannot be displayed, \(messageManager.currentMessage) is being displayed.")
        } else {
            let messageManager = createMessageManager(organizationId: self.organizationId, message: message)
            messageManager.showMessage(position: position)
            return true
        }
        return false
    }

    public func getMessageView(_ message: Message) -> UIView {
        let messageManager = createMessageManager(organizationId: self.organizationId, message: message)
        return messageManager.getMessageView()
    }

    public func dismissMessage(instanceId: String, completionHandler: (() -> Void)? = nil) {
        messageManager(instanceId: instanceId)?.dismissMessage(completionHandler: completionHandler)
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
        removeMessageManager(instanceId: message.instanceId)
        delegate?.messageDismissed(message: message)
    }

    public func messageError(message: Message) {
        removeMessageManager(instanceId: message.instanceId)
        delegate?.messageError(message: message)
    }

    public func action(message: Message, currentRoute: String, action: String) {
        for gistExtension in extensions {
            Logger.instance.debug(message:
                "Calling action \"\(action)\" performed event on route \(currentRoute) to \(gistExtension.name) extension")
            gistExtension.actionPerformed(currentRoute: currentRoute, action: action)
        }
        delegate?.action(message: message, currentRoute: currentRoute, action: action)
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

    // Message Manager

    private func createMessageManager(organizationId: String, message: Message) -> MessageManager {
        let messageManager = MessageManager(organizationId: organizationId, message: message)
        messageManager.delegate = self
        messageManagers.append(messageManager)
        return messageManager
    }

    private func getModalMessageManager() -> MessageManager? {
        return messageManagers.first(where: { !$0.isMessageEmbed })
    }

    private func messageManager(instanceId: String) -> MessageManager? {
        return messageManagers.first(where: { $0.currentMessage.instanceId == instanceId })
    }

    private func removeMessageManager(instanceId: String) {
        return messageManagers.removeAll(where: { $0.currentMessage.instanceId == instanceId })
    }
}
