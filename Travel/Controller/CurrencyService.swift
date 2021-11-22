import Foundation

enum Currency: String {
    case euro = "EUR"
    case greatBritainPound = "GBP"
    case usDollar = "USD"
}

class CurrencyService {
    
    static let shared = CurrencyService()
    private init() {}
    
    private var task: URLSessionDataTask?
    private var session = URLSession(configuration: .default)
    
    init(session: URLSession) {
        self.session = session
    }
    
    // MARK: - Parameters
    
    // https://fixer.io/documentation
    // https://developer.apple.com/news/?id=jxky8h89
    private let baseUrl = "http://data.fixer.io/api/latest"
    
    enum QueryItem: String {
        case token = "access_key"
        case currency = "from"
    }
    
    // MARK: - Network result handling
    
    func getConversion(of amount: Int, from fromCurrency: Currency, to toCurrency: Currency, completion: @escaping (Result<Double, APIError>) -> Void) {
        getRates(ofCurrency: fromCurrency) { result in
            
            switch result {
            case .failure(let error):
                completion(.failure(error))
                return
            case .success(let currencyModel):
                guard let rate = currencyModel.rates.first(where: {$0.key == toCurrency.rawValue})?.value else {
                    completion(.failure(.other(error: "Aucune donnée sur la devise '\(toCurrency.rawValue)'")))
                    return
                }
                let conversion = Double(amount) * rate
                completion(.success(conversion))
                return
            }
        }
    }
    
    // MARK: - Network call
    
    private func getRates(ofCurrency currency: Currency, completion: @escaping (Result<CurrencyModel, APIError>) -> Void) {
        
        guard var urlComponents = URLComponents(string: baseUrl) else {
            completion(.failure(.url))
            return
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: QueryItem.token.rawValue, value: Token.forCurrency),
            URLQueryItem(name: QueryItem.currency.rawValue, value: currency.rawValue)
        ]
        
        guard let components = urlComponents.string, let url = URL(string: components) else {
            completion(.failure(.query))
            return
        }
        
        let request = URLRequest(url: url)
        
        task?.cancel()
        task = session.dataTask(with: request) { (data, response, error) in
            
            guard let data = data, error == nil, let response = response as? HTTPURLResponse,
                  response.statusCode == 200 else {
                      completion(.failure(.server))
                      return
                  }
            guard let currencyModel = try? JSONDecoder().decode(CurrencyModel.self, from: data) else {
                completion(.failure(.decoding))
                return
            }
            completion(.success(currencyModel))
        }
        task?.resume()
    }
    
}
