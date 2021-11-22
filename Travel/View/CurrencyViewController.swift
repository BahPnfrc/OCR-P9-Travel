import Foundation
import UIKit

class CurrencyViewController: UIViewController {
     
    @IBAction func didTapButton(_ sender: Any) {
        let amount = 10
        let from = Currency.euro
        let to = Currency.usDollar
        getConversion(amount: amount, from: from, to: to)
    }
    
    private func getConversion(amount: Int, from: Currency, to: Currency) {
        CurrencyService.shared.getConversion(of: amount, from: from, to: to) { [weak self] result in
            
            guard let self  = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                    print("🔴 Currency service : Failed")
                case .success(let value):
                    print("🟢 Currency service : " + value.toString() + " " + to.rawValue)
                }
            }
            
        }
    }
    
}
