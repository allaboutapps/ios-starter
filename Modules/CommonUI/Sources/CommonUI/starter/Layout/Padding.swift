import SwiftUI

public enum Padding: CGFloat {
    case none = 0
    case quarter = 2
    case half = 4
    case single = 8
    case double = 16
    case triple = 24
    case quadruple = 32
}

@inlinable public func + (lhs: Padding, rhs: Padding) -> CGFloat { lhs.rawValue + rhs.rawValue }
@inlinable public func - (lhs: Padding, rhs: Padding) -> CGFloat { lhs.rawValue - rhs.rawValue }
@inlinable public func * (lhs: Padding, rhs: Padding) -> CGFloat { lhs.rawValue * rhs.rawValue }
@inlinable public func / (lhs: Padding, rhs: Padding) -> CGFloat { lhs.rawValue / rhs.rawValue }

@inlinable public func * (lhs: Padding, rhs: CGFloat) -> CGFloat { lhs.rawValue * rhs }
@inlinable public func / (lhs: Padding, rhs: CGFloat) -> CGFloat { lhs.rawValue / rhs }

@inlinable public func * (lhs: CGFloat, rhs: Padding) -> CGFloat { lhs * rhs.rawValue }
@inlinable public func / (lhs: CGFloat, rhs: Padding) -> CGFloat { lhs / rhs.rawValue }

// MARK: - Padding Modifier

public extension View {
    @inlinable nonisolated func padding(_ edges: Edge.Set = .all, _ padding: Padding) -> some View {
        self.padding(edges, padding.rawValue)
    }

    @inlinable nonisolated func padding(_ padding: Padding) -> some View {
        self.padding(padding.rawValue)
    }
}

public extension View {
    @inlinable nonisolated func convertPaddingToMargin(_ edges: Edge.Set = .all, padding: Padding) -> some View {
        self
            .padding(edges, -padding.rawValue)
            .contentMargins(edges, padding.rawValue)
    }
}

// MARK: - HStack

public extension HStack {
    /// Creates a horizontal stack with the specified alignment and optional padding spacing.
    init(alignment: VerticalAlignment = .center, spacing padding: Padding, @ContentBuilder content: () -> Content) {
        self.init(alignment: alignment, spacing: padding.rawValue, content: content)
    }

    /// Creates a horizontal stack with the specified optional padding spacing.
    init(spacing padding: Padding, @ContentBuilder content: () -> Content) {
        self.init(spacing: padding.rawValue, content: content)
    }
}

// MARK: - VStack

public extension VStack {
    /// Creates a vertical stack with the specified alignment and optional padding spacing.
    init(alignment: HorizontalAlignment = .center, spacing padding: Padding, @ContentBuilder content: () -> Content) {
        self.init(alignment: alignment, spacing: padding.rawValue, content: content)
    }

    /// Creates a vertical stack with the specified optional padding spacing.
    init(spacing padding: Padding, @ContentBuilder content: () -> Content) {
        self.init(spacing: padding.rawValue, content: content)
    }
}

// MARK: - Spacer

public extension Spacer {
    /// Creates an instance with the minimum length using `Padding` values.
    init(minLength padding: Padding) {
        self.init(minLength: padding.rawValue)
    }
}

public extension EdgeInsets {
    /// Insets with the same padding on all edges.
    init(all padding: Padding) {
        let v = padding.rawValue
        self.init(top: v, leading: v, bottom: v, trailing: v)
    }

    /// Insets with separate horizontal and vertical padding.
    init(horizontal: Padding, vertical: Padding) {
        let h = horizontal.rawValue
        let v = vertical.rawValue
        self.init(top: v, leading: h, bottom: v, trailing: h)
    }

    /// Insets with individually specified paddings per edge.
    init(top: Padding, leading: Padding, bottom: Padding, trailing: Padding) {
        self.init(top: top.rawValue, leading: leading.rawValue, bottom: bottom.rawValue, trailing: trailing.rawValue)
    }
}
