import Foundation

class CurrencyResult {
    let euroToDollarRate: Double
    let dollarToEuroRate: Double
    let timeStamp: String
    
    init(rate: Double, timeStamp: Int) {
        self.euroToDollarRate = rate
        self.dollarToEuroRate = 1 / rate
        
        let date = Date(timeIntervalSince1970: TimeInterval(timeStamp))
        let format = DateFormatter()
        format.dateFormat = "dd/MM/yyyy HH:mm:ss"
        self.timeStamp = format.string(from: date)
    }
    
    init(euroToDollar: Double, dollarToEuro: Double, timeStamp: String) {
        self.euroToDollarRate = euroToDollar
        self.dollarToEuroRate = dollarToEuro
        self.timeStamp = timeStamp
    }
    
    func getEuroToDollar(amount: Double) -> Double {
        return amount * euroToDollarRate
    }
    
    func getEuroToDollar(amount: Double) -> String {
        return getEuroToDollar(amount: amount).toString(2)
    }
    
    func getDollarToEuro(amount: Double) -> Double {
        return amount * dollarToEuroRate
    }
    
    func getDollarToEuro(amount: Double) -> String {
        return getDollarToEuro(amount: amount).toString(2)
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
