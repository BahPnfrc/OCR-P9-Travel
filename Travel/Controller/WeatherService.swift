import Foundation
import UIKit

class WeatherService {
    
    static let shared = WeatherService()
    private init() {}
    
    private let baseUrl = "https://api.openweathermap.org/data/2.5/"
    private let paramUrl = "weather?q=\(UrlKey.forCity.rawValue)"
    + "&appid=\(UrlKey.forToken.rawValue)"
    + "&lang=\(UrlKey.forLang.rawValue)"
    + "&units=\(UrlKey.forUnit.rawValue)"
    private let iconURL = "https://openweathermap.org/img/wn/\(UrlKey.forCode.rawValue)@2x.png"
    
    private var task: URLSessionDataTask?
    private var weatherSession = URLSession(configuration: .default)
    private var imageSession = URLSession(configuration: .default)
    
    init(weatherSession: URLSession, imageSession: URLSession){
        self.weatherSession = weatherSession
        self.imageSession = imageSession
    }
    
    enum UrlKey: String {
            case forCity = "--city--"
            case forToken = "--token--"
            case forLang = "--lang--"
            case forCode = "--code--"
            case forUnit = "--unit--"
        }
    
    enum Units: String {
        case standard
        case metric
        case imperial
    }
    
    func getWeather(forCity city: String, callback: @escaping (Bool, WeatherModel?) -> Void) {
        let paramUrl = paramUrl
            .replacingOccurrences(of: UrlKey.forCity.rawValue, with: city)
            .replacingOccurrences(of: UrlKey.forToken.rawValue, with: Token.forWeather)
            .replacingOccurrences(of: UrlKey.forUnit.rawValue, with: Units.metric.rawValue)
            .replacingOccurrences(of: UrlKey.forLang.rawValue, with: "fr")
            
        let url = URL(string: baseUrl + paramUrl)

        guard let url = url else {
            callback(false, nil)
            return
        }
        
        let request = URLRequest(url: url)
        
        task?.cancel()
        task = weatherSession.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil,
                      let response = response as? HTTPURLResponse,
                      response.statusCode == 200 else {
                          callback(false, nil)
                          return
                      }
                guard let weatherModel = try? JSONDecoder().decode(WeatherModel.self, from: data) else {
                    callback(false, nil)
                    return
                }
                callback(true, weatherModel)
            }
        }
        task?.resume()
    }
    
    func getIcon(forCode code: String, callback: @escaping (Bool, UIImage?) -> Void) {
        
        let iconUrl = iconURL.replacingOccurrences(of: UrlKey.forCode.rawValue, with: code)
        let url = URL(string: iconUrl)
        
        guard let url = url else {
            callback(false, nil)
            return
        }
        
        let urlRequest = URLRequest(url: url)
        
        task?.cancel()
        task = imageSession.dataTask(with: urlRequest) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil,
                      let response = response as? HTTPURLResponse,
                      response.statusCode == 200 else {
                        callback(false, nil)
                        return
                    }
                let image = UIImage(data: data)
                callback(true, image)
            }
        }
        task?.resume()
    }

}
