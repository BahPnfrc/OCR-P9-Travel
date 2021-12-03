import XCTest
import Foundation
@testable import Travel

class CurrencyServiceTestCase: XCTestCase {

    private let timeout = 0.1
    var fakeUrlSession: URLSession!

    override func setUpWithError() throws {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [FakeURLProtocol.self]
        fakeUrlSession = URLSession(configuration: configuration)
    }

    func testGivenCurrencyServiceIsCalled_whenSuccess_thenRequiredValuesAreNotNil() {
        // Given
        let currencyService = CurrencyService(session: fakeUrlSession)
        FakeURLProtocol.loadingHandler = { _ in
            return (FakeCurrencyResponseData.dataOK, FakeResponseData.responseOK)
        }

        let expectation = XCTestExpectation(description: "Queue change.")
        currencyService.getRate(completion: { result in
            // When
            switch result {
            case .failure:
                XCTFail("Found .failure where .success was expected.")
            case .success(let result):
                // Then
                XCTAssertNotNil(result.timeStamp)
                XCTAssertNotNil(result.dollarToEuroRate)
                XCTAssertNotNil(result.euroToDollarRate)
            }
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: timeout)
    }

}
