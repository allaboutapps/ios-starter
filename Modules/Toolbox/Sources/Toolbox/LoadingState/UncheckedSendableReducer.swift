import ComposableArchitecture

public struct UncheckedSendableReducer<Parent: Reducer>: Reducer, @unchecked Sendable where Parent.Action: Sendable, Parent.State: Sendable {

    public init(parent: Parent) {
        self.parent = parent
    }

    let parent: Parent

    public var body: some Reducer<Parent.State, Parent.Action> {
        parent
    }
}

public extension Reducer where Action: Sendable, State: Sendable {

    func uncheckedSendable() -> UncheckedSendableReducer<Self> {
        UncheckedSendableReducer(parent: self)
    }
}
