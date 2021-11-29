import XCTest
import Foundation
@testable import Travel

class TranslateServiceTestCase: XCTestCase {
    
    private let timeout = 0.1
    var fakeUrlSession: URLSession!
    
    override func setUpWithError() throws {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [FakeURLProtocol.self]
        fakeUrlSession = URLSession(configuration: configuration)
    }
    
    func testGivenWeatherServiceIsCalled_whenResultIsSuccess_thenRequiredValuesAreNotNil() {
        // Given
        let translateService = TranslateService(session: fakeUrlSession)
        FakeURLProtocol.loadingHandler = { _ in
            return (FakeTranslateResponseData.dataOK, FakeResponseData.responseOK)
        }

        let expectation = XCTestExpectation(description: "Queue change.")
        translateService.getTranslation(of: "someText", to: .english) { result in
 
            // When
            switch result {
            case .failure(_):
                XCTFail("Found .failure where .success was expected.")
            case .success(let model):
                // Then
                XCTAssertNotNil(model.data.translations[0].translatedText)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: timeout)
    }
    
    
}
