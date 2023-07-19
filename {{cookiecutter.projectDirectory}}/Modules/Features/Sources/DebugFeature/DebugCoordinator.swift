import Assets
import SwiftUI
import Toolbox
import UIKit

public class DebugCoordinator: NavigationCoordinator {

    // MARK: Init

    public enum OutAction {
        case close
    }

    private let sendOutAction: (OutAction) -> Void
    private let sections: [FinalDebugSection]

    public init(outAction: @escaping (OutAction) -> Void) {
        sendOutAction = outAction
        sections = Services.shared[DebugController.self].renderDebugSections()

        let navigationController = UINavigationController()
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.navigationBar.tintColor = UIColor.brandPrimary

        super.init(navigationController: navigationController)
    }

    // MARK: Properties

    private lazy var closeButton = UIBarButtonItem(
        systemItem: .close,
        primaryAction: .init(handler: { [weak self] _ in
            self?.sendOutAction(.close)
        })
    )

    private lazy var shareButton = UIBarButtonItem(
        image: UIImage(systemName: "square.and.arrow.up"),
        primaryAction: .init(handler: { [weak self] _ in
            guard let self else { return }
            self.presentShareSheet(for: self.sections)
        })
    )

    // MARK: Start

    override public func start() {
        let viewController = UIHostingController(
            rootView: DebugScreen(
                sections: sections,
                outAction: { [weak self] action in
                    switch action {
                    case .shareSections(let sections):
                        self?.presentShareSheet(for: sections)
                    case .shareValue(let value):
                        self?.presentShareSheet(for: value)
                    }
                }
            )
        )

        viewController.title = "Debug"
        viewController.navigationItem.leftBarButtonItem = closeButton
        viewController.navigationItem.rightBarButtonItem = shareButton

        push(viewController, animated: false)
    }

    // MARK: Present

    private func presentShareSheet(for sections: [FinalDebugSection]) {
        guard let shareableText = sections.shareableText else {
            return
        }

        print(shareableText)

        let viewController = UIActivityViewController(activityItems: [shareableText], applicationActivities: nil)
        present(viewController, animated: true)
    }

    private func presentShareSheet(for value: FinalDebugValue) {
        let viewController = UIActivityViewController(activityItems: [value.shareableText], applicationActivities: nil)
        present(viewController, animated: true)
    }
}
