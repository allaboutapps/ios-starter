import UIKit
import Toolbox

class AuthCoordinator: NavigationCoordinator {
    
    // MARK: Interface
    
    var onLogin: (() -> Void)?

    // MARK: - Init
    
    override init(navigationController: UINavigationController = UINavigationController()) {
        super.init(navigationController: navigationController)
        
        navigationController.isModalInPresentation = true
    }
    
    // MARK: Start
    
    override func start() {
        let viewController = LoginViewController.create()
        viewController.onLogin = onLogin

        push(viewController, animated: true)
    }
}
