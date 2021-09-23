import Foundation

enum AnalyticsEventLogEndpoint: GistNetworkRequest {
    case logOrganizationEvent(name: String, route: String, instanceId: String, queueId: String?, campaignId: String?)

    var method: HTTPMethod {
        switch self {
        case .logOrganizationEvent:
            return .post
        }
    }

     var parameters: RequestParameters? {
        switch self {
        case .logOrganizationEvent(let name, let route, let instanceId, let queueId, let campaignId):
            return .body(LogEventRequest(name: name,
                                         route: route,
                                         instanceId: instanceId,
                                         queueId: queueId,
                                         campaignId: campaignId))
        }
    }

    var path: String {
        switch self {
        case .logOrganizationEvent:
            return "/api/v1/organization/events"
        }
    }
}
