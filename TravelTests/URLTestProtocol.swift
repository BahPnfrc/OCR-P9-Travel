import Foundation
import XCTest

// https://www.hackingwithswift.com/articles/153/how-to-test-ios-networking-code-the-easy-way
final class URLTestProtocol: URLProtocol {
    
    static var loadingHandler: ((URLRequest) -> (HTTPURLResponse, Data?, Error?))?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        guard let handler = URLTestProtocol.loadingHandler else {
            XCTFail("Loading handler is not set.")
            return
        }
        
        let (response, data, _) = handler(request)
        if let data = data {
            
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
            
        } else {
            
            class URLTestProtocolError: Error {}
            let urlTestProtocolError = URLTestProtocolError()
            client?.urlProtocol(self, didFailWithError: urlTestProtocolError)
        }
    }

    override func stopLoading() {}
    
}
