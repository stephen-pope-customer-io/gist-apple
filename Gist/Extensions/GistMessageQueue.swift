import Foundation

class GistMessageQueue: GistExtendable {
    var name = "Gist Message Queue"
    private var gist: Gist
    private var queueTimer: Timer!

    required init(gist: Gist) {
        self.gist = gist
    }

    func setup() {
        queueTimer = Timer.scheduledTimer(timeInterval: 10,
                                          target: self,
                                          selector: #selector(checkForMessages),
                                          userInfo: nil,
                                          repeats: true)
    }

    @objc
    func checkForMessages() {
        Logger.instance.debug(message: "Checking for new messages with service: \(name)")
        if let userToken = UserManager().getUserToken() {
            QueueManager(organizationId: gist.organizationId)
                .fetchUserQueue(userToken: userToken, topics: TopicsManager.getTopics(), completionHandler: { response in
                switch response {
                case .success(let responses):
                    Logger.instance.debug(message: "Service \(self.name) found \(responses.count) new messages")
                    for queueMessage in responses {
                        let message = queueMessage.toMessage()
                        let position = message.gistProperties.position

                        if let routeRule = message.gistProperties.routeRule {
                            let cleanRouteRule = routeRule.replacingOccurrences(of: "\\", with: "/")
                            if let regex = try? NSRegularExpression(pattern: cleanRouteRule) {
                                let range = NSRange(location: 0, length: self.gist.getCurrentRoute().utf16.count)
                                if regex.firstMatch(in: self.gist.getCurrentRoute(), options: [], range: range) == nil {
                                    continue
                                }
                            } else {
                                continue
                            }
                        }

                        if let elementId = message.gistProperties.elementId {
                            Logger.instance.info(message: "Embedding message inside \(elementId)")
                            self.gist.delegate?.embedMessage(message: message, elementId: elementId)
                            continue
                        } else {
                            _ = self.gist.showMessage(message, position: position)
                        }
                        break
                    }
                case .failure(let error):
                    Logger.instance.error(message:
                        "Error fetching messages from service \(self.name). \(error.localizedDescription)")
                }
            })
        } else {
            Logger.instance.debug(message: "User token not set, skipping fetch user queue.")
        }
    }

    func messageShown(message: Message, userToken: String?) {}
    func messageDismissed(message: Message, userToken: String?) {}
    func actionPerformed(currentRoute: String, action: String) {}
}
