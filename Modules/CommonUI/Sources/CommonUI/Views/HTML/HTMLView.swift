import Foundation
import SwiftUI

public struct HTMLElementStyle {
    public var font: Font?
    public var color: Color?

    public nonisolated(unsafe) static let defaultStyles: [String: HTMLElementStyle] = [
        "h1": .init(font: .largeTitle, color: .primary),
        "h2": .init(font: .title, color: .primary),
        "h3": .init(font: .title2, color: .primary),
        "h4": .init(font: .title3, color: .primary),
        "h5": .init(font: .headline, color: .primary),
        "h6": .init(font: .subheadline, color: .primary),
        "p": .init(font: .body, color: .primary),
        "li": .init(font: .body, color: .primary),
        "ol": .init(font: .body, color: .primary),
        "ul": .init(font: .body, color: .primary),
        "sup": .init(font: .caption2, color: .primary),
        "sub": .init(font: .caption2, color: .primary),
        "a": .init(font: .body, color: .blue),
    ]

    public init(font: Font? = nil, color: Color? = nil) {
        self.font = font
        self.color = color
    }
}

public struct HTMLView: View {
    let htmlString: String
    let customTags: [String]
    @State private var parsedContent: HTMLElement?
    let onLinkTap: ((URL) -> Void)?

    public init(
        htmlString: String,
        customTags: [String] = [],
        onLinkTap: ((URL) -> Void)? = nil
    ) {
        self.htmlString = htmlString
        self.customTags = customTags
        self.onLinkTap = onLinkTap
    }

    public var body: some View {
        Group {
            if let parsedContent {
                InnerHTMLView(element: parsedContent, onLinkTap: onLinkTap)
                    .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                Rectangle()
                    .fill(.clear)
            }
        }
        .onAppear {
            if parsedContent == nil {
                parseCurrentHTML()
            }
        }
        .onChange(of: htmlString) { _, _ in
            parseCurrentHTML()
        }
    }

    private func parseCurrentHTML() {
        var parser = HTMLParser(html: htmlString, customTags: customTags)
        parsedContent = htmlString.isEmpty ? nil : parser.parse()
    }
}

/// A SwiftUI view that renders HTML content with customizable styling.
///
/// `HTMLView` provides a way to render HTML content in SwiftUI with support for common HTML elements
/// including headings, paragraphs, lists, links, and text formatting. It supports custom styling
/// through the `HTMLElementStyle` type and allows for custom handling of link taps.
///
/// # Example
/// ```swift
/// // Basic usage with HTML string
/// HTMLView(htmlString: "<h1>Hello World</h1><p>This is a paragraph</p>")
///
/// // With custom link handling
/// HTMLView(
///     htmlString: "<a href='https://example.com'>Click me</a>",
///     onLinkTap: { url in
///         // Handle link tap
///         print("Link tapped: \(url)")
///     }
/// )
///
/// // With custom tags
/// HTMLView(
///     htmlString: "<custom>Custom content</custom>",
///     customTags: ["custom"]
/// )
/// ```
public struct InnerHTMLView: View {
    @Environment(\.htmlStyles) private var styles

    let element: HTMLElement
    let parentStyle: HTMLElementStyle?
    let onLinkTap: ((URL) -> Void)?

    /// Creates an HTML view with a parsed HTML element.
    ///
    /// - Parameters:
    ///   - element: The parsed HTML element to display
    ///   - parentStyle: Optional parent style to inherit from
    ///   - onLinkTap: Optional closure to handle link taps
    public init(
        element: HTMLElement,
        parentStyle: HTMLElementStyle? = nil,
        onLinkTap: ((URL) -> Void)? = nil
    ) {
        self.element = element
        self.parentStyle = parentStyle
        self.onLinkTap = onLinkTap
    }

    /// Creates an HTML view from an HTML string.
    ///
    /// - Parameters:
    ///   - htmlString: The HTML string to parse and display
    ///   - customTags: Array of custom HTML tags to support
    ///   - onLinkTap: Optional closure to handle link taps

    public var body: some View {
        let style = elementStyle(for: element)

        switch element {
        case .html(let children),
             .body(let children),
             .head(let children):
            VStack(alignment: .leading, spacing: 10) {
                ForEach(children.indices, id: \.self) { i in
                    InnerHTMLView(element: children[i], parentStyle: style, onLinkTap: onLinkTap)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

        case .title(let text):
            Text(text)
                .font(.headline)

        case .h1, .h2, .h3, .h4, .h5, .h6, .p:
            Text(inlineAttributedString(for: element))
                .font(style.font ?? parentStyle?.font ?? .body)
                .foregroundStyle(style.color ?? parentStyle?.color ?? .primary)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .environment(\.openURL, OpenURLAction { url in
                    if let onLinkTap {
                        onLinkTap(url)
                    } else {
                        #if canImport(UIKit)
                            UIApplication.shared.open(url)
                        #elseif canImport(AppKit)
                            NSWorkspace.shared.open(url)
                        #endif
                    }
                    return .handled
                })

        case .li(let children):
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 5) {
                    let inlineContent = children.filter { element in
                        if case .ol = element { return false }
                        if case .ul = element { return false }
                        return true
                    }
                    if !inlineContent.isEmpty {
                        Text(inlineAttributedString(for: .li(children: inlineContent)))
                            .font(style.font ?? parentStyle?.font ?? .body)
                            .foregroundStyle(style.color ?? parentStyle?.color ?? .primary)
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    ForEach(children.indices, id: \.self) { i in
                        switch children[i] {
                        case .ol, .ul:
                            InnerHTMLView(element: children[i], parentStyle: style, onLinkTap: onLinkTap)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        default:
                            EmptyView()
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }

        case .a(let href, let text):
            Text(text)
                .font(style.font ?? parentStyle?.font ?? .body)
                .foregroundColor(style.color ?? parentStyle?.color ?? .blue)
                .underline(true, color: style.color ?? parentStyle?.color ?? .blue)
                .onTapGesture {
                    if let href, let url = URL(string: href) {
                        if let onLinkTap {
                            onLinkTap(url)
                        } else {
                            #if canImport(UIKit)
                                UIApplication.shared.open(url)
                            #elseif canImport(AppKit)
                                NSWorkspace.shared.open(url)
                            #endif
                        }
                    }
                }

        case .ul(let children):
            VStack(alignment: .leading, spacing: 8) {
                ForEach(children.indices, id: \.self) { i in
                    HStack(alignment: .top, spacing: 8) {
                        Text("•")
                            .font(style.font ?? parentStyle?.font ?? .body)
                            .foregroundStyle(style.color ?? parentStyle?.color ?? .primary)
                            .bold()
                        InnerHTMLView(element: children[i], parentStyle: style, onLinkTap: onLinkTap)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 20)

        case .ol(let children):
            VStack(alignment: .leading, spacing: 8) {
                ForEach(children.indices, id: \.self) { i in
                    HStack(alignment: .top, spacing: 8) {
                        Text("\(i + 1).").frame(minWidth: 18, alignment: .trailing)
                            .font(style.font ?? parentStyle?.font ?? .body)
                            .foregroundStyle(style.color ?? parentStyle?.color ?? .primary)
                        InnerHTMLView(element: children[i], parentStyle: style, onLinkTap: onLinkTap)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 20)

        case .text(let text):
            Text(text)

        case .b, .i, .u, .strong, .sub, .sup:
            Text(inlineAttributedString(for: element))

        case .customInline(let tag, _):
            if let style = styles[tag] {
                Text(inlineAttributedString(for: element))
                    .font(style.font ?? parentStyle?.font ?? .body)
                    .foregroundStyle(style.color ?? parentStyle?.color ?? .primary)
            } else {
                Text(inlineAttributedString(for: element))
            }
        case .br:
            Color.clear.frame(height: 8)
        case .unknown(let tag, _):
            if let style = styles[tag] {
                Text(inlineAttributedString(for: element))
                    .font(style.font ?? parentStyle?.font ?? .body)
                    .foregroundStyle(style.color ?? parentStyle?.color ?? .primary)
            } else {
                Text(inlineAttributedString(for: element))
            }
        }
    }

    private func inlineAttributedString(for element: HTMLElement) -> AttributedString {
        var attributedString = AttributedString()
        let baseStyle = elementStyle(for: element)

        func processInlineElement(_ child: HTMLElement, currentStyle: HTMLElementStyle, parentStyle: HTMLElementStyle?) -> AttributedString {
            switch child {
            case .text(let text):
                var result = AttributedString(text)
                result.font = currentStyle.font ?? parentStyle?.font ?? .body
                result.foregroundColor = currentStyle.color ?? parentStyle?.color ?? .primary
                return result
            case .sub(let children):
                var subText = AttributedString()
                let subStyle = HTMLElementStyle(
                    font: styles["sub"]?.font ?? Font.caption2,
                    color: currentStyle.color ?? parentStyle?.color
                )
                for grandChild in children {
                    subText.append(processInlineElement(grandChild, currentStyle: subStyle, parentStyle: parentStyle))
                }
                subText.baselineOffset = -6
                return subText
            case .sup(let children):
                var supText = AttributedString()
                let supStyle = HTMLElementStyle(
                    font: styles["sup"]?.font ?? Font.caption2,
                    color: currentStyle.color ?? parentStyle?.color
                )
                for grandChild in children {
                    supText.append(processInlineElement(grandChild, currentStyle: supStyle, parentStyle: parentStyle))
                }
                supText.baselineOffset = 6
                return supText
            case .a(let href, let text):
                var linkText = AttributedString(text)
                linkText.font = currentStyle.font ?? parentStyle?.font ?? .body
                linkText.foregroundColor = styles["a"]?.color ?? .blue
                linkText.underlineStyle = .single
                if let href, let url = URL(string: href) {
                    linkText.link = url
                }
                return linkText

            case .b(let children), .strong(let children):
                var boldText = AttributedString()
                let boldStyle = HTMLElementStyle(
                    font: (currentStyle.font ?? parentStyle?.font ?? .body).bold(),
                    color: currentStyle.color ?? parentStyle?.color
                )
                for grandChild in children {
                    boldText.append(processInlineElement(grandChild, currentStyle: boldStyle, parentStyle: parentStyle))
                }
                return boldText

            case .i(let children):
                var italicText = AttributedString()
                let italicStyle = HTMLElementStyle(
                    font: (currentStyle.font ?? parentStyle?.font ?? .body).italic(),
                    color: currentStyle.color ?? parentStyle?.color
                )
                for grandChild in children {
                    italicText.append(processInlineElement(grandChild, currentStyle: italicStyle, parentStyle: parentStyle))
                }
                return italicText

            case .u(let children):
                var underlinedText = AttributedString()
                for grandChild in children {
                    var processedText = processInlineElement(grandChild, currentStyle: currentStyle, parentStyle: parentStyle)
                    processedText.underlineStyle = .single
                    underlinedText.append(processedText)
                }
                return underlinedText

            case .customInline(let tag, let children):
                var customText = AttributedString()
                let customStyle = styles[tag] ?? baseStyle
                for grandChild in children {
                    customText.append(processInlineElement(grandChild, currentStyle: customStyle, parentStyle: currentStyle))
                }
                return customText
            case .br:
                return "\n"
            case .unknown(let tag, let children):
                var customText = AttributedString()
                let customStyle = styles[tag] ?? baseStyle
                for grandChild in children {
                    customText.append(processInlineElement(grandChild, currentStyle: customStyle, parentStyle: currentStyle))
                }
                return customText
            default:
                var result = AttributedString(child.textContent)
                result.font = currentStyle.font ?? parentStyle?.font ?? .body
                result.foregroundColor = currentStyle.color ?? parentStyle?.color ?? .primary
                return result
            }
        }

        for child in element.inlineChildren {
            attributedString.append(processInlineElement(child, currentStyle: baseStyle, parentStyle: parentStyle))
        }

        return attributedString
    }

    private func elementStyle(for element: HTMLElement) -> HTMLElementStyle {
        let tagName = element.tagName ?? "p"
        return styles[tagName]
            ?? HTMLElementStyle.defaultStyles[tagName]
            ?? HTMLElementStyle.defaultStyles["p"]!
    }
}

extension AttributeContainer {
    var superscript: Int {
        get { self[RawCTAttribute.self] ?? 0 }
        set { self[RawCTAttribute.self] = newValue }
    }

    enum RawCTAttribute: AttributedStringKey {
        typealias Value = Int
        static let name = kCTSuperscriptAttributeName as String
    }
}
