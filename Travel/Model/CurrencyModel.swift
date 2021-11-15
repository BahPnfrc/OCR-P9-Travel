//   let currencyModel = try? newJSONDecoder().decode(CurrencyModel.self, from: jsonData)

import Foundation

// MARK: - CurrencyModel
struct CurrencyModel: Codable {
    let success: Bool
    let timestamp: Int
    let base, date: String
    let rates: [String: Double]
}
