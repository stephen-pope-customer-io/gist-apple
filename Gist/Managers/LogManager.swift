import Foundation

class LogManager {

    let organizationId: String

    init(organizationId: String) {
        self.organizationId = organizationId
    }

    func logView(message: Message, userToken: String?, completionHandler: @escaping (Result<Void, Error>) -> Void) {
        do {
            if let queueId = message.queueId, let userToken = userToken {
                try GistQueueNetwork(organizationId: organizationId, userToken: userToken)
                    .request(LogEndpoint.logUserMessageView(queueId: queueId), completionHandler: { response in
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
            } else {
                try GistQueueNetwork(organizationId: organizationId)
                    .request(LogEndpoint.logMessageView(messageId: message.messageId), completionHandler: { response in
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
            }
        } catch {
            completionHandler(.failure(error))
        }
    }
}
