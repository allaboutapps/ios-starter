import Foundation
import UIKit

@MainActor
public class ForceUpdateWindow {

    // MARK: Init

    public init(appStoreURL: URL?) {
        navigationCoordinator = ForceUpdateNavigationCoordinator(appStoreURL: appStoreURL)
    }

    // MARK: Properties

    private let navigationCoordinator: ForceUpdateNavigationCoordinator
    private var window: UIWindow!

    // MARK: Start

    public func start() {
        navigationCoordinator.start()

        let windowScene = UIApplication.shared
            .connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .first

        if let windowScene = windowScene as? UIWindowScene {
            window = UIWindow(windowScene: windowScene)
        } else {
            window = UIWindow(frame: UIScreen.main.bounds)
        }

        let viewController = UIViewController()
        viewController.view.backgroundColor = .clear

        window.rootViewController = viewController
        window.windowLevel = UIWindow.Level.alert + 1
        window.makeKeyAndVisible()

        viewController.present(navigationCoordinator.rootViewController, animated: true)
    }
}
