import Foundation

struct MessagesRequest: Codable {
    let topics: [String]

    init(topics: [String]) {
        self.topics = topics
    }
}
