import CommonUI
import DebugFeature
import ForceUpdate
import Foundation
import Logbook
import Networking
import Toolbox
import UIKit
import Utilities

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupLogging(for: AppEnvironment.current)
        log.info(AppEnvironment.current.appInfo)

        Appearance.setup()
        API.setup()
        CredentialsController.shared.resetOnNewInstallations()

        setupDebug()
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
            await ForceUpdateController.shared.configure(
                publicVersionURL: Config.ForceUpdate.publicVersionURL
            )
            await ForceUpdateController.shared.checkForUpdate()
        }
    }
}

// MARK: - Debug

private extension AppDelegate {

    /// Sets up the `DebugController` and sets values, if enabled in `Config.Debug.enabled`.
    func setupDebug() {
        guard Config.Debug.enabled else { return }

        let debugController = DebugController()

        debugController.add(.appBundleId, to: .app, value: Bundle.main.bundleIdentifier)
        debugController.add(.appVersion, to: .app, value: Bundle.main.appVersion)
        debugController.add(.appBuildNumber, to: .app, value: Bundle.main.buildNumber)
        debugController.add(.appServerEnvironment, to: .app, value: AppEnvironment.current.serverEnvironment.rawValue)
        debugController.add(.appBuildConfig, to: .app, value: AppEnvironment.current.buildConfig.rawValue)
        debugController.add(.appBundleId, to: .app, value: Bundle.main.bundleIdentifier)

        debugController.addStatic(.userAppStart, to: .user, value: Date.now.formatted(date: .complete, time: .complete))
        debugController.add(.userLocale, to: .user, value: Locale.current.identifier)

        debugController.add(.deviceOSVersion, to: .device, value: "\(UIDevice.current.systemName) \(UIDevice.current.systemVersion)")
        debugController.add(.deviceOSModel, to: .device, value: UIDevice.current.model)

        debugController.add(.notificationsPushToken, to: .notifications, value: nil)
        debugController.add(.notificationsPushToken, to: .notifications, value: "ABC")
        debugController.add(.notificationsEnvironment, to: .notifications, value: AppEnvironment.current.buildConfig == .debug ? "development" : "production")
        debugController.add(.notificationsConfigured, to: .notifications, value: UIApplication.shared.isRegisteredForRemoteNotifications ? "true" : "false")

        Services.shared.register(service: debugController)
    }
}
