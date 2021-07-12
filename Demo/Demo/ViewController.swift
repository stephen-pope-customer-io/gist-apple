import UIKit
import Gist

class ViewController: UIViewController, GistDelegate {
    weak var appDelegate = UIApplication.shared.delegate as? AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate?.gist.setCurrentRoute("home")
        appDelegate?.gist.setUserToken("BCD123")
        appDelegate?.gist.subscribeToTopic("announcements")
        appDelegate?.gist.subscribeToTopic("ios")
        appDelegate?.gist.delegate = self
    }

    @IBAction func showMessage(_ sender: Any) {
        if let appDelegate = appDelegate {
            let message = Message(messageId: "artists")
            message.addProperty(key: "title", value: "Top Artists")
            message.addProperty(key: "list", value: ArtistsMock.data)
            let willShow = appDelegate.gist.showMessage(message, position: .center)
            debugPrint("Message \(willShow ? "will be shown" : "will not show")")
        }
    }

    func sizeChanged(message: Message, width: CGFloat, height: CGFloat) {}

    func embedMessage(message: Message, elementId: String) {
        if let appDelegate = appDelegate {
            let messageView = appDelegate.gist.getMessageView(message)
            self.view.addSubview(messageView)

            messageView.translatesAutoresizingMaskIntoConstraints = false
            let horizontalConstraint = NSLayoutConstraint(item: messageView,
                                                          attribute: NSLayoutConstraint.Attribute.centerX,
                                                          relatedBy: NSLayoutConstraint.Relation.equal,
                                                          toItem: view,
                                                          attribute: NSLayoutConstraint.Attribute.centerX,
                                                          multiplier: 1,
                                                          constant: 0)

            let verticalConstraint = NSLayoutConstraint(item: messageView,
                                                        attribute: NSLayoutConstraint.Attribute.centerY,
                                                        relatedBy: NSLayoutConstraint.Relation.equal,
                                                        toItem: view,
                                                        attribute: NSLayoutConstraint.Attribute.centerY,
                                                        multiplier: 1,
                                                        constant: 200)

            let widthConstraint = NSLayoutConstraint(item: messageView,
                                                     attribute: NSLayoutConstraint.Attribute.width,
                                                     relatedBy: NSLayoutConstraint.Relation.equal,
                                                     toItem: nil,
                                                     attribute: NSLayoutConstraint.Attribute.notAnAttribute,
                                                     multiplier: 1,
                                                     constant: 350)

            let heightConstraint = NSLayoutConstraint(item: messageView,
                                                      attribute: NSLayoutConstraint.Attribute.height,
                                                      relatedBy: NSLayoutConstraint.Relation.greaterThanOrEqual,
                                                      toItem: nil,
                                                      attribute: NSLayoutConstraint.Attribute.notAnAttribute,
                                                      multiplier: 1,
                                                      constant: 350)

            view.addConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
        }
    }

    func messageShown(message: Message) {}

    func messageDismissed(message: Message) {}

    func messageError(message: Message) {}

    func action(message: Message, currentRoute: String, action: String) {}
}
