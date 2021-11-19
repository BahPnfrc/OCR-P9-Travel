//
//  TranslateViewController.swift
//  Travel
//
//  Created by Genapi on 09/11/2021.
//

import Foundation
import UIKit

class TranslateViewController: UIViewController {
    
    @IBAction func didTapButton(_ sender: Any) {
        
        let text = "Tout va bien"
        let from = TranslateCall.Langage.french
        let to = TranslateCall.Langage.japanese
        
         TranslateCall.shared.getTranslation(of: text, from: from, to: to) { (success, value) in
            
             if success, let value = value {
                 print(value.data.translations[0].translatedText)
             }
            
            
        
        }
        
    }
}
