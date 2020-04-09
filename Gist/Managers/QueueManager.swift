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
                .validate(statusCode: 200..<205)
                .responseJSON { (response: DataResponse<Any, AFError>) in
                    switch response.result {
                    case .success(let userQueueResponseJSON):
                        if let statusCode = response.response?.statusCode, statusCode == 204 {
                            completionHandler(.success([]))
                        } else {
                            do {
                                let data = try JSONSerialization.data(withJSONObject: userQueueResponseJSON)
                                let userQueueResponse = try JSONDecoder().decode([UserQueueResponse].self, from: data)
                                completionHandler(.success(userQueueResponse))
                            } catch {
                                completionHandler(.failure(error))
                            }
                        }
                    case .failure(let error):
                        completionHandler(.failure(error))
                    }
                }
        } catch {
            completionHandler(.failure(error))
        }
    }
}
