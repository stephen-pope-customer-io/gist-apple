import Foundation
import Alamofire

class Bootstrap {
    let organizationId: String
    let extensions: [GistExtendable]

    init(organizationId: String, extensions: [GistExtendable]) {
        self.organizationId = organizationId
        self.extensions = extensions
    }

    func setup(completionHandler: @escaping (Result<Configuration, Error>) -> Void) {
        Logger.instance.debug(message: "Starting Bootstrap")
        ConfigurationManager(organizationId: organizationId).fetchConfiguration { response in
            switch response {
            case .success(let configurationResponse):
                // Create configuration object to initialize Bourbon Engine later on
                let configuration = Configuration(organizationId: self.organizationId,
                                                  engineEndpoint: configurationResponse.engineEndpoint,
                                                  identityEndpoint: configurationResponse.identityEndpoint,
                                                  projectId: configurationResponse.projectId)
                // Initialize Gist extentions
                for gistExtension in self.extensions {
                    gistExtension.setup()
                    Logger.instance.info(message: "Extension \(gistExtension.name) setup")
                }
                completionHandler(.success(configuration))
                Logger.instance.debug(message: "Bootstrap Complete")
            case .failure(let error):
                Logger.instance.error(message: "Failed to fetch configuration: \(error)")
                completionHandler(.failure(error))
            }
        }
    }
}
