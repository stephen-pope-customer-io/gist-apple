import Foundation

struct ConfigurationResponse: Codable {
    let engineEndpoint: String
    let identityEndpoint: String
    let projectId: String

    init(engineEndpoint: String, identityEndpoint: String, projectId: String) {
        self.engineEndpoint = engineEndpoint
        self.identityEndpoint = identityEndpoint
        self.projectId = projectId
    }
}
