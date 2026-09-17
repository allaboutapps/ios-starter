import SFSafeSymbols
import SwiftUI

public struct EmptyStateView: View {
    private let title: String
    private let symbol: SFSymbol
    private let description: String?

    public init(_ title: String, symbol: SFSymbol, description: String? = nil) {
        self.title = title
        self.symbol = symbol
        self.description = description
    }

    public var body: some View {
        if let description {
            ContentUnavailableView {
                Label(title, systemSymbol: symbol)
                    .fixedSize(horizontal: false, vertical: true)
            } description: {
                Text(description)
            }
            .listRowBackground(Color.clear)
        } else {
            ContentUnavailableView(title, systemImage: symbol.rawValue)
                .listRowBackground(Color.clear)
        }
    }
}
