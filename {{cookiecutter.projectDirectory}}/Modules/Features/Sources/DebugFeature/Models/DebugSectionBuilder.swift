import Foundation

class DebugSectionBuilder {

    let section: DebugSection
    var values: [PendingDebugValue] = []

    init(section: DebugSection) {
        self.section = section
    }
}

extension DebugSectionBuilder: Identifiable {
}
