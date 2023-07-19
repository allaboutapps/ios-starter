import Foundation

public protocol ViewStateContent {}

public enum ViewState<Content> {
    case idle
    case loading
    case failed(Error)
    case empty
    case content(Content, Error?)
}

public extension ViewState {

    var isIdle: Bool {
        if case .idle = self {
            return true
        } else {
            return false
        }
    }

    var contentValue: Content? {
        guard case .content(let value, _) = self else { return nil }
        return value
    }

    mutating func endLoadingWithError(_ error: Error) {
        if let value = contentValue {
            self = .content(value, error)
        } else {
            self = .failed(error)
        }
    }

    mutating func endLoading(_ value: Content?) {
        if let value = value {
            if let array = value as? [ViewStateContent], array.isEmpty {
                self = .empty
            } else {
                self = .content(value, nil)
            }
        } else {
            self = .empty
        }
    }

    mutating func startLoading() {
        guard contentValue == nil else { return }
        self = .loading
    }
}
