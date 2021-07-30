import UIKit
import Gist

class ViewController: UIViewController, GistDelegate, GistViewDelegate {
    @IBOutlet weak var embeddedView: UIView!
    @IBOutlet weak var embeddedViewHeightConstraint: NSLayoutConstraint!

    weak var appDelegate = UIApplication.shared.delegate as? AppDelegate
    var embeddedMessage: Message!
    var gistView: GistView!

    override func viewDidLoad() {
        super.viewDidLoad()

        Gist.shared.setCurrentRoute("home")
        Gist.shared.setUserToken("ABC123")
        Gist.shared.subscribeToTopic("announcements")
        Gist.shared.subscribeToTopic("ios")
        Gist.shared.delegate = self

        embedMessage(message: Message(messageId: "example-notice"))
    }

    @IBAction func showMessage(_ sender: Any) {
        let message = Message(messageId: "artists")
        message.addProperty(key: "title", value: "Top Artists")
        message.addProperty(key: "list", value: ArtistsMock.data)
        let willShow = Gist.shared.showMessage(message, position: .center)
        debugPrint("Message \(willShow ? "will be shown" : "will not show")")
    }

    func sizeChanged(message: Message, width: CGFloat, height: CGFloat) {
        if message.instanceId == embeddedMessage.instanceId {
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
        gistView = Gist.shared.getMessageView(message)
        gistView.delegate = self
        embeddedView.addSubview(gistView)
        embeddedView.autoresizesSubviews = true
        gistView.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleRightMargin]
    }

    func messageShown(message: Message) {
        debugPrint("Message embedded: \(message.isEmbedded)")
    }

    func messageDismissed(message: Message) {}

    func messageError(message: Message) {}
}
