import Foundation
import Utilities

/// A controller that handles debug values for the Debug feature.
public class DebugController {

    // MARK: Init

    public init() {
    }

    // MARK: Properties

    private var values: [DebugSectionBuilder] = []

    // MARK: Interface

    /// Add a static value to the debug store. Static means that the value is evaluated at the time of insertion.
    public func addStatic(_ label: DebugValueLabel, to section: DebugSection, value: String?) {
        add(label, to: section, value: value)
    }

    /// Add a dynamic value to the debug store. Dynamic means that the value is evaluated when the debug screen is shown.
    public func add(_ label: DebugValueLabel, to section: DebugSection, value: @autoclosure @escaping (() -> String?)) {
        add(label, to: section, value: value)
    }

    /// Add a dynamic value to the debug store. Dynamic means that the value is evaluated when the debug screen is shown.
    public func add(_ label: DebugValueLabel, to section: DebugSection, value: @escaping (() -> String?)) {
        guard Config.Debug.enabled else { return }

        if !values.contains(where: { $0.section.id == section.id }) {
            values += [
                DebugSectionBuilder(section: section),
            ]
        }

        guard let valueSection = values.first(where: { $0.section.id == section.id }) else { return }

        if !valueSection.values.contains(where: { $0.id == label.id }) {
            // value does not exist yet, insert
            valueSection.values += [
                PendingDebugValue(label: label, value: value),
            ]
        } else {
            // value exists, override
            valueSection.values.removeAll(where: { $0.id == label.id })
            valueSection.values += [
                PendingDebugValue(label: label, value: value),
            ]
        }
    }

    // MARK: Helpers

    /// Renders sections and values for the debug screen.
    func renderDebugSections() -> [FinalDebugSection] {
        values.map { builder in
            FinalDebugSection(
                section: builder.section,
                values: builder.values.map { pendingValue in
                    FinalDebugValue(label: pendingValue.label, value: pendingValue.value())
                }
            )
        }
    }
}
