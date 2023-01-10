import Foundation

struct EngineWebConfiguration: Encodable {
    let siteId: String
    let messageId: String
    let instanceId: String
    let endpoint: String
    let livePreview: Bool = false
    let properties: [String: AnyEncodable?]?

    init(siteId: String,
         messageId: String,
         instanceId: String,
         endpoint: String,
         properties: [String: AnyEncodable?]?) {
        self.siteId = siteId
        self.messageId = messageId
        self.instanceId = instanceId
        self.endpoint = endpoint
        self.properties = properties
    }
}
