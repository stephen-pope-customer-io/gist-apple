import Foundation

class QueueManager {

    let organizationId: String

    init(organizationId: String) {
        self.organizationId = organizationId
    }

    func fetchUserQueue(userToken: String,
                        topics: [String],
                        completionHandler: @escaping (Result<[UserQueueResponse], Error>) -> Void) {
        do {
            try GistQueueNetwork(organizationId: organizationId, userToken: userToken)
                .request(QueueEndpoint.getUserQueue(topics: topics), completionHandler: { response in
                switch response {
                case .success(let (data, response)):
                    if response.statusCode == 204 {
                        completionHandler(.success([]))
                    } else {
                        do {
                            var userQueue = [UserQueueResponse]()
                            if let userQueueResponse =
                                try JSONSerialization.jsonObject(with: data,
                                                                 options: .allowFragments) as? [[String: Any?]] {
                                userQueueResponse.forEach { (item) in
                                    if let userQueueItem = UserQueueResponse(dictionary: item) {
                                        userQueue.append(userQueueItem)
                                    }
                                }
                            }
                            DispatchQueue.main.async {
                                completionHandler(.success(userQueue))
                            }
                        } catch {
                            completionHandler(.failure(error))
                        }
                    }
                case .failure(let error):
                    completionHandler(.failure(error))
                }})
        } catch {
            completionHandler(.failure(error))
        }
    }
}
