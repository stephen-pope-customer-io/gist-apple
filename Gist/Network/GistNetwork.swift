import Foundation

class GistNetwork {
    let organizationId: String

    init(organizationId: String) {
        self.organizationId = organizationId
    }

    typealias GistNetworkResponse = (Data, HTTPURLResponse)

    func request(_ request: GistNetworkRequest,
                 completionHandler: @escaping (Result<GistNetworkResponse, Error>) -> Void) throws {
        guard let baseURL = URL(string: Settings.Production.baseURL) else {
            throw GistNetworkRequestError.invalidBaseURL
        }

        var urlRequest = URLRequest(url: baseURL.appendingPathComponent(request.path))
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.addValue(organizationId, forHTTPHeaderField: HTTPHeader.organizationId.rawValue)
        urlRequest.addValue(ContentTypes.json.rawValue, forHTTPHeaderField: HTTPHeader.contentType.rawValue)

        switch request.parameters {
        case .body(let body):
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: body.asDictionary(), options: [])
        case .id(let id):
            let components = URLComponents(string: baseURL
                .appendingPathComponent(request.path)
                .appendingPathComponent(id).absoluteString
            )
            urlRequest.url = components?.url
        default:
            break
        }

        URLSession.shared.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            if let error = error { completionHandler(.failure(error)) }
            guard let data = data, let response = response as? HTTPURLResponse,
                (200...299).contains(response.statusCode) else {
                completionHandler(.failure(GistNetworkError.serverError))
                return
            }
            completionHandler(.success(GistNetworkResponse(data, response)))
        }).resume()
    }
}

enum GistNetworkError: Error {
    case serverError
    case requestFailed
}
