import Foundation

class URLSessionFake: URLSession {
    
    let pro = URLProtocol()
    var data: Data?
    var response: URLResponse?
    var error: Error?
    
//    init(configuration: URLSessionConfiguration = .default, data: Data?, response: URLResponse?, error: Error?) {
//        self.data = data
//        self.response = response
//        self.error = error
//        super.init(configuration: configuration)
//    }
    
    init(data: Data?, response: URLResponse?, error: Error?) {
        self.data = data
        self.response = response
        self.error = error
    }
    
    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let task = URLSessionDataTaskFake()
        task.completionHandler = completionHandler
        task.data = data
        task.urlResponse = response
        task.responseError = error
        return task
    }
    
    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let task = URLSessionDataTaskFake()
        task.completionHandler = completionHandler
        task.data = data
        task.urlResponse = response
        task.responseError = error
        return task
    }
    
}
