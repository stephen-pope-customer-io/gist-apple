import Foundation

enum LogEndpoint: GistNetworkRequest {
    case logView(route: String, userToken: String?)

    var method: HTTPMethod {
        switch self {
        case .logView:
            return .post
        }
    }

     var parameters: RequestParameters? {
        switch self {
        case .logView(let route, let userToken):
            return.body(LogViewRequest(route: route, userToken: userToken))
        }
    }

    var path: String {
        switch self {
        case .logView:
            return "/api/v1/log"
        }
    }
}
