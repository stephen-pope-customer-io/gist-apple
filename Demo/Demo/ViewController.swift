import UIKit
import Gist

class ViewController: UIViewController, GistDelegate {
    @IBOutlet weak var embeddedView: UIView!
    @IBOutlet weak var embeddedViewHeightConstraint: NSLayoutConstraint!
    
    weak var appDelegate = UIApplication.shared.delegate as? AppDelegate
    var gistView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let appDelegate = appDelegate {
            appDelegate.gist.setCurrentRoute("home")
            appDelegate.gist.setUserToken("BCD123")
            appDelegate.gist.subscribeToTopic("announcements")
            appDelegate.gist.subscribeToTopic("ios")
            appDelegate.gist.delegate = self
            
            let message = Message(messageId: "version-2-0")
            gistView = appDelegate.gist.getMessageView(message)
            embeddedView.addSubview(gistView)
            embeddedView.autoresizesSubviews = true
            gistView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
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
        embeddedViewHeightConstraint.constant = height
        updateViewConstraints()
    }

    func embedMessage(message: Message, elementId: String) {
        if let appDelegate = appDelegate {
            gistView = appDelegate.gist.getMessageView(message)
        }
    }

    func messageShown(message: Message) {}

    func messageDismissed(message: Message) {}

    func messageError(message: Message) {}

    func action(message: Message, currentRoute: String, action: String) {}
}
