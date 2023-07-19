import Foundation

extension [FinalDebugSection] {

    var shareableText: String? {
        guard !isEmpty else {
            assertionFailure("sections should not be empty")
            return nil
        }

        return reduce(into: String()) { partialResult, section in
            partialResult += "--- \(section.section.localizedName) ---\n"
            partialResult += section.values.reduce(into: String()) { partialResult, value in
                partialResult += "\(value.label.localizedName): \(value.value ?? "-")\n"
            }
            partialResult += "\n"
        }
    }
}

extension FinalDebugValue {

    var shareableText: String {
        return "\(label.localizedName): \(value ?? "-")"
    }
}
