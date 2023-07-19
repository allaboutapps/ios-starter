import Foundation

public struct ProjectVersion {

    public struct iOS: Decodable {
        public let minSupportedVersion: String
    }

    public let iOS: iOS
}

// MARK: - Decodable

extension ProjectVersion: Decodable {

    enum CodingKeys: String, CodingKey {
        case iOS = "ios"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        // swiftformat:disable:next redundantSelf
        self.iOS = try container.decode(Self.iOS.self, forKey: .iOS)
    }
}
