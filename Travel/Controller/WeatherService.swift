import Foundation
import UIKit

class WeatherService {

    static let shared = WeatherService()
    private init() {}

    private var task: URLSessionDataTask?
    private var weatherSession = URLSession(configuration: .default)
    private var iconSession = URLSession(configuration: .default)

    init(weatherSession: URLSession) {
        self.weatherSession = weatherSession
    }
    init(iconSession: URLSession) {
        self.iconSession = iconSession
    }

    // MARK: - Weather call

    private let baseURL = "https://api.openweathermap.org/data/2.5/weather"

    private enum BaseQueryItem: String {
        case city = "q"
        case token = "appid"
        case lang, units
    }

    func getWeather(
        forCity city: String,
        withUnit unit: Units = .metric,
        completion: @escaping (Result<WeatherJson, ApiError>) -> Void) {

        guard var urlComponents = URLComponents(string: baseURL) else {
            completion(.failure(.url))
            return
        }

        urlComponents.queryItems = [
            URLQueryItem(name: BaseQueryItem.city.rawValue, value: city),
            URLQueryItem(name: BaseQueryItem.token.rawValue, value: Token.forWeather),
            URLQueryItem(name: BaseQueryItem.lang.rawValue, value: "fr"),
            URLQueryItem(name: BaseQueryItem.units.rawValue, value: unit.rawValue)
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
                guard let weatherModel = try? JSONDecoder().decode(WeatherJson.self, from: data) else {
                    completion(.failure(.decoding))
                    return
                }
                completion(.success(weatherModel))
            }
        }
        task?.resume()
    }

    // MARK: - Icon call

    private let iconURL = "https://openweathermap.org/img/wn/\(IconQueryItem.forCode.rawValue)@2x.png"

    private enum IconQueryItem: String {
            case forCode = "--code--"
        }

    /// Retun the API icone as UIImage for the provided `code` as returned by the `getWeather` function
    func getIcon(forCode code: String, completion: @escaping (Result<UIImage, ApiError>) -> Void) {

        let iconUrl = iconURL.replacingOccurrences(of: IconQueryItem.forCode.rawValue, with: code)
        let url = URL(string: iconUrl)

        guard let url = url else {
            completion(.failure(.url))
            return
        }

        let urlRequest = URLRequest(url: url)

        task?.cancel()
        task = iconSession.dataTask(with: urlRequest) { (data, response, error) in
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
