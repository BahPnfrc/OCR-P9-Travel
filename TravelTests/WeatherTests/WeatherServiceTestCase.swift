import XCTest
@testable import Travel

class WeatherServiceTestCase: XCTestCase {

    private let timeOut = 0.01
    var fakeUrlSession: URLSession!
    
    override func setUpWithError() throws {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [FakeURLProtocol.self]
        fakeUrlSession = URLSession(configuration: configuration)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testGivenWeatherServiceIsCalled_whenResultIsSuccess_thenRequiredValuesAreNotNil() {
        // Given
        let weatherService = WeatherService(weatherSession: fakeUrlSession)
        FakeURLProtocol.loadingHandler = { _ in
            return (FakeWeatherResponseData.dataOK, FakeResponseData.responseOK)
        }

        // When
        let expectation = XCTestExpectation(description: "Queue change")
        weatherService.getWeather(forCity: "city") { result in
 
            // Then
            switch result {
            case .failure(_):
                XCTFail("Found .failure where .success was expected")
            case .success(let model):
                XCTAssertNotNil(model.name)
                XCTAssertNotNil(model.weather.description)
                XCTAssertNotNil(model.main.temp)
                XCTAssertNotNil(model.weather[0].weatherDescription)
                XCTAssertNotNil(model.weather[0].icon)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: timeOut)
    }

}
