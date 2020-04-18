import UIKit

class ViewController: UIViewController {
    weak var appDelegate = UIApplication.shared.delegate as? AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate?.gist.setUserToken(userToken: "ABC123")
    }

    @IBAction func showMessage(_ sender: Any) {
        if let appDelegate = appDelegate {
            let willShowMessage = appDelegate.gist.showMessage(messageId: "expired")
            debugPrint("Message \(willShowMessage ? "will be shown" : "will not show")")
        }
    }
}
