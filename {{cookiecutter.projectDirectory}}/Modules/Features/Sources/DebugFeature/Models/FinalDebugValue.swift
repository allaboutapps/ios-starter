import Foundation

struct FinalDebugValue {

    let label: DebugValueLabel
    let value: String?
}

extension FinalDebugValue: Identifiable {

    var id: String {
        label.id
    }
}
