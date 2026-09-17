import XCTest

#if !canImport(ObjectiveC)
    public func allTests() -> [XCTestCaseEntry] {
        [
            testCase(ToolboxTests.allTests),
            testCase(UserDefaults.allTests),
        ]
    }
#endif
