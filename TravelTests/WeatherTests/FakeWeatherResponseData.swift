import Foundation

class FakeWeatherResponseData: FakeResponseData {
    // MARK: - Fake Data
    static var dataOK: Data? {
        let bundle = Bundle(for: FakeWeatherResponseData.self)
        let url = bundle.url(forResource: "Weather", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        return data
    }
}
