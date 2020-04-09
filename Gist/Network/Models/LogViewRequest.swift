import Foundation

struct LogViewRequest: Encodable {
    let messageId: String
    let userToken: String?

    init(messageId: String, userToken: String?) {
        self.messageId = messageId
        self.userToken = userToken
    }
}
