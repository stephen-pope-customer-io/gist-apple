import Foundation

enum AnalyticsEventLogEndpoint: GistNetworkRequest {
    case logOrganizationEvent(name: String, route: String, instanceId: String, queueId: String?)

    var method: HTTPMethod {
        switch self {
        case .logOrganizationEvent:
            return .post
        }
    }

     var parameters: RequestParameters? {
        switch self {
        case .logOrganizationEvent(let name, let route, let instanceId, let queueId):
            return .body(LogEventRequest(name: name, route: route, instanceId: instanceId, queueId: queueId))
        }
    }

    var path: String {
        switch self {
        case .logOrganizationEvent:
            return "/api/v1/organization/events"
        }
    }
}
