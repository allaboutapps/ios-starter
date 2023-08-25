import CommonUI
import Foundation
import Logbook
import Networking
import UIKit
import Utilities
import ForceUpdateFeature
import Toolbox

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupLogging(for: AppEnvironment.current)
        log.info(AppEnvironment.current.appInfo)

        Appearance.setup()
        API.setup()
        CredentialsController.shared.resetOnNewInstallations()

        setupForceUpdate()

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options _: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}

// MARK: - Logging

extension AppDelegate {

    func setupLogging(for environment: AppEnvironment) {
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = .none
        dateformatter.timeStyle = .medium

        switch environment.buildConfig {
        case .debug:
            let sink = ConsoleLogSink(level: .min(.debug))

            sink.format = "> \(LogPlaceholder.category) \(LogPlaceholder.date): \(LogPlaceholder.messages)"
            sink.dateFormatter = dateformatter

            log.add(sink: sink)
        case .release:
            log.add(sink: OSLogSink(level: .min(.warning)))
        }
    }
}

// MARK: - Force Update

private extension AppDelegate {

    /// Sets up the `ForceUpdateController` and calls `checkForUpdate()`, if not in debug mode.
    func setupForceUpdate() {
        guard AppEnvironment.current.buildConfig != .debug else { return }
        
        Task {
            await ForceUpdateController.shared.checkForUpdate()
        }
    }
}
