import Foundation
import UIKit

class TranslateViewController: UIViewController {
    
    @IBAction func didTapButton(_ sender: Any) {
        
        let text = "Aujourd'hui"
        let from = TranslateService.Langage.french
        let to = TranslateService.Langage.russian
        
         TranslateService.shared.getTranslation(of: text, from: from, to: to) { result in
            
             switch result {
             case .failure(let error):
                 print(error.localizedDescription)
                 print("🔴 Translate service : Failed")
             case .success(let model):
                 print("🟢 Translate service : " + model.data.translations[0].translatedText)
             }
        }
    }
    
}
