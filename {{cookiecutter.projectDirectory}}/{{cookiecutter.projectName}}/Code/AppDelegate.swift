import CommonUI
import DebugView
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
        let updateController = ForceUpdateController(
            publicVersionURL: Config.ForceUpdate.publicVersionURL
        )

        Services.shared.register(service: updateController)

        Task {
            await updateController.checkForUpdate()
        }
    }
}

// MARK: - Debug

private extension AppDelegate {
    /// Sets up the `DebugController` and sets values, if enabled in `Config.Debug.enabled`.
    func setupDebug() {
        guard Config.Debug.enabled else { return }

        let debugController = DebugController()

        debugController.addValue(.appVersion, toSection: .app)
        debugController.addValue(.appBuildNumber, toSection: .app)
        debugController.addValue(.appBundleIdentifier, toSection: .app)
        debugController.addValue(.serverEnvironment, toSection: .app)
        debugController.addValue(.buildConfig, toSection: .app)

        debugController.addValue(.appStart, toSection: .user)
        debugController.addValue(.userLocale, toSection: .user)

        debugController.addValue(.deviceOSVersion, toSection: .device)
        debugController.addValue(.deviceOSModel, toSection: .device)

        debugController.addValue(.pushNotificationsToken, toSection: .pushNotifications)
        debugController.addValue(.pushNotificationsEnvironment, toSection: .pushNotifications)
        debugController.addValue(.pushNotificationsRegistered, toSection: .pushNotifications)

        debugController.addButton(
            DebugButton(
                id: "diceRoll",
                label: "Copy Dice Roll",
                action: {
                    UIPasteboard.general.string = String(Int.random(in: 1 ... 6))
                }
            ),
            toSection: .user
        )

        Services.shared.register(service: debugController)
    }
}

private extension DebugValue {
    static let pushNotificationsEnvironment = DebugValue(
        id: "pushNotificationsEnvironment",
        label: "Environment",
        staticValue: AppEnvironment.current.buildConfig == .debug ? "development" : "production"
    )

    static let pushNotificationsToken = DebugValue(
        id: "pushNotificationsToken",
        label: "Token",
        value: "ABC"
    )

    static let appStart = DebugValue(
        id: "appStart",
        label: "App Start",
        staticValue: Date.now.formatted(date: .complete, time: .complete)
    )

    static let serverEnvironment = DebugValue(
        id: "serverEnvironment",
        label: "Server Environment",
        staticValue: AppEnvironment.current.serverEnvironment.rawValue
    )

    static let buildConfig = DebugValue(
        id: "buildConfig",
        label: "Build Config",
        staticValue: AppEnvironment.current.buildConfig.rawValue
    )
}
