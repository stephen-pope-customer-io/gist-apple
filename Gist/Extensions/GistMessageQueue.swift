import Foundation

class GistMessageQueue: GistExtendable {
    var name = "Gist Message Queue"

    func setup() {}
    func messageShown(messageId: String, userToken: String?) {}
    func actionPerformed(action: String) {}
}
