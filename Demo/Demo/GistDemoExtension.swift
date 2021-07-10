import Foundation
import Gist

public class GistDemoExtension: GistExtendable {
    public var name = "Gist Demo Extension"

    public required init(gist: Gist) {
        debugPrint("Initialized")
    }

    public func setup() {
        debugPrint("Setup")
    }

    public func messageShown(message: Message, userToken: String?) {
        debugPrint("Message \(message.messageId) shown")
    }

    public func messageDismissed(message: Message, userToken: String?) {
        debugPrint("Message \(message.messageId) dismissed")
    }

    public func actionPerformed(message: Message, userToken: String?, currentRoute: String, action: String) {
        debugPrint("Message \(message.messageId) had action \(action) performed")
    }

    public func embedMessage(message: Message, userToken: String?, elementId: String) {
        debugPrint("Message \(message.messageId) embed request on element \(elementId)")
    }
}
