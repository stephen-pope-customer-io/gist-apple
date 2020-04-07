import Foundation

struct UserQueueResponse: Codable {
    let messageId: String

    init(messageId: String) {
        self.messageId = messageId
    }
}
