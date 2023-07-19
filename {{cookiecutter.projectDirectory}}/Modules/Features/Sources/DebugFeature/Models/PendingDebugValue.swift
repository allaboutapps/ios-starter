import Foundation

struct PendingDebugValue {

    let label: DebugValueLabel
    let value: () -> String?

    init(label: DebugValueLabel, value: @escaping (() -> String?)) {
        self.label = label
        self.value = value
    }
}

extension PendingDebugValue: Identifiable {

    var id: String {
        label.id
    }
}
