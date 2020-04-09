import Foundation

public protocol GistExtendable {
    var name: String {get set}
    init(gist: Gist)
    func setup()
    func messageShown(messageId: String, userToken: String?)
    func messageDismissed(messageId: String, userToken: String?)
    func actionPerformed(action: String)
}
