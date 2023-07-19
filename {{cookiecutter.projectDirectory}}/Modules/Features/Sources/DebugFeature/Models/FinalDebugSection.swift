import Foundation

struct FinalDebugSection {

    let section: DebugSection
    let values: [FinalDebugValue]
}

extension FinalDebugSection: Identifiable {

    var id: String {
        section.id
    }
}
