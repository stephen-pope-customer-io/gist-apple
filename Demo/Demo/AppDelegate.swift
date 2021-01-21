import UIKit
import Gist

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var gist: Gist!
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        gist = Gist(organizationId: "c6ff92b9-5607-4655-9265-f2588f7e3b58", logging: true)
        gist.setup()

        return true
    }

    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication,
                     didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}
