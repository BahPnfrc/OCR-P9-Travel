import Foundation

enum Currency: String {
    case euro = "EUR"
    case usDollar = "USD"
    
    var name: String {
        switch self {
        case .euro: return "Euro"
        case .usDollar: return "Dollar"
        }
    }
}
