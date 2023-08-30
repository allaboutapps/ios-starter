import Foundation
import Toolbox

extension SemanticVersion {

    init?(_ optionalString: String?) {
        guard let string = optionalString else { return nil }
        self.init(string)
    }
}

extension SemanticVersion?: Comparable {

    public static func < (lhs: SemanticVersion?, rhs: SemanticVersion?) -> Bool {
        guard let lhs, let rhs else { return false }
        return lhs < rhs
    }
}
