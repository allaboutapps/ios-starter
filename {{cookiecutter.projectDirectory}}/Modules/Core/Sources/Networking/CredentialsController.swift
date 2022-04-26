import Combine
import Foundation
import KeychainAccess
import Logbook
import Models
import Utilities

public struct Credentials: Codable {
    public let accessToken: String
    public let refreshToken: String
    public let expiresIn: TimeInterval
    
    public init(accessToken: String, refreshToken: String?, expiresIn: TimeInterval?) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken ?? ""
        self.expiresIn = expiresIn ?? NSDate.distantFuture.timeIntervalSinceReferenceDate
    }
}

public class CredentialsController {
    private init() {}
    
    public static let shared = CredentialsController()
    
    private let keychain = Keychain(service: Config.keyPrefix)
    private let credentialStorageKey = Config.Keychain.credentialStorageKey
    private var cachedCredentials: Credentials?
    
    private let jsonDecoder = JSONDecoder()
    private let jsonEncoder = JSONEncoder()
    
    public var currentCredentialsDidChange = PassthroughSubject<Credentials?, Never>()
    
    public var currentCredentials: Credentials? {
        get {
            if let credentialsData = keychain[data: credentialStorageKey], let credentials = try? jsonDecoder.decode(Credentials.self, from: credentialsData), cachedCredentials == nil {
                cachedCredentials = credentials
                return credentials
            } else {
                return cachedCredentials
            }
        }
        set {
            if let credentials = newValue {
                keychain[data: credentialStorageKey] = try? jsonEncoder.encode(credentials)
                cachedCredentials = credentials
            } else {
                cachedCredentials = nil
                _ = try? keychain.remove(credentialStorageKey)
            }
            currentCredentialsDidChange.send(newValue)
        }
    }
    
    public func resetOnNewInstallations() {
        if let installationDate = UserDefaults.standard.value(forKey: "installationDate") as? Date {
            Logbook.debug("existing installation, app installed: \(installationDate)")
        } else {
            Logbook.debug("new installation, resetting credentials in keychain")
            
            if currentCredentials != nil {
                currentCredentials = nil
            }
            
            UserDefaults.standard.set(Date(), forKey: "installationDate")
        }
    }
}
