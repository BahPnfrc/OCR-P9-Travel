import Foundation

enum APIError: Error {
    case url
    case query
    case server
    case decoding
    case other(error: String)
}
