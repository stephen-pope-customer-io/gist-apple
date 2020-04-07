import Foundation

struct LogViewRequest: Codable {
    let messageId: String
    let userToken: String

    init(messageId: String, userToken: String) {
        self.messageId = messageId
        self.userToken = userToken
    }
}
