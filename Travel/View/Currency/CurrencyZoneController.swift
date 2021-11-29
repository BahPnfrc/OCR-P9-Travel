import Foundation
import UIKit

class CurrencyZoneController {
    weak var headerLabel: UILabel!
    weak var textLabel: UILabel!
    var currency: Currency
    
    init(headerLabel: UILabel, textLabel: UILabel, currency: Currency) {
        self.headerLabel = headerLabel
        self.textLabel = textLabel
        self.currency = currency
    }
}
