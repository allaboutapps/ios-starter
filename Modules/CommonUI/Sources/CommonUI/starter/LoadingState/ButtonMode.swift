import Foundation

public enum ButtonMode {
    case synchronous(() -> Void)
    case asynchronous(() async -> Void)

    public init(action: @escaping () -> Void) {
        self = .synchronous(action)
    }

    public init(action: @escaping () async -> Void) {
        self = .asynchronous(action)
    }
}
