//
//  WeatherService.swift
//  Travel
//
//  Created by Genapi on 09/11/2021.
//

import Foundation
import UIKit

class WeatherCall {
    
    static let shared = WeatherCall()
    private init() {}
    
    private let baseUrl = "https://api.openweathermap.org/data/2.5/"
    private let paramUrl = "weather?q=--city--"
        + "&appid=--token--"
        + "&lang=--lang--"
        + "&units=--unit--"
    private let iconURL = "https://openweathermap.org/img/wn/--code--@2x.png"
    
    private var task: URLSessionDataTask?
    
    enum UrlKey: String {
            case forCity = "--city--"
            case forToken = "--token--"
            case forlang = "--lang--"
            case forCode = "--code--"
            case forUnit = "--unit--"
        }
    
    enum Units: String {
        case standard
        case metric
        case imperial
    }
    
    func getWeather(forCity city: String, callback: @escaping (Bool, WeatherModel?) -> Void) {
        
        let session = URLSession(configuration: .default)
        let paramUrl = paramUrl
            .replacingOccurrences(of: UrlKey.forCity.rawValue, with: city)
            .replacingOccurrences(of: UrlKey.forToken.rawValue, with: Token.forWeather)
            .replacingOccurrences(of: UrlKey.forUnit.rawValue, with: Units.metric.rawValue)
            .replacingOccurrences(of: UrlKey.forlang.rawValue, with: "fr")
            
        let url = URL(string: baseUrl + paramUrl)
        
        guard let url = url else {
            callback(false, nil)
            return
        }
        
        let request = URLRequest(url: url)
        
        task?.cancel()
        task = session.dataTask(with: request) { (data, response, error) in
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
        
        let session = URLSession(configuration: .default)
        let iconUrl = iconURL.replacingOccurrences(of: UrlKey.forCode.rawValue, with: code)
        let url = URL(string: iconUrl)
        
        guard let url = url else {
            callback(false, nil)
            return
        }
        
        let urlRequest = URLRequest(url: url)
        task?.cancel()
        task = session.dataTask(with: urlRequest) { (data, response, error) in
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
