public protocol GistDelegate: AnyObject {
    func messageShown(messageId: String)
    func action(action: String)
}
