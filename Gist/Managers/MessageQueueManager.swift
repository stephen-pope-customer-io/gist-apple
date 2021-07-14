import Foundation

class MessageQueueManager {
    private var queueTimer: Timer!

    func setup() {
        queueTimer = Timer.scheduledTimer(timeInterval: 10,
                                          target: self,
                                          selector: #selector(checkForMessages),
                                          userInfo: nil,
                                          repeats: true)
    }

    @objc
    private func checkForMessages() {
        Logger.instance.info(message: "Checking Gist queue service")
        if let userToken = UserManager().getUserToken() {
            QueueManager(organizationId: Gist.shared.organizationId)
                .fetchUserQueue(userToken: userToken, topics: TopicsManager.getTopics(), completionHandler: { response in
                switch response {
                case .success(let responses):
                    Logger.instance.info(message: "Gist queue service found \(responses.count) new messages")
                    for queueMessage in responses {
                        let message = queueMessage.toMessage()
                        let position = message.gistProperties.position

                        if let routeRule = message.gistProperties.routeRule {
                            let cleanRouteRule = routeRule.replacingOccurrences(of: "\\", with: "/")
                            if let regex = try? NSRegularExpression(pattern: cleanRouteRule) {
                                let range = NSRange(location: 0, length: Gist.shared.getCurrentRoute().utf16.count)
                                if regex.firstMatch(in: Gist.shared.getCurrentRoute(), options: [], range: range) == nil {
                                    Logger.instance.debug(message:
                                        "Current route is \(Gist.shared.getCurrentRoute()), needed \(cleanRouteRule)")
                                    continue
                                }
                            } else {
                                Logger.instance.info(message:
                                    "Problem processing route rule message regex: \(cleanRouteRule)")
                                continue
                            }
                        }

                        if let elementId = message.gistProperties.elementId {
                            Logger.instance.info(message: "Embedding message with Element Id \(elementId)")
                            Gist.shared.embedMessage(message: message, elementId: elementId)
                            continue
                        } else {
                            _ = Gist.shared.showMessage(message, position: position)
                        }
                        break
                    }
                case .failure(let error):
                    Logger.instance.error(message:
                        "Error fetching messages from Gist queue service. \(error.localizedDescription)")
                }
            })
        } else {
            Logger.instance.debug(message: "User token not set, skipping fetch user queue.")
        }
    }
}
