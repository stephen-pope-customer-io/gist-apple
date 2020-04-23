import Foundation

struct LogViewRequest: Encodable {
    let route: String
    let userToken: String?

    init(route: String, userToken: String?) {
        self.route = route
        self.userToken = userToken
    }
}
