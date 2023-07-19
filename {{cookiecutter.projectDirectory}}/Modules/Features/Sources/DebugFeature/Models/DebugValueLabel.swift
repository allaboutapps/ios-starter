import Foundation

public struct DebugValueLabel {

    public let id: String
    public let localizedName: String

    public init(id: String, localizedName: String) {
        self.id = id
        self.localizedName = localizedName
    }
}

extension DebugValueLabel: Identifiable, Hashable {
}
