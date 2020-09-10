import UIKit
import Toolbox

class AuthCoordinator: NavigationCoordinator {
    
    public var onLogin: VoidClosure?
    
    override func start() {
        let viewController = LoginViewController.create()
        viewController.onLogin = onLogin

        push(viewController, animated: true)
    }
}
