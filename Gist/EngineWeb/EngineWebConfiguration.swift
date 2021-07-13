import Foundation

struct EngineWebConfiguration: Encodable {
    let organizationId: String
    let messageId: String
    let instanceId: String
    let endpoint: String
    let livePreview: Bool = false
    let properties: [String: AnyEncodable?]?

    init(organizationId: String,
         messageId: String,
         instanceId: String,
         endpoint: String,
         properties: [String: AnyEncodable?]?) {
        self.organizationId = organizationId
        self.messageId = messageId
        self.instanceId = instanceId
        self.endpoint = endpoint
        self.properties = properties
    }
}
