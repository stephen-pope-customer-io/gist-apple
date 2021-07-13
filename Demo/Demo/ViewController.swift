import UIKit
import Gist

class ViewController: UIViewController, GistDelegate {
    @IBOutlet weak var embeddedView: UIView!
    @IBOutlet weak var embeddedViewHeightConstraint: NSLayoutConstraint!
    
    weak var appDelegate = UIApplication.shared.delegate as? AppDelegate
    var embeddedMessage: Message!
    var gistView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let appDelegate = appDelegate {
            appDelegate.gist.setCurrentRoute("home")
            appDelegate.gist.setUserToken("BCD123")
            appDelegate.gist.subscribeToTopic("announcements")
            appDelegate.gist.subscribeToTopic("ios")
            appDelegate.gist.delegate = self
            
            embedMessage(message: Message(messageId: "example-notice"))
        }
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

    func sizeChanged(message: Message, width: CGFloat, height: CGFloat) {
        if (message.instanceId == embeddedMessage.instanceId) {
            embeddedViewHeightConstraint.constant = height
            updateViewConstraints()
        }
    }

    func embedMessage(message: Message, elementId: String) {
        embedMessage(message: message)
    }

    func action(message: Message, currentRoute: String, action: String) {
        if action == GistMessageActions.close.rawValue, message.instanceId == embeddedMessage.instanceId {
            gistView.removeFromSuperview()
            embeddedViewHeightConstraint.constant = 0
        }
    }

    private func embedMessage(message: Message) {
        embeddedMessage = message
        gistView = appDelegate?.gist.getMessageView(message)
        embeddedView.addSubview(gistView)
        embeddedView.autoresizesSubviews = true
        gistView.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleRightMargin]
    }

    func messageShown(message: Message) {}

    func messageDismissed(message: Message) {}

    func messageError(message: Message) {}
}
