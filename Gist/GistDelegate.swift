public protocol GistDelegate: AnyObject {
    func messageShown(message: Message)
    func messageDismissed(message: Message)
    func messageError(message: Message)
    func action(currentRoute: String, action: String)
}
