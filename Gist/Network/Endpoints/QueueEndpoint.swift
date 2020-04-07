import Foundation
import Alamofire

enum QueueEndpoint: GistNetworkRequest {
    case getUserQueue(userToken: String)

    var method: HTTPMethod {
        switch self {
        case .getUserQueue:
            return .get
        }
    }

     var parameters: RequestParameters? {
        switch self {
        case .getUserQueue(let userToken):
            return.id(userToken)
        }
    }

    var path: String {
        switch self {
        case .getUserQueue:
            return "/api/v1/queue/user"
        }
    }
}
