import Assets
import Models
import Networking
import SwiftUI

struct ExampleScreen: View {

    // MARK: Init

    enum OutAction {
        case debug
    }

    private let sendOutAction: (OutAction) -> Void

    init(outAction: @escaping (OutAction) -> Void) {
        sendOutAction = outAction
        _viewModel = StateObject(wrappedValue: ExampleViewModel())
    }

    // MARK: Properties

    @StateObject private var viewModel: ExampleViewModel

    // MARK: Body

    var body: some View {
        Group {
            switch viewModel.viewState {
            case .content(let items, _):
                content(items: items)
            case .empty:
                Text("No data")
            case .failed:
                Text("Error")
            case .loading:
                ProgressView()
            case .idle:
                EmptyView()
            }
        }
        // on iOS 15 we should use the task modifier
        .onAppear {
            guard viewModel.viewState.isIdle else { return }

            Task {
                await viewModel.fetch()
            }
        }
    }

    // MARK: Helpers

    private func content(items: [Item]) -> some View {
        List {
            Section {
                ForEach(items, id: \.self) { item in
                    Text(item.name)
                }
            }
            Section {
                Button(
                    action: {
                        sendOutAction(.debug)
                    },
                    label: {
                        Text("Debug")
                    }
                )
            }
        }
        .foregroundColor(.brandPrimary)
    }
}

// MARK: - Previews

struct ExampleScreen_Previews: PreviewProvider {

    static var previews: some View {
        ExampleScreen(outAction: { _ in })
    }
}
