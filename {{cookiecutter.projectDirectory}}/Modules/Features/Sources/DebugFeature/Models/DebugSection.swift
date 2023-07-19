import Foundation

public struct DebugSection {

    public let id: String
    public let localizedName: String

    public init(id: String, localizedName: String) {
        self.id = id
        self.localizedName = localizedName
    }
}

extension DebugSection: Identifiable {
}
