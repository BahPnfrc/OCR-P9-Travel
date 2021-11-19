//
//  CurrencyViewController.swift
//  Travel
//
//  Created by Genapi on 09/11/2021.
//

import Foundation
import UIKit

class CurrencyViewController: UIViewController {
    
    @IBOutlet weak var fromPicker: UIPickerView!
    @IBOutlet weak var toPicker: UIPickerView!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    
    
    @IBAction func didTapLoad(_ sender: Any) {
        
        let amount = 10
        let from = CurrencyService.Currency.euro
        let to = CurrencyService.Currency.usDollar
        CurrencyService.shared.getConversion(of: amount, from: from, to: to) { (success, value) in
            
            if success, let value = value {
                print(value.toString() + " " + to.rawValue)
            }
        }
    }
    
    
    
}
