import UIKit
import {{cookiecutter.projectName}}Kit
import Toolbox

class DebugCoordinator: NavigationCoordinator {
    
    var onDismiss: (() -> Void)?
    
    override func start() {
        push()
    }
    
    private func push() {
        let viewModel = DebugViewModel(title: "Debug")
        let viewController = createDebugViewController(viewModel: viewModel)
        push(viewController, animated: true)
    }
    
    private func modal() {
        let coordinator = DebugCoordinator()
        coordinator.onDismiss = { [unowned self] in
           self.dismissChildCoordinator(animated: true)
        }
        coordinator.start()
        present(coordinator, animated: true)
    }
    
    private func pushCoordinator() {
        let coordinator = DebugCoordinator(navigationController: navigationController)
        coordinator.onDismiss = { [unowned self] in
            self.popCoordinator(animated: true)
        }
        coordinator.start()
        push(coordinator, animated: true)
    }
    
    private func createDebugViewController(viewModel: DebugViewModel) -> DebugViewController {
        let viewController = DebugViewController.create(with: viewModel)
        
        viewController.onModal = { [unowned self] in
            self.modal()
        }
        
        viewController.onPush = { [unowned self] in
            self.push()
        }
        
        viewController.onPop = { [unowned self] in
            self.popViewController(animated: true)
        }
        
        viewController.onPushCoordinator = { [unowned self] in
            self.pushCoordinator()
        }
        
        viewController.onDismiss = { [unowned self] in
            self.onDismiss?()
        }
        
        viewController.onLogout = {
            CredentialsController.shared.currentCredentials = nil
        }
        
        return viewController
    }
    
}
