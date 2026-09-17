import Foundation

public extension String {
    func uppercasedWithoutSpaces() -> String {
        replacingOccurrences(of: " ", with: "").uppercased()
    }
}
