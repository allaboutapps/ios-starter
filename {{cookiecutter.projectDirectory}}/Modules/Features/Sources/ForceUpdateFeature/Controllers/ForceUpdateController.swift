import Combine
import Foundation
import Logbook
import Models
import Toolbox
import Utilities

/// A controller that handles all the ForceUpdate feature logic.
public actor ForceUpdateController {

    // MARK: Constants

    private func iTunesLookupURL(bundleId: String) -> URL? { URL(string: "https://itunes.apple.com/lookup?bundleId=\(bundleId)&country=at") }

    // MARK: Init

    private init() {
    }

    // MARK: Properties

    private var checkForUpdateTask: Task<Void, Error>?
    private nonisolated let onForceUpdateNeededSubject = PassthroughSubject<URL?, Never>()

    // MARK: Interface

    /// Singleton
    public static let shared = ForceUpdateController()

    /// Combine Publisher that emits a value if the force update screen should be displayed. Returns AppStore URL of the app.
    public private(set) nonisolated lazy var onForceUpdateNeededPublisher = onForceUpdateNeededSubject.eraseToAnyPublisher()

    /// Returns true, if a newer update of the application is available in the AppStore.
    /// This does NOT mean a force update.
    public private(set) var isUpdateAvailable: Bool = false

    /// Returns true, if a force update of the application is needed.
    public private(set) var isForceUpdateNeeded: Bool = false

    /// Returns the date of the last check of AppStore API and project version JSON.
    public private(set) var lastCheck: Date?

    /// Returns the current version of the app.
    public private(set) var appVersion: SemanticVersion? = Bundle.main.semanticAppVersion

    /// Returns the current version of the app on the AppStore.
    public private(set) var appStoreVersion: SemanticVersion?

    /// Returns the current minimum project version from the project version JSON.
    public private(set) var minimumProjectVersion: SemanticVersion?

    /// Checks for updates. Thread-safe.
    /// Fetches current version from AppStore and from project version JSON.
    public func checkForUpdate() async throws {
        if let checkForUpdateTask {
            return try await checkForUpdateTask.value
        }

        let checkForUpdateTask = Task<Void, Error> { [weak self] in
            guard let self else { return }
            return try await self.internalCheckForUpdate()
        }

        self.checkForUpdateTask = checkForUpdateTask
        defer { self.checkForUpdateTask = nil }
        return try await checkForUpdateTask.value
    }

    // MARK: Helpers

    private func internalCheckForUpdate() async throws {
        log.debug("checking for app update..", category: .forceUpdate)

        // load infos in parallel
        async let appStoreInfoLoad = try? await fetchAppStoreInfo()
        async let forceUpdateInfoLoad = try? await fetchForceUpdateInfo()

        // wait for parallel loading to finish
        let (appStoreInfo, forceUpdateInfo) = await (appStoreInfoLoad, forceUpdateInfoLoad)

        let safeAppVersion = Bundle.main.semanticAppVersion
        let safeAppStoreVersion = SemanticVersion(appStoreInfo?.version)
        let safeMinimumProjectVersion = SemanticVersion(forceUpdateInfo?.iOS.minSupportedVersion)

        appVersion = safeAppVersion
        appStoreVersion = safeAppVersion
        minimumProjectVersion = safeMinimumProjectVersion
        isUpdateAvailable = safeAppVersion < safeAppStoreVersion
        isForceUpdateNeeded = safeAppVersion < safeMinimumProjectVersion
        lastCheck = Date()

        if isForceUpdateNeeded {
            let url = URL(appStoreInfo?.trackViewUrl)
            onForceUpdateNeededSubject.send(url)
        }
    }

    private func fetchAppStoreInfo(bundleId providedBundleId: String? = nil) async throws -> AppStoreLookUpResult? {
        guard let bundleId = providedBundleId ?? Bundle.main.bundleIdentifier,
              let url = iTunesLookupURL(bundleId: bundleId)
        else {
            return nil
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        let result = try Decoders.standardJSON.decode(AppStoreLookUp.self, from: data)
        return result.results.first
    }

    private func fetchForceUpdateInfo() async throws -> ProjectVersion? {
        let (data, _) = try await URLSession.shared.data(from: Config.ForceUpdate.publicVersionURL)
        return try Decoders.standardJSON.decode(ProjectVersion.self, from: data)
    }
}
