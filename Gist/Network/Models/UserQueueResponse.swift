import Foundation

struct UserQueueResponse: Codable {
    let route: String

    init(route: String) {
        self.route = route
    }
}
