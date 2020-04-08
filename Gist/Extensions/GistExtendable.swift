import Foundation

public protocol GistExtendable {
    var name: String {get set}
    func setup()
    func messageShown(messageId: String, userToken: String?)
    func actionPerformed(action: String)
}
