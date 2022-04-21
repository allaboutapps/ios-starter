import Combine
import CommonUI
import Foundation
import Models
import Networking
import Utilities

@MainActor
class ExampleViewModel: ObservableObject {

    @Published var viewState: ViewState<[Item]> = .idle

    var cancellable: AnyCancellable?

    func fetch() async {
        viewState.startLoading()

        do {
            let items = try await API.Example.list().requestAsync().model
            viewState.endLoading(items)
        } catch {
            viewState.endLoadingWithError(error)
        }
    }
}
