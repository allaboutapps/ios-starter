import Assets
import DebugFeature
import Networking
import SwiftUI
import Toolbox
import UIKit

public class ExampleCoordinator: NavigationCoordinator {

    // MARK: Init

    public init(title: String, navigationController: UINavigationController = UINavigationController()) {
        super.init(navigationController: navigationController)

        navigationController.tabBarItem.title = title
        navigationController.tabBarItem.image = UIImage(systemName: "star")
        navigationController.tabBarItem.selectedImage = UIImage(systemName: "star.fill")
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.navigationBar.tintColor = UIColor.brandPrimary
    }

    // MARK: Start

    override public func start() {
        let viewController = UIHostingController(
            rootView: ExampleScreen(
                outAction: { [weak self] action in
                    switch action {
                    case .debug:
                        self?.presentDebug()
                    }
                }
            )
        )

        viewController.navigationItem.title = Strings.exampleTitle
        viewController.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "rectangle.portrait.and.arrow.right"), style: .plain, target: self, action: #selector(logout))
        viewController.navigationItem.largeTitleDisplayMode = .always

        push(viewController, animated: false)
    }

    // MARK: Present

    private func presentDebug() {
        let coordinator = DebugCoordinator(
            outAction: { [weak self] action in
                switch action {
                case .close:
                    self?.dismissChildCoordinator(animated: true)
                }
            }
        )

        coordinator.start()
        present(coordinator, animated: true)
    }

    // MARK: Helpers

    @objc private func logout() {
        CredentialsController.shared.currentCredentials = nil
    }
}
