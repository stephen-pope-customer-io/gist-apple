import UIKit

class ModalViewManager {
    var window: UIWindow!
    let viewController: UIViewController

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    func showModalView(completionHandler: @escaping () -> Void) {
        viewController.view.isHidden = true
        self.window = getUIWindow()
        self.window.rootViewController = viewController
        self.window.isHidden = false

        viewController.view.center.y += viewController.view.bounds.height

        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseIn], animations: {
            self.viewController.view.center.y -= self.viewController.view.bounds.height
            self.viewController.view.layoutIfNeeded()
        }, completion: { _ in
            UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseIn], animations: {
                self.viewController.view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
            }, completion: nil)
            completionHandler()
        })

        viewController.view.isHidden = false
    }

    func dismissModelView(completionHandler: @escaping () -> Void) {
        self.window = getUIWindow()
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseIn], animations: {
            self.viewController.view.center.y -= self.viewController.view.bounds.height
            self.viewController.view.layoutIfNeeded()
        }, completion: { _ in
            self.window.isHidden = false
            completionHandler()
        })
    }

    func getUIWindow() -> UIWindow {
        var modalWindow = UIWindow(frame: UIScreen.main.bounds)
        if #available(iOS 13.0, *) {
            for connectedScene in UIApplication.shared.connectedScenes
                where connectedScene.activationState == .foregroundActive {
                if let windowScene = connectedScene as? UIWindowScene {
                    modalWindow = UIWindow(windowScene: windowScene)
                }
            }
        }
        modalWindow.windowLevel = .normal
        return modalWindow
    }
}
