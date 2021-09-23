import Foundation

struct LogEventRequest: Encodable {
    let name: String
    let route: String
    let instanceId: String
    let queueId: String?
    let campaignId: String?
    let platform = "ios"

    init(name: String, route: String, instanceId: String, queueId: String?, campaignId: String?) {
        self.name = name
        self.route = route
        self.instanceId = instanceId
        self.queueId = queueId
        self.campaignId = campaignId
    }
}
