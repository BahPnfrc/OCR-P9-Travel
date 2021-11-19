import Foundation

class TranslateService {
    
    static let shared = TranslateService()
    private init() {}
    
    // https://cloud.google.com/translate/docs/basic/quickstart
    
    enum UrlComponent: String {
        case scheme = "https"
        case host = "translation.googleapis.com"
        case path = "/language/translate/v2"
    }
    
    enum UrlQuery: String {
        case token = "key"
        case input = "q"
        case source, target, format
    }
    
    private var task: URLSessionDataTask?
    
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
    
    func getTranslation(of input: String, from source: Langage = .french, to target: Langage, callback: @escaping (Bool, TranslateModel?) -> Void) {
    
        var urlComponents = URLComponents()
        urlComponents.scheme = UrlComponent.scheme.rawValue
        urlComponents.host = UrlComponent.host.rawValue
        urlComponents.path = UrlComponent.path.rawValue
        
        urlComponents.queryItems = [
            URLQueryItem(name: UrlQuery.token.rawValue, value: Token.forTranslate),
            URLQueryItem(name: UrlQuery.input.rawValue, value: input),
            URLQueryItem(name: UrlQuery.source.rawValue, value: source.rawValue),
            URLQueryItem(name: UrlQuery.target.rawValue, value: target.rawValue),
            URLQueryItem(name: UrlQuery.format.rawValue, value: "text")
        ]
    
        guard let components = urlComponents.string, let url = URL(string: components) else {
            callback(false, nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let session = URLSession(configuration: .default)
        
        task?.cancel()
        task = session.dataTask(with: request) { (data, response, error) in

            guard let data = data, error == nil,
                  let response = response as? HTTPURLResponse,
                  response.statusCode == 200 else {
                      callback(false, nil)
                      return
                  }
            guard let translateModel = try? JSONDecoder().decode(TranslateModel.self, from: data) else {
                callback(false, nil)
                return
            }
            callback(true, translateModel)
            
        }
        task?.resume()
    }
    
}
