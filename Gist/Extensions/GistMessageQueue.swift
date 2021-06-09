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
                    guard let firstMessage = responses.first else { return }
                    _ = self.gist.showMessage(firstMessage.toMessage())
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
