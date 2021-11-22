import Foundation
import UIKit

enum Units: String {
    case standard
    case metric
    case imperial
}

class WeatherService {
    
    static let shared = WeatherService()
    private init() {}
    
    private var task: URLSessionDataTask?
    private var weatherSession = URLSession(configuration: .default)
    private var imageSession = URLSession(configuration: .default)
    
    init(weatherSession: URLSession){
        self.weatherSession = weatherSession
    }
    init(imageSession: URLSession){
        self.imageSession = imageSession
    }
    
    // MARK: - Weather call
    
    private let baseURL = "https://api.openweathermap.org/data/2.5/weather"

    enum baseQueryItem: String {
        case city = "q"
        case token = "appid"
        case lang, units
    }
    
    func getWeather(forCity city: String, withUnit unit: Units = .metric, completion: @escaping (Result<WeatherModel, APIError>) -> Void) {
        
        guard var urlComponents = URLComponents(string: baseURL) else {
            completion(.failure(.url))
            return
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: baseQueryItem.city.rawValue, value: city),
            URLQueryItem(name: baseQueryItem.token.rawValue, value: Token.forWeather),
            URLQueryItem(name: baseQueryItem.lang.rawValue, value: "fr"),
            URLQueryItem(name: baseQueryItem.units.rawValue, value: unit.rawValue)
        ]
        
        guard let components = urlComponents.string, let url = URL(string: components) else {
            completion(.failure(.query))
            return
        }
        
        let request = URLRequest(url: url)
        
        task?.cancel()
        task = weatherSession.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil,
                      let response = response as? HTTPURLResponse,
                      response.statusCode == 200 else {
                          completion(.failure(.server))
                          return
                      }
                guard let weatherModel = try? JSONDecoder().decode(WeatherModel.self, from: data) else {
                    completion(.failure(.decoding))
                    return
                }
                completion(.success(weatherModel))
            }
        }
        task?.resume()
    }
    
    // MARK: - Icon call
    
    private let iconURL = "https://openweathermap.org/img/wn/\(iconQueryItem.forCode.rawValue)@2x.png"
    
    enum iconQueryItem: String {
            case forCode = "--code--"
        }
    
    func getIcon(forCode code: String, completion: @escaping (Result<UIImage, APIError>) -> Void) {
        
        let iconUrl = iconURL.replacingOccurrences(of: iconQueryItem.forCode.rawValue, with: code)
        let url = URL(string: iconUrl)
        
        guard let url = url else {
            completion(.failure(.url))
            return
        }
        
        let urlRequest = URLRequest(url: url)
        
        task?.cancel()
        task = imageSession.dataTask(with: urlRequest) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil,
                      let response = response as? HTTPURLResponse,
                      response.statusCode == 200 else {
                          completion(.failure(.server))
                        return
                    }
                guard let image = UIImage(data: data) else {
                    completion(.failure(.decoding))
                    return
                }
                completion(.success(image))
            }
        }
        task?.resume()
    }

}
