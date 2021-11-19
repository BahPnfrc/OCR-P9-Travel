import Foundation
import UIKit

class CurrencyViewController: UIViewController {
     
    @IBAction func didTapButton(_ sender: Any) {
        let amount = 10
        let from = CurrencyService.Currency.euro
        let to = CurrencyService.Currency.usDollar
        CurrencyService.shared.getConversion(of: amount, from: from, to: to) { (success, value) in
            
            if success, let value = value {
                print(value.toString() + " " + to.rawValue)
            }
            
            if success, let value = value {
                print("🟢 Currency service : " + value.toString() + " " + to.rawValue)
            } else {
                print("🔴 Currency service : Failed")
            }
        }
    }
    
}
