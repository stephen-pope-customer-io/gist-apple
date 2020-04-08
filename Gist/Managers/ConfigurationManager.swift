import Foundation
import Alamofire

class ConfigurationManager {

    let organizationId: String

    init(organizationId: String) {
        self.organizationId = organizationId
    }

    func fetchConfiguration(completionHandler: @escaping (Result<ConfigurationResponse, Error>) -> Void) {
        do {
            try GistNetwork(organizationId: organizationId)
                .request(ConfigurationEndpoint.getConfiguration)
                .validate(statusCode: [200])
                .responseDecodable { (response: DataResponse<ConfigurationResponse, AFError>) in
                switch response.result {
                case .success(let response):
                    completionHandler(.success(response))
                case .failure(let error):
                    completionHandler(.failure(error))
                }
            }
        } catch {
            completionHandler(.failure(error))
        }
    }
}
