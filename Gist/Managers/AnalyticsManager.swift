import Foundation

enum AnalyticsEvent: String {
    case loaded = "gist_loaded"
    case dismissed = "gist_dismissed"
    case systemAction = "gist_system_action"
    case action = "gist_action"
}

class AnalyticsManager {

    let organizationId: String

    init(organizationId: String) {
        self.organizationId = organizationId
    }

    func logEvent(name: AnalyticsEvent, route: String, instanceId: String, queueId: String?) {
        logOrganizationEvent(name: name.rawValue,
                             route: route,
                             instanceId: instanceId,
                             queueId: queueId,
                             completionHandler: { result in
                                switch result {
                                case .success:
                                    Logger.instance.error(message: "Analytics event \(name.rawValue) logged")
                                case .failure(let error):
                                    Logger.instance.error(
                                        message: "Error logging analytics event: \(name.rawValue), \(error.localizedDescription)")
                                }
                             })
    }

    private func logOrganizationEvent(name: String,
                                      route: String,
                                      instanceId: String,
                                      queueId: String?,
                                      completionHandler: @escaping (Result<Void, Error>) -> Void) {
        do {
            try GistAnalyticsNetwork(organizationId: organizationId)
                .request(AnalyticsEventLogEndpoint.logOrganizationEvent(name: name,
                                                                        route: route,
                                                                        instanceId: instanceId,
                                                                        queueId: queueId),
                         completionHandler: { response in
                            switch response {
                            case .success:
                                completionHandler(.success(()))
                            case .failure(let error):
                                completionHandler(.failure(error))
                            }})
        } catch {
            completionHandler(.failure(error))
        }
    }
}
