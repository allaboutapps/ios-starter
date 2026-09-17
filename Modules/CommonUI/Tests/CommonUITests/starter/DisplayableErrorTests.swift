@testable import CommonUI
import Foundation
import Testing

struct DisplayableErrorTests {

    private struct CustomError: Error, DisplayableError {
        let messageGeneric = "Custom message"
    }

    @Test
    func customErrorUsesDefaultTitleAndFallsBackToGenericMessage() {
        let error = CustomError().userFacingError

        #expect(error.title == Strings.globalErrorGenericFallbackTitle)
        #expect(error.messageGeneric == "Custom message")
        #expect(error.messageLoad == "Custom message")
        #expect(error.messageSend == "Custom message")
    }

    @Test
    func unknownErrorFallsBackToGenericStrings() {
        struct Unknown: Error {}

        let error = Unknown().userFacingError

        #expect(error.title == Strings.globalErrorGenericFallbackTitle)
        #expect(error.messageLoad == Strings.globalErrorLoadFallbackMessage)
        #expect(error.messageSend == Strings.globalErrorSendFallbackMessage)
    }

    @Test
    func presentableURLErrorSurfacesTheSystemDescription() {
        let urlError = URLError(.notConnectedToInternet)

        let error = urlError.userFacingError

        #expect(error.messageGeneric == urlError.localizedDescription)
    }

    @Test
    func nonPresentableURLErrorFallsBackToGenericStrings() {
        let urlError = URLError(.badServerResponse)

        let error = urlError.userFacingError

        #expect(error.messageGeneric == Strings.globalErrorGenericFallbackMessage)
    }
}
