import UIKit

// MARK: - Coordinator

class Coordinator: NSObject {
    
    weak var parentCoordinator: Coordinator?
    var childCoordinators = [Coordinator]()
    let rootViewController: UIViewController
    
    init(rootViewController: UIViewController = UIViewController()) {
        self.rootViewController = rootViewController
    }
    
    func addChild(_ coordinator: Coordinator) {
        print("add child: \(String(describing: coordinator.self))")
        childCoordinators.append(coordinator)
        coordinator.parentCoordinator = self
    }
    
    func removeChild(_ coordinator: Coordinator) {
        if let index = childCoordinators.index(of: coordinator) {
            print("remove child: \(String(describing: coordinator.self))")
            let removedCoordinator = childCoordinators.remove(at: index)
            removedCoordinator.parentCoordinator = nil
        }
    }
    
    func removeAllChildren() {
        for coordinator in childCoordinators {
            removeChild(coordinator)
        }
    }
    
    // MARK: - Present
    
    func present(_ coordinator: Coordinator, animated: Bool, completion: (() -> Void)? = nil) {
        let viewController = coordinator.rootViewController
        
        addChild(coordinator)
        rootViewController.present(viewController, animated: animated, completion: completion)
    }
    
    func dismissChildCoordinator(animated: Bool, completion: (() -> Void)? = nil) {
        guard let coordinator = childCoordinators.first(where: { $0.rootViewController.presentingViewController != nil }) else { return }
        let viewController = coordinator.rootViewController
        
        print("dismiss coordinator")
        
        viewController.presentingViewController?.dismiss(animated: animated, completion: { [weak self] in
            self?.removeChild(coordinator)
            completion?()
        })
    }
    
    // MARK: - Debug
    
    func debugStructure(level: Int = 0) -> String {
        let tabsRoot = String(repeating: "\t", count: level)
        let tabs = String(repeating: "\t", count: level + 1)
        
        var output = tabsRoot + "{\n"
        
        output += debugInfo(level: level)
        
        if let parentCoordinator = parentCoordinator {
            output += tabs + "- parent: \(parentCoordinator)\n"
        }
        
        if !childCoordinators.isEmpty {
            output += tabs + "- childs:\n"
            output += tabs + "[\n"
            output += childCoordinators
                .map { $0.debugStructure(level: level + 2) }
                .joined(separator: ",\n")
            output += "\n\(tabs)]\n"
        }
        output += tabsRoot + "}"
        return output
    }
    
    func debugInfo(level: Int) -> String {
        var output = ""
        let tabs = String(repeating: "\t", count: level + 1)
        output += tabs + "* \(self)\n"
        return output
    }
    
    func printRootDebugStructure() {
        if let parentCoordinator = parentCoordinator {
            parentCoordinator.printRootDebugStructure()
        } else {
            print(debugStructure())
        }
    }
    
    deinit {
        print("deinit coordinator: \(String(describing: self))")
    }
}
