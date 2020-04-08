import Foundation
import Alamofire

class QueueManager {

    let organizationId: String

    init(organizationId: String) {
        self.organizationId = organizationId
    }

    func fetchUserQueue(userToken: String, completionHandler: @escaping (Result<[UserQueueResponse], Error>) -> Void) {
        do {
            try GistNetwork(organizationId: organizationId)
                .request(QueueEndpoint.getUserQueue(userToken: userToken))
                .validate(statusCode: 200..<204)
                .responseDecodable { (response: DataResponse<[UserQueueResponse], AFError>) in
                switch response.result {
                case .success(let response):
                    completionHandler(.success(response))
                case .failure(let error):
                    completionHandler(.failure(error))
                }
            }
        } catch {
            completionHandler(.failure(error))
        }
    }
}
