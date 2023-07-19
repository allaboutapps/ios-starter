import Foundation
import SwiftUI

struct DebugHorizontalRow: View {

    // MARK: Init

    let label: String
    let value: String

    init(label: String, value: String) {
        self.label = label
        self.value = value
    }

    // MARK: Body

    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            Text(label)
                .font(.body)
                .lineLimit(1)
            Spacer(minLength: 8)
            Text(value)
                .font(.callout)
                .foregroundColor(.gray)
                .lineLimit(nil)
        }
    }
}
