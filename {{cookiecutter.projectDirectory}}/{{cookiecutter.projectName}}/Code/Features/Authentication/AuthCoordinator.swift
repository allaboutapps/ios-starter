import UIKit
import Toolbox

class AuthCoordinator: NavigationCoordinator {
    
    // MARK: Interface
    
    var onLogin: (() -> Void)?
    
    // MARK: Start
    
    override func start() {
        let viewController = LoginViewController.create()
        viewController.onLogin = onLogin

        push(viewController, animated: true)
    }
}
