import Foundation

class FakeResponseData {
    // MARK: - Fake Data
    static let dataKO = "dataKO".data(using: .utf8)!
    
    // MARK: - Fake Response
    static let responseOK = HTTPURLResponse(
        url: URL(string: "SomeUrl")!,
        statusCode: 200, httpVersion: nil, headerFields: nil)
    static let responseKO = HTTPURLResponse(
        url: URL(string: "SomeUrl")!,
        statusCode: 400, httpVersion: nil, headerFields: nil)
    
    
    // MARK: - Fake Error
    class ResponseError: Error {}
    static let error = ResponseError()
    
}

// faire un URL TEST protocol et virer URL fake


