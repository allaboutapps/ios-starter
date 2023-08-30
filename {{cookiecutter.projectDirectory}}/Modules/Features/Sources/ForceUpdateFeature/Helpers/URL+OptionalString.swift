import Foundation

extension URL {

    init?(_ optionalString: String?) {
        guard let string = optionalString else { return nil }
        self.init(string: string)
    }
}
