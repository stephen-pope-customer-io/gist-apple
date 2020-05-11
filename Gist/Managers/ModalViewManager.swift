import UIKit

class ModalViewManager {
    var window: UIWindow!
    var viewController: GistViewController!

    init(viewController: UIViewController) {
        self.viewController = GistViewController()
        self.viewController.engineViewController = viewController
        self.viewController.setup()
    }

    func showModalView(completionHandler: @escaping () -> Void) {
        self.viewController.view.isHidden = true
        self.window = getUIWindow()
        self.window.rootViewController = self.viewController
        self.window.isHidden = false

        self.viewController.view.center.y += self.viewController.view.bounds.height

        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseIn], animations: {
            self.viewController.view.center.y -= self.viewController.view.bounds.height
        }, completion: { _ in
            UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseIn], animations: {
                self.viewController.view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
            }, completion: nil)
            completionHandler()
        })

        self.viewController.view.isHidden = false
    }

    func dismissModalView(completionHandler: @escaping () -> Void) {
        UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseIn], animations: {
            self.viewController.view.backgroundColor = UIColor.black.withAlphaComponent(0)
        }, completion: { _ in
            UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseIn], animations: {
                self.viewController.view.center.y += self.viewController.view.bounds.height
            }, completion: { _ in
                self.window.isHidden = false
                self.viewController.removeFromParent()
                self.window = nil
                completionHandler()
            })
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
