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
                .fetchUserQueue(userToken: userToken, completionHandler: { response in
                switch response {
                case .success(let responses):
                    Logger.instance.debug(message: "Service \(self.name) found \(responses.count) new messages")
                    guard let firstMessage = responses.first else { return }
                    self.gist.showMessage(messageId: firstMessage.messageId)
                case .failure(let error):
                    Logger.instance.error(message:
                        "Error fetching messages from service \(self.name). \(error.localizedDescription)")
                }
            })
        } else {
            Logger.instance.debug(message: "User token not set, skipping fetch user queue.")
        }
    }

    func messageShown(messageId: String, userToken: String?) {
        LogManager(organizationId: gist.organizationId)
            .logView(messageId: messageId, userToken: userToken) { response in
                if case let .failure(error) = response {
                    Logger.instance.error(message:
                        "Failed to log view for message id: \(messageId) with error: \(error)")
                }
        }
    }
    
    func messageDismissed(messageId: String, userToken: String?) {}
    func actionPerformed(action: String) {}
}
