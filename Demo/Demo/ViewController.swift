import UIKit
import Gist

class ViewController: UIViewController {
    weak var appDelegate = UIApplication.shared.delegate as? AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate?.gist.setUserToken("BCD123")
        appDelegate?.gist.subscribeToTopic("announcements")
        appDelegate?.gist.subscribeToTopic("ios")
    }

    @IBAction func showMessage(_ sender: Any) {
        if let appDelegate = appDelegate {
            let message = Message(messageId: "artists")
            message.addProperty(key: "title", value: "Top Artists")
            message.addProperty(key: "list", value: ArtistsMock.data)
            let willShowMessage = appDelegate.gist.showMessage(message)
            debugPrint("Message \(willShowMessage ? "will be shown" : "will not show")")
        }
    }
}
