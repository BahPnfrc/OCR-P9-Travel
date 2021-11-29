import XCTest
import Foundation
@testable import Travel

class WeatherServiceTestCase: XCTestCase {

    private let timeout = 0.1
    var fakeUrlSession: URLSession!
    
    override func setUpWithError() throws {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [FakeURLProtocol.self]
        fakeUrlSession = URLSession(configuration: configuration)
    }
    
    func testGivenWeatherServiceIsCalled_whenSuccess_thenRequiredValuesAreNotNil() {
        // Given
        let weatherService = WeatherService(weatherSession: fakeUrlSession)
        FakeURLProtocol.loadingHandler = { _ in
            return (FakeWeatherResponseData.dataWeatherOK, FakeResponseData.responseOK)
        }

        let expectation = XCTestExpectation(description: "Queue change.")
        weatherService.getWeather(forCity: "city") { result in
 
            // When
            switch result {
            case .failure(_):
                XCTFail("Found .failure where .success was expected.")
            case .success(let model):
                // Then
                XCTAssertNotNil(model.name)
                XCTAssertNotNil(model.weather.description)
                XCTAssertNotNil(model.main.temp)
                XCTAssertNotNil(model.weather[0].weatherDescription)
                XCTAssertNotNil(model.weather[0].icon)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: timeout)
    }
    
    func testGivenWeatherIconServiceIsCalled_whenSuccess_thenRequiredValuesAreNotNil() {
        // Given
        let weatherService = WeatherService(iconSession: fakeUrlSession)
        FakeURLProtocol.loadingHandler = { _ in
            return (FakeWeatherResponseData.dataIconOK, FakeResponseData.responseOK)
        }

        let expectation = XCTestExpectation(description: "Queue change.")
        weatherService.getIcon(forCode: "someCode") { result in
 
            // When
            switch result {
            case .failure(_):
                XCTFail("Found .failure where .success was expected.")
            case .success(let icon):
                // Then
                XCTAssertNotNil(icon)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: timeout)
    }

}
