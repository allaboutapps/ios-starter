import UIKit
import {{cookiecutter.projectName}}Kit
import Toolbox

class MoreCoordinator: NavigationCoordinator {
    
    var onDone: (() -> Void)?
    
    override func start() {
        let viewController = MoreViewController.create()
        
        if onDone != nil {
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        }

        push(viewController, animated: true)
    }
    
    @objc private func done() {
        onDone?()
    }
    
}
