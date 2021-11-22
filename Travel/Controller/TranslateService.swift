import Foundation

class TranslateService {
    
    static let shared = TranslateService()
    private init() {}
    
    private var task: URLSessionDataTask?
    private var session = URLSession(configuration: .default)
    
    init(session: URLSession) {
        self.session = session
    }
    
    // MARK: - Parameters
    
    // https://cloud.google.com/translate/docs/basic/quickstart
    let baseUrl = "https://translation.googleapis.com//language/translate/v2"
    
    enum UrlQuery: String {
        case token = "key"
        case input = "q"
        case source, target, format
    }

    // https://cloud.google.com/translate/docs/languages
    enum Langage: String {
        case french = "fr"
        case english = "en"
        case italian = "it"
        case spanish = "es"
        case deutsch = "de"
        case russian = "ru"
        case chinese = "zh"
        case japanese = "ja"
        case hebrew = "he"
        case swahili = "sw"
    }
    
    // MARK: - Network Call
    
    func getTranslation(of input: String, from source: Langage = .french, to target: Langage, completion: @escaping (Result<TranslateModel, APIError>) -> Void) {
    
        guard var urlComponents = URLComponents(string: baseUrl) else {
            completion(.failure(.url))
            return
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: UrlQuery.token.rawValue, value: Token.forTranslate),
            URLQueryItem(name: UrlQuery.input.rawValue, value: input),
            URLQueryItem(name: UrlQuery.source.rawValue, value: source.rawValue),
            URLQueryItem(name: UrlQuery.target.rawValue, value: target.rawValue),
            URLQueryItem(name: UrlQuery.format.rawValue, value: "text")
        ]
    
        guard let components = urlComponents.string, let url = URL(string: components) else {
            completion(.failure(.query))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        task?.cancel()
        task = session.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil,
                  let response = response as? HTTPURLResponse,
                  response.statusCode == 200 else {
                      completion(.failure(.server))
                      return
                  }
            guard let translateModel = try? JSONDecoder().decode(TranslateModel.self, from: data) else {
                completion(.failure(.decoding))
                return
            }
            completion(.success(translateModel))
        }
        task?.resume()
    }
    
}
