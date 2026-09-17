import SwiftUI

public struct DynamicHStack<Content>: View where Content: View {
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    let spacing: Padding
    let horizontalAlignment: HorizontalAlignment
    let verticalAlignment: VerticalAlignment
    let switchAtSize: DynamicTypeSize
    let content: () -> Content

    public init(
        switchAtSize: DynamicTypeSize = .xxxLarge,
        horizontalAlignment: HorizontalAlignment = .center,
        verticalAlignment: VerticalAlignment = .center,
        spacing: Padding = .single,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.switchAtSize = switchAtSize
        self.horizontalAlignment = horizontalAlignment
        self.verticalAlignment = verticalAlignment
        self.spacing = spacing
        self.content = content
    }

    private var layout: AnyLayout {
        if dynamicTypeSize <= switchAtSize {
            AnyLayout(HStackLayout(alignment: verticalAlignment, spacing: spacing.rawValue))
        } else {
            AnyLayout(VStackLayout(alignment: horizontalAlignment, spacing: spacing.rawValue))
        }
    }

    public var body: some View {
        layout {
            content()
        }
    }
}
