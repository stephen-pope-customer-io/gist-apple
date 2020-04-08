import Foundation
import Alamofire

class LogManager {

    let organizationId: String

    init(organizationId: String) {
        self.organizationId = organizationId
    }

    func logView(messageId: String, userToken: String?, completionHandler: @escaping (Result<Void, Error>) -> Void) {
        do {
            try GistNetwork(organizationId: organizationId)
                .request(LogEndpoint.logView(messageId: messageId, userToken: userToken))
                .validate(statusCode: [200])
                .response { response in
                    switch response.result {
                    case .success:
                        completionHandler(.success(()))
                    case .failure(let error):
                        completionHandler(.failure(error))
                    }
            }
        } catch {
            completionHandler(.failure(error))
        }
    }
}
