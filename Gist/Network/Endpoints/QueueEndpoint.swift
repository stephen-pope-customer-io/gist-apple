import Foundation

enum QueueEndpoint: GistNetworkRequest {
    case getUserQueue(topics: [String])

    var method: HTTPMethod {
        switch self {
        case .getUserQueue:
            return .post
        }
    }

     var parameters: RequestParameters? {
        switch self {
        case .getUserQueue(let topics):
            return .body(MessagesRequest(topics: topics))
        }
    }

    var path: String {
        switch self {
        case .getUserQueue:
            return "/api/v1/users"
        }
    }
}
