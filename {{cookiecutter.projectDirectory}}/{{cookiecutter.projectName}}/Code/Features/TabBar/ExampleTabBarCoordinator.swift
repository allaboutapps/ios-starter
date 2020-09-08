import UIKit
import Toolkit

class {{cookiecutter.projectName}}TabBarCoordinator: TabBarCoordinator {

    enum Tab: Int, CaseIterable {
        case coordinator1 = 0
        case coordinator2
        case coordinator3
    }

    private let coordinators: [Coordinator] 

    override init(tabBarController: UITabBarController = UITabBarController()) {
        cooridnators = Tab.allCases.map { $0.coordinator }
        super.init(tabBarController: tabBarController) 
    }
    
    override func start() {
        coordinators.forEach { $0.start() }
        tabBarController.viewControllers = coordinators.map { $0.rootViewController }
    }

    func setTab(_ tab: Tab) { 
        tabBarController.selectedIndex = tab.rawValue
    }
}

private extension {{cookiecutter.projectName}}TabBarCoordinator.Tab {
    var coordinator: Coordinator {
        switch self {
        case .coordinator1: return DebugCoordinator()
        case .coordinator2: return MoreCoordinator()
        case .coordinator3: return MainCoordinator()
        }
    }
}
