import Foundation

class CurrencySwitchController {
    var isDollarToEuro: Bool
    var fromZone: CurrencyZoneController
    var toZone: CurrencyZoneController
    
    init(isSwitchedOn: Bool, topZone: CurrencyZoneController, subZone: CurrencyZoneController) {
        self.isDollarToEuro = isSwitchedOn
        self.fromZone = subZone
        self.toZone = topZone
    }
    
    func switchZones() {
        (fromZone, toZone) = (toZone, fromZone)
    }
}
