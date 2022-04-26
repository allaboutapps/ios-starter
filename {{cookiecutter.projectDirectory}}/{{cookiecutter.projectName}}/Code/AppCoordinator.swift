import AuthFeature
import Combine
import MainFeature
import Networking
import Toolbox
import UIKit

class AppCoordinator: Coordinator {
    private var cancellable = Set<AnyCancellable>()
    
    static let shared = AppCoordinator()
    
    var window: UIWindow!
    let mainCoordinator = MainCoordinator()
    
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
            .store(in: &cancellable)

        if CredentialsController.shared.currentCredentials == nil {
            presentLogin(animated: false)
        }
    }
    
    func reset(animated: Bool) {
        childCoordinators
            .filter { $0 !== mainCoordinator }
            .forEach { removeChild($0) }
        
        mainCoordinator.reset(animated: animated)
        
        printRootDebugStructure()
    }
    
    private func presentLogin(animated: Bool) {
        let coordinator = AuthCoordinator()
        
        coordinator.onLogin = { [weak self] in
            self?.reset(animated: true)
        }
        
        coordinator.start()
        
        addChild(coordinator)
        window.topViewController()?.present(coordinator.rootViewController, animated: animated, completion: nil)
    }
}
