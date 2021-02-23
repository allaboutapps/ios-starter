import {{cookiecutter.projectName}}Kit
import Combine
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
        
        checkCredentials(animated: false)
        
        CredentialsController.shared.$currentCredentialsChanged
            .sink { [weak self] isChanged in
                if isChanged {
                    self?.checkCredentials()
                }
            }
            .store(in: &cancellable)
    }
    
    func checkCredentials(animated: Bool = true) {
        if CredentialsController.shared.currentCredentials == nil { // not logged in
            presentLogin(animated: animated)
        }
    }
    
    func reset(animated: Bool) {
        childCoordinators
            .filter { $0 !== mainCoordinator }
            .forEach { removeChild($0) }
        
        mainCoordinator.popToRoot(animated: animated)
        
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
