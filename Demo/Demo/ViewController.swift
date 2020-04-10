import UIKit

class ViewController: UIViewController {
    weak var appDelegate = UIApplication.shared.delegate as? AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate?.gist.setUserToken(userToken: "ABC123")
    }

    @IBAction func showMessage(_ sender: Any) {
        if let appDelegate = appDelegate {
            let messageShown = appDelegate.gist.showMessage(messageId: "expired")
            debugPrint("Message \(messageShown ? "will shown" : "will not show")")
        }
    }
}
