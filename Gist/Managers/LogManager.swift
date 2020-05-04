import Foundation

class LogManager {

    let organizationId: String

    init(organizationId: String) {
        self.organizationId = organizationId
    }

    func logView(route: String, userToken: String?, completionHandler: @escaping (Result<Void, Error>) -> Void) {
        do {
            try GistNetwork(organizationId: organizationId)
                .request(LogEndpoint.logView(route: route, userToken: userToken), completionHandler: { response in
                switch response {
                case .success(let (_, response)):
                    if response.statusCode == 200 {
                        completionHandler(.success(()))
                    } else {
                        completionHandler(.failure(GistNetworkError.requestFailed))
                    }
                case .failure(let error):
                    completionHandler(.failure(error))
                }})
        } catch {
            completionHandler(.failure(error))
        }
    }
}
