import AuthFeature
import Combine
import ForceUpdateFeature
import MainFeature
import Networking
import Toolbox
import UIKit
import Utilities

class AppCoordinator: Coordinator {

    // MARK: Init

    override private init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }

    // MARK: Properties

    static let shared = AppCoordinator(rootViewController: .init())

    private(set) var window: UIWindow!
    private var cancellables = Set<AnyCancellable>()
    private let mainCoordinator = MainCoordinator(tabBarController: .init())
    private var forceUpdateWindow: ForceUpdateWindow?

    // MARK: Start

    func start(window: UIWindow) {
        self.window = window

        mainCoordinator.start()
        addChild(mainCoordinator)

        window.rootViewController = mainCoordinator.rootViewController
        window.makeKeyAndVisible()

        printRootDebugStructure()

        CredentialsController.shared.currentCredentialsDidChange
            .sink { [weak self] credentials in
                if credentials == nil {
                    self?.presentLogin(animated: true)
                }
            }
            .store(in: &cancellables)

        if CredentialsController.shared.currentCredentials == nil {
            presentLogin(animated: false)
        }

        if AppEnvironment.current.buildConfig != .debug {
            Task {
                for await url in ForceUpdateController.shared.onForceUpdateNeededAsyncSequence {
                    self.presentForceUpdate(url: url)
                }
            }
        }
    }

    // MARK: Present

    private func presentLogin(animated: Bool) {
        let coordinator = AuthCoordinator(navigationController: .init())

        coordinator.onLogin = { [weak self] in
            self?.reset(animated: true)
        }

        coordinator.start()

        addChild(coordinator)
        window.topViewController()?.present(coordinator.rootViewController, animated: animated, completion: nil)
    }

    private func presentForceUpdate(url: URL?) {
        guard forceUpdateWindow == nil else { return }
        forceUpdateWindow = ForceUpdateWindow(appStoreURL: url)
        forceUpdateWindow?.start()
    }

    // MARK: Helpers

    func reset(animated: Bool) {
        childCoordinators
            .filter { $0 !== mainCoordinator }
            .forEach { removeChild($0) }

        mainCoordinator.reset(animated: animated)

        printRootDebugStructure()
    }
}
