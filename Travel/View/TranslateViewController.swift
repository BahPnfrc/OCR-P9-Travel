import Foundation
import UIKit

class TranslateViewController: UIViewController {
    
    @IBAction func didTapButton(_ sender: Any) {
        
        let text = "Tout va bien"
        let from = TranslateService.Langage.french
        let to = TranslateService.Langage.japanese
        
         TranslateService.shared.getTranslation(of: text, from: from, to: to) { (success, value) in
            
             if success, let value = value {
                 print("🟢 Translate service : " + value.data.translations[0].translatedText)
             } else {
                 print("🔴 Translate service : Failed")
             }
        }
    }
    
}
