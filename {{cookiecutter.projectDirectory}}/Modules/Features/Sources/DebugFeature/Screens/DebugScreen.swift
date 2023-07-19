import Assets
import Foundation
import SwiftUI
import Toolbox

struct DebugScreen: View {

    // MARK: Init

    enum OutAction {
        case shareSections(_ sections: [FinalDebugSection])
        case shareValue(_ value: FinalDebugValue)
    }

    private let sections: [FinalDebugSection]
    private let sendOutAction: (OutAction) -> Void

    init(sections: [FinalDebugSection], outAction: @escaping (OutAction) -> Void) {
        self.sections = sections
        sendOutAction = outAction
    }

    // MARK: Body

    var body: some View {
        List {
            ForEach(sections) { section in
                Section(header: sectionHeader(section: section)) {
                    ForEach(section.values) { value in
                        if #available(iOS 16.0, *) {
                            ViewThatFits {
                                DebugHorizontalRow(
                                    label: value.label.localizedName,
                                    value: value.value ?? "-"
                                )
                                DebugVerticalRow(
                                    label: value.label.localizedName,
                                    value: value.value ?? "-"
                                )
                            }
                            .contextMenu {
                                Button(
                                    action: {
                                        UIPasteboard.general.string = value.value ?? "-"
                                    },
                                    label: {
                                        Label("Copy value to clipboard", systemImage: "doc.on.doc")
                                    }
                                )
                                Button(
                                    action: {
                                        sendOutAction(.shareValue(value))
                                    },
                                    label: {
                                        Label("Share", systemImage: "square.and.arrow.up")
                                    }
                                )
                            }
                        } else {
                            DebugHorizontalRow(
                                label: value.label.localizedName,
                                value: value.value ?? "-"
                            )
                        }
                    }
                }
            }
        }
    }

    // MARK: Helpers

    private func sectionHeader(section: FinalDebugSection) -> some View {
        HStack(alignment: .center, spacing: .zero) {
            Text(section.section.localizedName)

            Spacer()

            Button(
                action: {
                    sendOutAction(.shareSections([section]))
                },
                label: {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(.brandPrimary)
                }
            )
        }
    }
}

// MARK: - Previews

struct DebugScreen_Previews: PreviewProvider {

    static var previews: some View {
        DebugScreen(
            sections: [
                FinalDebugSection(
                    section: .app,
                    values: [
                        FinalDebugValue(label: .appVersion, value: "Some Value"),
                    ]
                ),
            ],
            outAction: { _ in }
        )
    }
}
