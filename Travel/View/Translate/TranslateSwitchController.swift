import Foundation
import UIKit

class TranslateSwitchController {
    var topToSub: Bool
    var fromZone: TranslateZoneController
    var toZone: TranslateZoneController
    
    init(isSwitchedOn: Bool, topZone: TranslateZoneController, subZone: TranslateZoneController) {
        self.topToSub = !isSwitchedOn
        if topToSub {
            self.fromZone = topZone
            self.toZone = subZone
        } else {
            self.fromZone = subZone
            self.toZone = topZone
        }
    }
    
    func switchZones() {
        topToSub = !topToSub
        (fromZone, toZone) = (toZone, fromZone)
    }
}
