import UIKit
import Toolbox
import {{cookiecutter.projectName}}Kit
import SwiftUI

class MainCoordinator: NavigationCoordinator {
    
    // MARK: Start
    
    override func start() {
        let viewModel = {{cookiecutter.projectName}}ViewModel(title: "Main")
        let viewController = create{{cookiecutter.projectName}}ViewController(viewModel: viewModel)
        
        push(viewController, animated: true)
    }
    
    // MARK: Create
    
    private func create{{cookiecutter.projectName}}ViewController(viewModel: {{cookiecutter.projectName}}ViewModel) -> {{cookiecutter.projectName}}ViewController {
        let viewController = {{cookiecutter.projectName}}ViewController.create(with: viewModel)
        
        viewController.onNext = { [weak self] in
            self?.showNext(title: viewModel.title)
        }
        
        viewController.onLogout = {
            CredentialsController.shared.currentCredentials = nil
        }
        
        viewController.onPopover = { [weak self] in
            self?.presentPopover()
        }
        
        return viewController
    }
    
    // MARK: Show
    
    private func showNext(title: String) {
        let viewModel = {{cookiecutter.projectName}}ViewModel(title: title + ".Push")
        let viewController = create{{cookiecutter.projectName}}ViewController(viewModel: viewModel)
        
        push(viewController, animated: true)
    }
    
    // MARK: Present
    
    private func presentPopover() {
        let viewController = UIHostingController(rootView: ExampleScreen())
        
        viewController.rootView.onDismiss = { [weak self] in
            self?.dismiss(viewController, animated: true)
        }
        
        present(viewController, animated: true)
    }
}
