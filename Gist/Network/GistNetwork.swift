import Foundation
import Alamofire

class GistNetwork {
    let organizationId: String

    init(organizationId: String) {
        self.organizationId = organizationId
    }

    func request(_ request: GistNetworkRequest) throws -> DataRequest {
        guard let baseURL = URL(string: Settings.Production.baseURL) else {
            throw GistNetworkRequestError.invalidBaseURL
        }

        var urlRequest = URLRequest(url: baseURL.appendingPathComponent(request.path))
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.addValue(organizationId, forHTTPHeaderField: HTTPHeader.organizationId.rawValue)
        urlRequest.addValue(ContentTypes.json.rawValue, forHTTPHeaderField: HTTPHeader.contentType.rawValue)

        switch request.parameters {
        case .body(let body):
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        case .id(let id):
            let components = URLComponents(string: baseURL
                .appendingPathComponent(request.path)
                .appendingPathComponent(id).absoluteString
            )
            urlRequest.url = components?.url
        default:
            break
        }

        return AF.request(urlRequest)
    }
}
