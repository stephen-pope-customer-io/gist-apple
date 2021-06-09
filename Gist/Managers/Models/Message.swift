import Foundation

public class Message {
    public let queueId: String?
    public let messageId: String
    var properties = [String: Any]()

    public init(messageId: String) {
        self.queueId = nil
        self.messageId = messageId
    }

    init(queueId: String? = nil, messageId: String, properties: [String: Any]?) {
        self.queueId = queueId
        self.messageId = messageId
        if let properties = properties {
            self.properties = properties
        }
    }

    public func addProperty(key: String, value: Any) {
        self.properties[key] = AnyEncodable(value)
    }

    func toEngineRoute() -> EngineRoute {
        let engineRoute = EngineRoute(route: self.messageId)
        properties.keys.forEach { key in
            if let value = properties[key] {
                engineRoute.addProperty(key: key, value: value)
            }
        }
        return engineRoute
    }
}
