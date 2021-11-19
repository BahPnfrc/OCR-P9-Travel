import Foundation

enum ServiceError {
    case invalidUrl(error: String)
    case returned(error: NSError)
    case invalidResponse(response: URLResponse)
    case invalidData(data: Data)
    case InvalideCode(code: Int)
}
