import Foundation

enum ConfigurationEndpoint: GistNetworkRequest {
    case getConfiguration

    var method: HTTPMethod {
        switch self {
        case .getConfiguration:
            return .get
        }
    }

    var parameters: RequestParameters? {
        switch self {
        case .getConfiguration:
            return nil
        }
    }

    var path: String {
        switch self {
        case .getConfiguration:
            return "/api/v1/configuration"
        }
    }
}
