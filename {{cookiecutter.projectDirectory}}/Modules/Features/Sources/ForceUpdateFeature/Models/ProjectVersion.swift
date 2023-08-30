import Foundation

struct ProjectVersion {

    struct iOS: Decodable {
        let minSupportedVersion: String
    }

    let iOS: iOS
}

// MARK: - Decodable

extension ProjectVersion: Decodable {

    enum CodingKeys: String, CodingKey {
        case iOS = "ios"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        // swiftformat:disable:next redundantSelf
        self.iOS = try container.decode(Self.iOS.self, forKey: .iOS)
    }
}
