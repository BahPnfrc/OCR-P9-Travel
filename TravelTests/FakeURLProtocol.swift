import Foundation
import XCTest

// https://www.hackingwithswift.com/articles/153/how-to-test-ios-networking-code-the-easy-way
// https://blog.devgenius.io/unit-test-networking-code-in-swift-without-making-loads-of-mock-classes-74489d0b12a8
final class FakeURLProtocol: URLProtocol {
    
    // static var loadingHandler: ((URLRequest) -> (Data?, HTTPURLResponse, Error?))?
    static var loadingHandler: ((URLRequest) -> (Data?, HTTPURLResponse))? // Error non requis
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        guard let handler = FakeURLProtocol.loadingHandler else {
            XCTFail("Loading handler is not set.")
            return
        }
        
        let (data, response) = handler(request)
        if let data = data {
            
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocolDidFinishLoading(self)
            
        } else {
            
            class URLTestProtocolError: Error {}
            let urlTestProtocolError = URLTestProtocolError()
            client?.urlProtocol(self, didFailWithError: urlTestProtocolError)
        }
    }

    override func stopLoading() {}
    
}
