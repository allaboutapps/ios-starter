import Assets
import ExampleFeature
import Toolbox
import UIKit

public class MainCoordinator: TabBarCoordinator {

    // MARK: - Properties

    private lazy var firstCoordinator = ExampleCoordinator(title: Strings.mainTabFirst)
    private lazy var secondCoordinator = ExampleCoordinator(title: Strings.mainTabSecond)

    // MARK: - Tabs

    private enum Tab: Int, CaseIterable {
        case first = 0
        case second
    }

    private func setupTabs() {
        addChild(firstCoordinator)
        addChild(secondCoordinator)

        firstCoordinator.start()
        secondCoordinator.start()

        tabBarController.viewControllers = [
            firstCoordinator.rootViewController,
            secondCoordinator.rootViewController,
        ]

        tabBarController.selectedIndex = 0
        tabBarController.tabBar.tintColor = UIColor.brandPrimary
    }

    // MARK: - Coordinator Start

    override public func start() {
        setupTabs()
    }

    public func reset(animated: Bool) {
        childCoordinators.forEach { 
            ($0 as? NavigationCoordinator)?.popToRoot(animated: animated)
        }
        tabBarController.selectedIndex = 0
    }

    // MARK: - Helpers

    private func setTab(_ tab: Tab) {
        tabBarController.selectedIndex = tab.rawValue
    }
}
