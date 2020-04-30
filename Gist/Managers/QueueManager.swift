import Foundation

class QueueManager {

    let organizationId: String

    init(organizationId: String) {
        self.organizationId = organizationId
    }

    func fetchUserQueue(userToken: String, completionHandler: @escaping (Result<[UserQueueResponse], Error>) -> Void) {
        do {
            try GistNetwork(organizationId: organizationId)
                .request(QueueEndpoint.getUserQueue(userToken: userToken), completionHandler: { response in
                switch response {
                case .success(let (data, response)):
                    if response.statusCode == 204 {
                        completionHandler(.success([]))
                    } else {
                        do {
                            let userQueueResponse = try JSONDecoder().decode([UserQueueResponse].self, from: data)
                            DispatchQueue.main.async {
                                completionHandler(.success(userQueueResponse))
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
