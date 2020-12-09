import UIKit
import Gist

class ViewController: UIViewController {
    weak var appDelegate = UIApplication.shared.delegate as? AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate?.gist.setUserToken("ABC123")
        appDelegate?.gist.subscribeToTopic("testing")
    }

    @IBAction func showMessage(_ sender: Any) {
        if let appDelegate = appDelegate {
            let message = Message(messageId: "welcome")
            message.addProperty(key: "name", value: "Paul")
            let willShowMessage = appDelegate.gist.showMessage(message)
            debugPrint("Message \(willShowMessage ? "will be shown" : "will not show")")
        }
    }
}
