import UIKit
import Toolbox
import {{cookiecutter.projectName}}Kit
import SwiftUI

class MainCoordinator: NavigationCoordinator {
    
    // MARK: Start
    
    override func start() {
        let viewModel = ExampleViewModel(title: "Main")
        let viewController = createExampleViewController(viewModel: viewModel)
        
        push(viewController, animated: true)
    }
    
    // MARK: Create
    
    private func createExampleViewController(viewModel: ExampleViewModel) -> ExampleViewController {
        let viewController = ExampleViewController.create(with: viewModel)
        
        viewController.onNext = { [weak self] in
            self?.showNext(title: viewModel.title)
        }
        
        viewController.onLogout = {
            CredentialsController.shared.currentCredentials = nil
        }
        
        viewController.onPopover = { [weak self] in
            self?.presentExampleScreen()
        }
        
        return viewController
    }
    
    // MARK: Show
    
    private func showNext(title: String) {
        let viewModel = ExampleViewModel(title: title + ".Push")
        let viewController = createExampleViewController(viewModel: viewModel)
        
        push(viewController, animated: true)
    }
    
    // MARK: Present
    
    private func presentExampleScreen() {
        let viewController = UIHostingController(rootView: ExampleScreen())
        
        viewController.rootView.onDismiss = { [weak self] in
            self?.dismiss(viewController, animated: true)
        }
        
        present(viewController, animated: true)
    }
}
