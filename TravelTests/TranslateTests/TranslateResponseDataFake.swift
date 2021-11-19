import Foundation

class TranslateResponseDataFake: ResponseDataFake {
    // MARK: - Fake Data
    static var dataOK: Data? {
        let bundle = Bundle(for: TranslateResponseDataFake.self)
        let url = bundle.url(forResource: "Currency", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        return data
    }
}
