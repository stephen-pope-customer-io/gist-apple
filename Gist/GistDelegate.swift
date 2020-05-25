public protocol GistDelegate: AnyObject {
    func messageShown(messageRoute: String)
    func messageDismissed(messageRoute: String)
    func messageError(messageRoute: String)
    func action(currentRoute: String, action: String)
}
