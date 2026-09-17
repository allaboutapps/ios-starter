import SwiftUI

/// A `Button` whose action is asynchronous.
///
/// While the action runs the button disables itself and swaps its label for a progress view. The
/// progress view only appears once the action has outlived `progressViewDelay`, so quick actions
/// do not flash a spinner.
///
/// ```swift
/// AsyncButton("Save") {
///     await save()
/// }
///
/// AsyncButton(options: [.disableButton]) {
///     await delete()
/// } label: {
///     Label("Delete", systemSymbol: .trash)
/// }
/// ```
public struct AsyncButton<Label: View>: View {
    public enum ActionOption: CaseIterable, Sendable {
        /// Disable the button while the action runs.
        case disableButton
        /// Replace the label with a progress view once the action outlives `progressViewDelay`.
        case showProgressView
    }

    private let role: ButtonRole?
    private let options: Set<ActionOption>
    private let progressViewDelay: Duration
    private let action: () async -> Void
    private let label: () -> Label

    @State private var isRunning = false
    @State private var showProgressView = false

    public init(
        role: ButtonRole? = nil,
        options: Set<ActionOption> = Set(ActionOption.allCases),
        progressViewDelay: Duration = .milliseconds(150),
        action: @escaping () async -> Void,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.role = role
        self.options = options
        self.progressViewDelay = progressViewDelay
        self.action = action
        self.label = label
    }

    public var body: some View {
        Button(role: role) {
            Task { await run() }
        } label: {
            ZStack {
                label()
                    .opacity(showProgressView ? 0 : 1)

                if showProgressView {
                    ProgressView()
                }
            }
        }
        .disabled(isRunning && options.contains(.disableButton))
    }

    @MainActor
    private func run() async {
        isRunning = true
        defer {
            isRunning = false
            showProgressView = false
        }

        var progressViewTask: Task<Void, Never>?

        if options.contains(.showProgressView) {
            progressViewTask = Task {
                do {
                    try await Task.sleep(for: progressViewDelay)
                    showProgressView = true
                } catch {
                    // Cancelled before the delay elapsed — the action was fast, so no spinner.
                }
            }
        }

        await action()
        progressViewTask?.cancel()
    }
}

public extension AsyncButton where Label == Text {
    /// Creates an async button with a plain text title.
    init(
        _ title: some StringProtocol,
        role: ButtonRole? = nil,
        options: Set<ActionOption> = Set(ActionOption.allCases),
        progressViewDelay: Duration = .milliseconds(150),
        action: @escaping () async -> Void
    ) {
        self.init(
            role: role,
            options: options,
            progressViewDelay: progressViewDelay,
            action: action,
            label: { Text(title) }
        )
    }
}

#Preview {
    VStack(spacing: .triple) {
        AsyncButton("Slow action") {
            try? await Task.sleep(for: .seconds(2))
        }
        .buttonStyle(.borderedProminent)

        AsyncButton("Fast action (no spinner)") {
            try? await Task.sleep(for: .milliseconds(50))
        }
        .buttonStyle(.bordered)
    }
    .padding()
}
