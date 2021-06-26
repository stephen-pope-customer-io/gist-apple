public protocol GistDelegate: AnyObject {
    func embedMessage(message: Message, elementId: String)
    func messageShown(message: Message)
    func messageDismissed(message: Message)
    func messageError(message: Message)
    func action(currentRoute: String, action: String)
}
