import Foundation

class TopicsManager {
    private static var topics = [String]()

    static func getTopics() -> [String] {
        return topics
    }

    static func subscribeToTopic(_ topic: String) {
        topics.append(topic)
    }

    static func unsubscribeFromTopic(_ topic: String) {
        if let index = topics.firstIndex(of: topic) {
            topics.remove(at: index)
        }
    }

    static func clearTopics() {
        topics.removeAll()
    }
}
