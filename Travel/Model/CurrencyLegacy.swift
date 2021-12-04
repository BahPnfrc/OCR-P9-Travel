import Foundation

class CurrencyLegacy {

    private struct Keys {
        static let euroToDollarRate = "euroToDollarRate"
        static let dollarToEuroRate = "dollarToEuroRate"
        static let timeStamp = "timeStamp"
    }

    static var euroToDollarRate: Double? {
        get { UserDefaults.standard.double(forKey: Keys.euroToDollarRate) }
        set { UserDefaults.standard.set(newValue, forKey: Keys.euroToDollarRate) }
    }
    static var dollarToEuroRate: Double? {
        get { UserDefaults.standard.double(forKey: Keys.dollarToEuroRate) }
        set { UserDefaults.standard.set(newValue, forKey: Keys.dollarToEuroRate) }
    }
    static var timeStamp: String? {
        get { UserDefaults.standard.string(forKey: Keys.timeStamp) }
        set { UserDefaults.standard.set(newValue, forKey: Keys.timeStamp) }
    }

    static func saveLastResult(result: CurrencyResult) {
        CurrencyLegacy.dollarToEuroRate = result.dollarToEuroRate
        CurrencyLegacy.euroToDollarRate = result.euroToDollarRate
        CurrencyLegacy.timeStamp = result.timeStamp
    }

    static func printAll() {
        print("🟣 Legacy euroToDollarRate : ", euroToDollarRate ?? "nil")
        print("🟣 Legacy dollarToEuroRate : ", dollarToEuroRate ?? "nil")
        print("🟣 Legacy timeStamp : ", timeStamp ?? "nil")
    }
}
