import Foundation

class FakeResponseData {
    // MARK: - Fake Data
    static let dataKO = "someData".data(using: .utf8)!

    // MARK: - Fake Response
    static let responseOK: HTTPURLResponse!  = HTTPURLResponse(
        url: URL(string: "SomeUrl")!, statusCode: 200, httpVersion: nil, headerFields: nil)
    static let responseKO: HTTPURLResponse! = HTTPURLResponse(
        url: URL(string: "SomeUrl")!, statusCode: 400, httpVersion: nil, headerFields: nil)

    // MARK: - Fake Error
    class ResponseError: Error {}
    static let error = ResponseError()

}
