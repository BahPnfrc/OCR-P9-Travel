//
//  CurrencyService.swift
//  Travel
//
//  Created by Genapi on 09/11/2021.
//

import Foundation

class CurrencyService {
    
    static let shared = CurrencyService()
    private init() {}
    
    // https://developer.apple.com/news/?id=jxky8h89
    // https://fixer.io/documentation
    private let baseUrl = "http://data.fixer.io/api/"
    private let paramUrl = "latest?access_key=\(Param.forToken)"
        + "&from=\(Param.forCurrency)"
    
    private var task: URLSessionDataTask?
    
    enum Param: String {
            case forToken = "--token--"
            case forCurrency = "--currency--"
        }
    
    enum Currency: String {
        case euro = "EUR"
        case greatBritainPound = "GBP"
        case usDollar = "USD"
    }
    
    func getConversion(of amount: Int, from fromCurrency: Currency, to toCurrency: Currency, callBack: @escaping (Bool, Double?) -> Void) {
        getRates(ofCurrency: fromCurrency) { (success, model) in
            DispatchQueue.main.async {
                guard success, let model = model else {
                    callBack(false, nil)
                    return
                }
                guard let rate = model.rates.first(where: {$0.key == toCurrency.rawValue})?.value else {
                    callBack(false, nil)
                    return
                }
                let conversion = Double(amount) * rate
                callBack(true, conversion)
                return
            }
        }
        
    }
    
    private func getRates(ofCurrency currency: Currency, callback: @escaping (Bool, CurrencyModel?) -> Void) {
        
        let session = URLSession(configuration: .default)
        let paramUrl = paramUrl
            .replacingOccurrences(of: Param.forToken.rawValue, with: Token.forCurrency)
            .replacingOccurrences(of: Param.forCurrency.rawValue, with: currency.rawValue)
        
        let url = URL(string: baseUrl + paramUrl)
        
        guard let url = url else {
            callback(false, nil)
            return
        }
        
        let request = URLRequest(url: url)
        
        task?.cancel()
        task = session.dataTask(with: request) { (data, response, error) in
            
            guard let data = data, error == nil,
                  let response = response as? HTTPURLResponse,
                  response.statusCode == 200 else {
                      callback(false, nil)
                      return
                  }
            guard let currencyModel = try? JSONDecoder().decode(CurrencyModel.self, from: data) else {
                callback(false, nil)
                return
            }
            callback(true, currencyModel)
            
        }
        task?.resume()
        
    }
    
}
