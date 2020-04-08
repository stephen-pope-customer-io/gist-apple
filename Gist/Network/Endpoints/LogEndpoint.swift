import Foundation
import Alamofire

enum LogEndpoint: GistNetworkRequest {
    case logView(messageId: String, userToken: String?)

    var method: HTTPMethod {
        switch self {
        case .logView:
            return .post
        }
    }

     var parameters: RequestParameters? {
        switch self {
        case .logView(let messageId, let userToken):
            return.body(LogViewRequest(messageId: messageId, userToken: userToken))
        }
    }

    var path: String {
        switch self {
        case .logView:
            return "/api/v1/queue/user"
        }
    }
}
