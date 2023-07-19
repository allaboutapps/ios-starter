import Foundation
import SwiftUI

struct DebugVerticalRow: View {

    // MARK: Init

    let label: String
    let value: String

    init(label: String, value: String) {
        self.label = label
        self.value = value
    }

    // MARK: Body

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.body)
                .lineLimit(1)
            Text(value)
                .font(.callout)
                .foregroundColor(.gray)
                .lineLimit(nil)
        }
    }
}
