import UIKit
import Toolkit

class AuthCoordinator: NavigationCoordinator {
    
    var onLogin: (() -> Void)?
    
    override func start() {
        let viewController = LoginViewController.create()
        viewController.onLogin = onLogin

        push(viewController, animated: true)
    }
}
