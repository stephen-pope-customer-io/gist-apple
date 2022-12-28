import Foundation

class LogManager {

    let siteId: String

    init(siteId: String) {
        self.siteId = siteId
    }

    func logView(message: Message, userToken: String?, completionHandler: @escaping (Result<Void, Error>) -> Void) {
        do {
            if let queueId = message.queueId, let userToken = userToken {
                try GistQueueNetwork(siteId: siteId, userToken: userToken)
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
                try GistQueueNetwork(siteId: siteId)
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
