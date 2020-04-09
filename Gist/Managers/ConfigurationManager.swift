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
                .validate(statusCode: 200..<205)
                .responseJSON { (response: DataResponse<Any, AFError>) in
                    switch response.result {
                    case .success(let configurationResponseJSON):
                        if let statusCode = response.response?.statusCode, statusCode == 204 {
                            completionHandler(.failure(ConfigurationManagerError.accountNotSetup))
                        } else {
                            do {
                                let data = try JSONSerialization.data(withJSONObject: configurationResponseJSON)
                                let configurationResponse =
                                    try JSONDecoder().decode(ConfigurationResponse.self, from: data)
                                completionHandler(.success(configurationResponse))
                            } catch {
                                completionHandler(.failure(error))
                            }
                        }
                    case .failure(let error):
                        completionHandler(.failure(error))
                    }
                }
        } catch {
            completionHandler(.failure(error))
        }
    }
}

enum ConfigurationManagerError: Error {
    case accountNotSetup
}
