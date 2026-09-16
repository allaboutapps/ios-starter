import Foundation

public extension String {
    func cleanUpHTML() -> String {
        var copy = trimmingCharacters(in: .whitespacesAndNewlines)
        // some html strings are not wrapped in any tag at all – wrap in a p tag so formatting looks nicer
        if !copy.hasPrefix("<") || !copy.hasSuffix(">") {
            copy = "<p>\(self)</p>"
        }

        // they send <hr> clean those up
        // Handle all variants: <hr>, <hr/>, <hr />
        copy = copy.replacingOccurrences(of: "<hr\\s*/?>", with: "<br><br>", options: .regularExpression, range: nil)

        return copy
    }
}
