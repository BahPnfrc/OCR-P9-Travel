import Foundation

class FakeTranslateResponseData: FakeResponseData {
    // MARK: - Fake Data
    static var dataOK: Data? {
        let bundle = Bundle(for: FakeTranslateResponseData.self)
        let url = bundle.url(forResource: "Translate", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        return data
    }
}
