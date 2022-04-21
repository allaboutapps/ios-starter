import Assets
import Models
import Networking
import SwiftUI

struct ExampleScreen: View {
    @StateObject var viewModel: ExampleViewModel

    init() {
        _viewModel = StateObject(wrappedValue: ExampleViewModel())
    }

    public var body: some View {
        Group {
            switch viewModel.viewState {
            case let .content(items, _):
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

    func content(items: [Item]) -> some View {
        List {
            ForEach(items, id: \.self) { item in
                Text(item.name)
            }
        }
        .foregroundColor(.success)
    }
}

struct ExampleScreen_Previews: PreviewProvider {
    static var previews: some View {
        ExampleScreen()
    }
}
