import SwiftUI

public struct ConditionalStack<Content>: View where Content: View {

    private let direction: ConditionalStackDirection
    private let spacing: CGFloat?
    @ViewBuilder
    private let content: () -> Content

    public init(direction: ConditionalStackDirection, spacing: CGFloat? = nil, @ViewBuilder content: @escaping () -> Content) {
        self.direction = direction
        self.spacing = spacing
        self.content = content
    }

    public var body: some View {
        switch direction {
        case .vertical(let alignment):
            VStack(alignment: alignment, spacing: spacing, content: content)
        case .horizontal(let alignment):
            HStack(alignment: alignment, spacing: spacing, content: content)
        }
    }
}

public enum ConditionalStackDirection {
    case vertical(alignment: HorizontalAlignment)
    case horizontal(alignment: VerticalAlignment)
}
