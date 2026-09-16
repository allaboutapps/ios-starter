import SwiftUI

public extension View {
    @inlinable nonisolated func debugBorder(_ color: Color = .red) -> some View {
        border(color, width: 1)
    }

    func debugBackground() -> some View {
        background(content: {
            Color.random
        })
    }
}

extension Color {
    static var random: Color {
        Color(
            red: .random(in: 0 ... 1),
            green: .random(in: 0 ... 1),
            blue: .random(in: 0 ... 1)
        )
    }
}
