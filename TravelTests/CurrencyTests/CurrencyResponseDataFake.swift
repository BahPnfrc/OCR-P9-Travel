import Foundation

class CurrencyResponseDataFake {
    // MARK: - Fake Data
    static var dataOK: Data? {
        let bundle = Bundle(for: CurrencyResponseDataFake.self)
        let url = bundle.url(forResource: "Currency", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        return data
    }
}
