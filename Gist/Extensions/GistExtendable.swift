import Foundation

public protocol GistExtendable {
    var name: String {get set}
    init(gist: Gist)
    func setup()
    func messageShown(message: Message, userToken: String?)
    func messageDismissed(message: Message, userToken: String?)
    func actionPerformed(message: Message, userToken: String?, currentRoute: String, action: String)
    func embedMessage(message: Message, userToken: String?, elementId: String)
}
