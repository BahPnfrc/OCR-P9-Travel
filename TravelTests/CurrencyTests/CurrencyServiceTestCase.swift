import XCTest
import Foundation
@testable import Travel

class CurrencyServiceTestCase: XCTestCase {
    
    private let timeout = 0.01
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
        currencyService.getConversion(of: 1, from: .euro, to: .usDollar) { result in
 
            // When
            switch result {
            case .failure(_):
                XCTFail("Found .failure where .success was expected.")
            case .success(_):
                // Then
                XCTAssertTrue(true)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: timeout)
    }

}
