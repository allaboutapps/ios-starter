import ForceUpdateFeature
import Toolbox
import UIKit
import Utilities

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)

        AppCoordinator.shared.start(window: window)

        self.window = window
        window.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_: UIScene) {
    }

    func sceneDidBecomeActive(_: UIScene) {
    }

    func sceneWillResignActive(_: UIScene) {
    }

    func sceneWillEnterForeground(_: UIScene) {
        guard AppEnvironment.current.buildConfig != .debug else { return }

        Task {
            await ForceUpdateController.shared.checkForUpdate()
        }
    }

    func sceneDidEnterBackground(_: UIScene) {
    }
}
