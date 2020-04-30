import Foundation

class ConfigurationManager {

    let organizationId: String

    init(organizationId: String) {
        self.organizationId = organizationId
    }

    func fetchConfiguration(completionHandler: @escaping (Result<ConfigurationResponse, Error>) -> Void) {
        do {
            try GistNetwork(organizationId: organizationId)
                .request(ConfigurationEndpoint.getConfiguration, completionHandler: { response in
                    switch response {
                    case .success(let (data, response)):
                        if response.statusCode == 204 {
                            completionHandler(.failure(ConfigurationManagerError.accountNotSetup))
                        } else {
                            do {
                                let configurationResponse = try JSONDecoder().decode(ConfigurationResponse.self,
                                                                                     from: data)
                                DispatchQueue.main.async {
                                    completionHandler(.success(configurationResponse))
                                }
                            } catch {
                                completionHandler(.failure(error))
                            }
                        }
                    case .failure(let error):
                        completionHandler(.failure(error))
                    }})
        } catch {
            completionHandler(.failure(error))
        }
    }
}

enum ConfigurationManagerError: Error {
    case accountNotSetup
}
