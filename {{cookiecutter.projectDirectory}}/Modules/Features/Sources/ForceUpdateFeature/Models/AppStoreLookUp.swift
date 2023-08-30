import Foundation

public struct AppStoreLookUpResult: Decodable {
    public let version: String?
    public let trackViewUrl: String?
    public let trackId: Int?
    public let currentVersionReleaseDate: Date?
}

public struct AppStoreLookUp: Decodable {
    public let results: [AppStoreLookUpResult]
}
