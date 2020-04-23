import Foundation

public protocol GistExtendable {
    var name: String {get set}
    init(gist: Gist)
    func setup()
    func messageShown(messageRoute: String, userToken: String?)
    func messageDismissed(messageRoute: String, userToken: String?)
    func actionPerformed(action: String)
}
