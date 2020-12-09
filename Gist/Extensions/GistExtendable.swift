import Foundation

public protocol GistExtendable {
    var name: String {get set}
    init(gist: Gist)
    func setup()
    func messageShown(message: Message, userToken: String?)
    func messageDismissed(message: Message, userToken: String?)
    func actionPerformed(currentRoute: String, action: String)
}
