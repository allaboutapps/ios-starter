import Foundation

public enum HTMLElement {
    case html(children: [HTMLElement])
    case head(children: [HTMLElement])
    case body(children: [HTMLElement])
    case title(text: String)
    case h1(children: [HTMLElement])
    case h2(children: [HTMLElement])
    case h3(children: [HTMLElement])
    case h4(children: [HTMLElement])
    case h5(children: [HTMLElement])
    case h6(children: [HTMLElement])
    case p(children: [HTMLElement])
    case a(href: String?, text: String)
    case ul(children: [HTMLElement])
    case ol(children: [HTMLElement])
    case li(children: [HTMLElement])
    case b(children: [HTMLElement])
    case strong(children: [HTMLElement])
    case i(children: [HTMLElement])
    case u(children: [HTMLElement])
    case sub(children: [HTMLElement])
    case sup(children: [HTMLElement])
    case text(String)
    case br
    case customInline(tag: String, children: [HTMLElement])
    case unknown(tag: String, children: [HTMLElement])

    // Helper function to extract inline children for paragraphs and headings
    var inlineChildren: [HTMLElement] {
        switch self {
        case .h1(let children), .h2(let children), .h3(let children), .h4(let children), .h5(let children), .h6(let children),
             .p(let children), .li(let children), .b(let children),
             .i(let children), .u(let children), .customInline(_, let children):
            children
        default:
            []
        }
    }

    public var tagName: String? {
        switch self {
        case .html: "html"
        case .head: "head"
        case .body: "body"
        case .title: "title"
        case .h1: "h1"
        case .h2: "h2"
        case .h3: "h3"
        case .h4: "h4"
        case .h5: "h5"
        case .h6: "h6"
        case .p: "p"
        case .a: "a"
        case .ul: "ul"
        case .ol: "ol"
        case .li: "li"
        case .b: "b"
        case .strong: "strong"
        case .i: "i"
        case .u: "u"
        case .br: "br"
        case .sub: "sub"
        case .sup: "sup"
        case .text: nil
        case .customInline(let tag, _): tag
        case .unknown(let tag, _): tag
        }
    }
}

/// A parser that converts HTML strings into a structured `HTMLElement` tree.
///
/// `HTMLParser` provides functionality to parse HTML strings into a structured tree of `HTMLElement`s
/// that can be rendered by `HTMLView`. It supports common HTML elements and can be extended with
/// custom tags.
///
/// # Example
/// ```swift
/// // Basic parsing
/// let parser = HTMLParser(html: "<h1>Title</h1><p>Content</p>")
/// let element = parser.parse()
///
/// // With custom tags
/// let parser = HTMLParser(
///     html: "<custom>Custom content</custom>",
///     customTags: ["custom"]
/// )
/// let element = parser.parse()
/// ```
public struct HTMLParser {
    private var text: String
    private var index: String.Index
    private var openTags: [(tag: String, startIndex: Int, children: [HTMLElement])] = []
    private let customTags: Set<String>

    // Add a helper property to check if we're inside a list
    private var isInsideList: Bool {
        openTags.contains { $0.tag.lowercased() == "ul" || $0.tag.lowercased() == "ol" }
    }

    /// Creates a new HTML parser instance.
    ///
    /// - Parameters:
    ///   - html: The HTML string to parse
    ///   - customTags: Array of custom HTML tags to support
    public init(html: String, customTags: [String] = []) {
        text = HTMLParser.minifyHTML(html)
        index = text.startIndex
        self.customTags = Set(customTags)
    }

    /// Minifies HTML by removing unnecessary whitespace and normalizing the content.
    ///
    /// This method:
    /// - Normalizes all newlines and multiple spaces to single spaces
    /// - Removes spaces between tags
    /// - Trims leading and trailing whitespace
    /// - Removes spaces immediately after closing tags and before opening tags
    /// - Removes spaces around `<br>` tags since they represent line breaks
    ///
    /// - Parameter html: The HTML string to minify
    /// - Returns: A minified version of the HTML string
    public static func minifyHTML(_ html: String) -> String {
        // First normalize all newlines and multiple spaces to single spaces
        var minified = html.replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)

        // Remove spaces around <br> tags (both <br> and <br/> variants)
        // This handles cases like " <br> " or "\n<br>\n" which should just be "<br>"
        if let brRegex = try? NSRegularExpression(pattern: "\\s*<br\\s*/?>\\s*", options: [.caseInsensitive]) {
            minified = brRegex.stringByReplacingMatches(
                in: minified,
                options: [],
                range: NSRange(location: 0, length: minified.utf16.count),
                withTemplate: "<br>"
            )
        }

        // Remove spaces only between tags (><), but not between text and tags
        if let regex = try? NSRegularExpression(pattern: ">\\s+<", options: []) {
            minified = regex.stringByReplacingMatches(
                in: minified,
                options: [],
                range: NSRange(location: 0, length: minified.utf16.count),
                withTemplate: "><"
            )
        }

        // Remove spaces immediately after closing tags only if followed by another tag or <br>
        // This preserves spaces before text content (e.g., "</strong> text" keeps the space)
        if let afterClosingTagRegex = try? NSRegularExpression(pattern: "(</[^>]+>)\\s+(?=<)", options: []) {
            minified = afterClosingTagRegex.stringByReplacingMatches(
                in: minified,
                options: [],
                range: NSRange(location: 0, length: minified.utf16.count),
                withTemplate: "$1"
            )
        }

        // Remove spaces immediately before opening tags (but not <br> since we already handled that)
        // Only remove if preceded by a closing tag or whitespace
        if let beforeOpeningTagRegex = try? NSRegularExpression(pattern: "(?<=>)\\s+(<[^/][^>]*>)", options: []) {
            minified = beforeOpeningTagRegex.stringByReplacingMatches(
                in: minified,
                options: [],
                range: NSRange(location: 0, length: minified.utf16.count),
                withTemplate: "$1"
            )
        }

        // Trim leading and trailing whitespace
        minified = minified.trimmingCharacters(in: .whitespacesAndNewlines)

        return minified
    }

    /// Parses the HTML string and returns the root element.
    ///
    /// This method processes the entire HTML string and returns a structured tree of `HTMLElement`s.
    /// The root element is typically a `.body` element containing all the parsed content.
    ///
    /// - Returns: The root `HTMLElement` of the parsed HTML tree
    public mutating func parse() -> HTMLElement {
        // Parse the entire text at once
        var elements: [HTMLElement] = []

        while !isAtEnd {
            if peek() == "<" {
                skipWhitespace()
            }
            if isAtEnd { break }
            let element = parseElement()
            if !isEmptyElement(element) {
                elements.append(element)
            }
        }

        return .body(children: elements)
    }

    private func isEmptyElement(_ element: HTMLElement) -> Bool {
        if case .text(let content) = element {
            // Consider text empty if it's empty or only contains whitespace/newlines
            return content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }
        return false
    }

    /// Appends text to the last open tag, merging into the trailing `.text` child when present.
    private mutating func appendTextToLastOpenTag(_ text: String) {
        guard !openTags.isEmpty else { return }
        let lastOpenTagIndex = openTags.count - 1
        if let lastChild = openTags[lastOpenTagIndex].children.last,
           case .text(let content) = lastChild {
            let lastChildIndex = openTags[lastOpenTagIndex].children.count - 1
            openTags[lastOpenTagIndex].children[lastChildIndex] = .text(content + text)
        } else {
            openTags[lastOpenTagIndex].children.append(.text(text))
        }
    }

    private mutating func parseElement() -> HTMLElement {
        // If we're at the end or don't see a tag, treat it as text
        guard !isAtEnd, peek() == "<" else {
            let text = parseText()
            if case .text(let content) = text, !content.isEmpty {
                // Only add text to parent if it's not just whitespace within a list
                if !openTags.isEmpty {
                    let isJustWhitespace = content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                    let lastTag = openTags[openTags.count - 1].tag.lowercased()
                    if !(isJustWhitespace && (lastTag == "ul" || lastTag == "ol")) {
                        appendTextToLastOpenTag(content)
                    }
                    return .text("")
                }
                return text
            }
            return .text("")
        }

        advance() // Skip '<'

        // Check for closing tag
        if peek() == "/" {
            advance()
            let closingTag = parseTagName()
            skipUntil(">")
            advance()

            return handleClosingTag(closingTag)
        }

        // Parse tag name
        let tagName = parseTagName()

        // Handle br tags immediately
        if tagName.lowercased() == "br" || tagName.lowercased() == "br/" {
            skipUntil(">")
            advance() // Skip '>'

            // Add line break to the last open tag if any
            if !openTags.isEmpty {
                appendTextToLastOpenTag("\n")
                return .text("")
            }
            return .text("\n")
        }

        // Parse attributes (currently only supporting href)
        var href: String? = nil
        skipWhitespace()
        while peek() != ">", !isAtEnd {
            let attrName = parseAttributeName()
            skipWhitespace()
            if peek() == "=" {
                advance() // Skip '='
                skipWhitespace()
                let attrValue = parseAttributeValue() // Parse and skip the value
                if attrName == "href" {
                    href = attrValue
                }
            }
            skipWhitespace()
        }

        guard !isAtEnd else { return .text("") }
        advance() // Skip '>'

        // For anchor tags, create and return immediately
        if tagName.lowercased() == "a" {
            openTags.append((tagName, openTags.count, []))

            while !isAtEnd {
                if peek() == "<", text[text.index(after: index)] == "/" {
                    advance() // Skip '<'
                    advance() // Skip '/'
                    let closingTagName = parseTagName()
                    skipUntil(">")
                    advance() // Skip '>'

                    if closingTagName.lowercased() == "a" {
                        let children = openTags.removeLast().children
                        let anchorElement = HTMLElement.a(href: href, text: children.map(\.textContent).joined())
                        if !openTags.isEmpty {
                            openTags[openTags.count - 1].children.append(anchorElement)
                            return .text("")
                        }
                        return anchorElement
                    } else {
                        print("Error: Mismatched closing tag. Expected </a> but found </\(closingTagName)>")
                        return .text("")
                    }
                }

                let element = parseElement()
                if !isEmptyElement(element) {
                    openTags[openTags.count - 1].children.append(element)
                }
            }
        }

        // Add new tag to the stack
        openTags.append((tagName, openTags.count, []))

        // Parse children
        while !isAtEnd {
            if peek() == "<", text[text.index(after: index)] == "/" {
                advance() // Skip '<'
                advance() // Skip '/'
                let closingTagName = parseTagName()
                skipUntil(">")
                advance() // Skip '>'

                if closingTagName.lowercased() == tagName.lowercased() {
                    let (_, _, children) = openTags.removeLast()
                    let element = createElement(tag: tagName, children: children)
                    if !openTags.isEmpty {
                        openTags[openTags.count - 1].children.append(element)
                        return .text("")
                    }
                    return element
                } else {
                    print("Error: Mismatched closing tag. Expected </\(tagName)> but found </\(closingTagName)>")
                    return .text("")
                }
            }

            let element = parseElement()
            if !isEmptyElement(element) {
                if !openTags.isEmpty {
                    openTags[openTags.count - 1].children.append(element)
                } else {
                    return element
                }
            }
        }

        // If we reach the end without finding a closing tag
        if !openTags.isEmpty {
            let (tagName, _, children) = openTags.removeLast()
            print("Error: Missing closing tag for <\(tagName)>")
            let element = createElement(tag: tagName, children: children)
            if !openTags.isEmpty {
                openTags[openTags.count - 1].children.append(element)
                return .text("")
            }
            return element
        }

        return .text("")
    }

    private mutating func handleClosingTag(_ closingTag: String) -> HTMLElement {
        // Find the matching opening tag
        if openTags.lastIndex(where: { $0.tag.lowercased() == closingTag.lowercased() }) != nil {
            // Create the element for the matching tag
            let (tagName, _, children) = openTags.removeLast()
            let element = createElement(tag: tagName, children: children)

            // Add to parent if exists or return
            if !openTags.isEmpty {
                openTags[openTags.count - 1].children.append(element)
                return .text("")
            }
            return element
        } else {
            // Closing tag doesn't match any open tag, print error
            print("Error: Unexpected closing tag </\(closingTag)> with no matching opening tag")
            return .text("")
        }
    }

    private func isInlineElement(_ element: HTMLElement) -> Bool {
        switch element {
        case .text, .a, .b, .i, .u:
            true
        default:
            false
        }
    }

    private func isHTMLElement(_ element: HTMLElement) -> Bool {
        if case .html = element {
            return true
        }
        return false
    }

    private mutating func parseText() -> HTMLElement {
        var content = ""
        while !isAtEnd, peek() != "<" {
            content.append(advance())
        }
        // If the content is only whitespace/newlines, return empty string
        // This prevents standalone newline/whitespace elements while preserving
        // legitimate spacing within text content
        let trimmed = content.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty, !content.isEmpty {
            // Content was only whitespace, return empty
            return .text("")
        }
        return .text(content.htmlDecoded)
    }

    private mutating func parseTagName() -> String {
        var name = ""
        while !isAtEnd, !CharacterSet.whitespaces.contains(Unicode.Scalar(String(peek()))!), peek() != ">" {
            name.append(advance())
        }
        return name
    }

    private mutating func parseAttributeName() -> String {
        var name = ""
        while !isAtEnd, !CharacterSet.whitespaces.contains(Unicode.Scalar(String(peek()))!), peek() != "=", peek() != ">" {
            name.append(advance())
        }
        return name
    }

    private mutating func parseAttributeValue() -> String {
        guard peek() == "\"" || peek() == "'" else { return "" }
        let quote = advance()
        var value = ""
        while !isAtEnd, peek() != quote {
            value.append(advance())
        }
        if !isAtEnd { advance() } // Skip closing quote
        return value
    }

    private mutating func skipWhitespace() {
        while !isAtEnd, CharacterSet.whitespacesAndNewlines.contains(Unicode.Scalar(String(peek()))!) {
            advance()
        }
    }

    private mutating func skipUntil(_ char: Character) {
        while !isAtEnd, peek() != char {
            advance()
        }
    }

    private var isAtEnd: Bool {
        index >= text.endIndex
    }

    private func peek() -> Character {
        guard !isAtEnd else { return "\0" }
        return text[index]
    }

    @discardableResult
    private mutating func advance() -> Character {
        let current = text[index]
        index = text.index(after: index)
        return current
    }

    private func createElement(tag: String, children: [HTMLElement]) -> HTMLElement {
        switch tag.lowercased() {
        case "html": return .html(children: children)
        case "head": return .head(children: children)
        case "body": return .body(children: children)
        case "title": return .title(text: children.first?.textContent ?? "")
        case "h1": return .h1(children: children)
        case "h2": return .h2(children: children)
        case "h3": return .h3(children: children)
        case "h4": return .h4(children: children)
        case "h5": return .h5(children: children)
        case "h6": return .h6(children: children)
        case "p": return .p(children: children)
        case "a": return .a(href: nil, text: children.first?.textContent ?? "")
        case "ul": return .ul(children: children)
        case "ol": return .ol(children: children)
        case "li":
            // Only create li element if inside a list, otherwise just return the children
            return isInsideList ? .li(children: children) : .body(children: children)
        case "b": return .b(children: children)
        case "strong": return .strong(children: children)
        case "sub": return .sub(children: children)
        case "sup": return .sup(children: children)
        case "i": return .i(children: children)
        case "u": return .u(children: children)
        default:
            // For unknown tags, check if they should be treated as custom inline tags
            if customTags.contains(tag.lowercased()) {
                return .customInline(tag: tag, children: children)
            }
            // For other unhandled tags, just return their children
            return children.count == 1 ? children[0] : .body(children: children)
        }
    }
}

extension HTMLElement {
    var textContent: String {
        let rawText = switch self {
        case .text(let text):
            text
        case .html(let children),
             .head(let children),
             .body(let children),
             .h1(let children),
             .h2(let children),
             .h3(let children),
             .h4(let children),
             .h5(let children),
             .h6(let children),
             .p(let children),
             .ul(let children),
             .ol(let children),
             .li(let children),
             .b(let children),
             .strong(let children),
             .i(let children),
             .u(let children),
             .customInline(_, let children),
             .sub(let children),
             .sup(let children),
             .unknown(_, let children):
            children.map(\.textContent).joined(separator: "")
        case .title(let text):
            text
        case .br:
            ""
        case .a(_, let text):
            text
        }
        return rawText.htmlDecoded.trimmingCharacters(in: .newlines)
    }
}

extension String {
    var htmlDecoded: String {
        guard contains("&") else { return self }
        let decoded = try? NSAttributedString(data: Data(utf8), options: [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue,
        ], documentAttributes: nil).string

        return decoded ?? self
    }
}
