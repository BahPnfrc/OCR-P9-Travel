import Foundation

class WeatherResponseDataFake: ResponseDataFake {
    // MARK: - Fake Data
    static var dataOK: Data? {
        let bundle = Bundle(for: WeatherResponseDataFake.self)
        let url = bundle.url(forResource: "Weather", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        return data
    }
}
