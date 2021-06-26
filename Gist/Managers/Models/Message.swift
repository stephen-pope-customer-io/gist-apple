import Foundation

public class GistProperties {
    public let routeRule: String?
    public let elementId: String?
    public let position: MessagePosition

    init(routeRule: String?, elementId: String?, position: MessagePosition) {
        self.routeRule = routeRule
        self.elementId = elementId
        self.position = position
    }
}

public class Message {
    public private(set) var instanceId = UUID().uuidString.lowercased()
    public let queueId: String?
    public let messageId: String
    public private(set) var gistProperties: GistProperties

    var properties = [String: Any]()

    public init(messageId: String) {
        self.queueId = nil
        self.gistProperties = GistProperties(routeRule: nil, elementId: nil, position: .center)
        self.messageId = messageId
    }

    init(queueId: String? = nil, messageId: String, properties: [String: Any]?) {
        self.queueId = queueId
        self.gistProperties = GistProperties(routeRule: nil, elementId: nil, position: .center)
        self.messageId = messageId

        if let properties = properties {
            self.properties = properties
            if let gist = self.properties["gist"] as? [String: String] {
                var messagePosition = MessagePosition.center
                if let position = gist["position"], let positionValue = MessagePosition.init(rawValue: position) {
                    messagePosition = positionValue
                }
                self.gistProperties = GistProperties(
                    routeRule: gist["routeRule"],
                    elementId: gist["elementId"],
                    position: messagePosition)
            }
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
