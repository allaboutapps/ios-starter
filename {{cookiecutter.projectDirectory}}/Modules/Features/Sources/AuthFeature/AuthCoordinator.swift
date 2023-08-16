import Toolbox
import UIKit

public class AuthCoordinator: NavigationCoordinator {
    
    // MARK: Interface
        
    public var onLogin: (() -> Void)?

    // MARK: - Init
        
    override public init(navigationController: UINavigationController) {
        super.init(navigationController: navigationController)            
        navigationController.isModalInPresentation = true
    }
    
    // MARK: Start
    
    override public func start() {
        let viewController = LoginViewController.create()
        viewController.onLogin = onLogin
        
        push(viewController, animated: false)
    }
}
