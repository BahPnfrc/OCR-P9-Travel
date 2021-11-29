import Foundation
import XCTest

final class FakeURLProtocol: URLProtocol {
    
    static var loadingHandler: ((URLRequest) -> (Data?, HTTPURLResponse))?
    
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
