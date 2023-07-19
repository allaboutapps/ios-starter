import SwiftUI
import Toolbox
import UIKit

public class ForceUpdateCoordinator: NavigationCoordinator {

    // MARK: Init

    private let appStoreURL: URL?

    public init(appStoreURL: URL?) {
        self.appStoreURL = appStoreURL

        let navigationController = UINavigationController()
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.setNavigationBarHidden(true, animated: false)

        super.init(navigationController: navigationController)
    }

    // MARK: Start

    override public func start() {
        let viewController = UIHostingController(rootView: ForceUpdateScreen(appStoreURL: appStoreURL))
        push(viewController, animated: false)
    }
}
