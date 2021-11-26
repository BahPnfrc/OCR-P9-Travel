import Foundation

class CurrencyResultModel {
    let fromCurrency: Currency
    let toCurrency: Currency
    let rate: Double
    let timeStamp: String
    
    init(from fromCurrency: Currency, to toCurrency: Currency, withRate rate: Double, fromModel model: CurrencyRateModel) {
        self.fromCurrency = fromCurrency
        self.toCurrency = toCurrency
        self.rate = rate
        
        let date = Date(timeIntervalSince1970: TimeInterval(model.timestamp))
        let format = DateFormatter()
        format.dateFormat = "dd/MM/yy à HH:mm:ss"
        self.timeStamp = format.string(from: date)
    }
    
    func getDouble(amount: Double) -> Double {
        return amount * rate
    }
    
    func getString(amount: Double) -> String {
        return getDouble(amount: amount).toString(2)
    }
    
}

/*
 Wednesday, Sep 12, 2018           --> EEEE, MMM d, yyyy
 09/12/2018                        --> MM/dd/yyyy
 09-12-2018 14:11                  --> MM-dd-yyyy HH:mm
 Sep 12, 2:11 PM                   --> MMM d, h:mm a
 September 2018                    --> MMMM yyyy
 Sep 12, 2018                      --> MMM d, yyyy
 Wed, 12 Sep 2018 14:11:54 +0000   --> E, d MMM yyyy HH:mm:ss Z
 2018-09-12T14:11:54+0000          --> yyyy-MM-dd'T'HH:mm:ssZ
 12.09.18                          --> dd.MM.yy
 10:41:02.112                      --> HH:mm:ss.SSS
 */
