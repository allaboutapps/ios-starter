import Foundation
import Toolkit

class {{cookiecutter.projectName}}TabBarCoordinator: TabBarCoordinator {

    enum Tab: CaseIterable {
        case coordinator1
        case coordinator2
        case coordinator3
    }

    private let cooridnators: [Coordinator] 

    override init(tabBarController: UITabBarController = UITabBarController()) {
        cooridnators = Tab.allCases.map { $0.coordinator }
        super.init(tabBarController: tabBarController) 
    }
    
    override func start() {
        coordinators.forEach { $0.start() }
        coordinators.viewControllers = coordinators.map { $0.rootViewController }
    }

    func setTab(_ tab: Tab) { 
        tabBarController.selectedIndex = tab.rawValue
    }
}

private extension MainCoordinator.Tab {

    var coordinator: Coordinator { 
        switch self {
        case coordinator1: Coordinator1()
        case coordinator2: Coordinator2()
        case coordinator3: coordinator3()
        }
    }
}
