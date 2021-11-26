import Foundation
import UIKit

class CurrencyViewController: UIViewController {
    
    @IBOutlet weak var rateView: UIView!
    @IBOutlet weak var rateHeaderLabel: UILabel!
    @IBOutlet weak var rateValueLabel: UILabel!
    @IBOutlet weak var timeStampHeaderLabel: UILabel!
    @IBOutlet weak var timeStampValueLabel: UILabel!
    
    @IBOutlet weak var toView: UIView!
    @IBOutlet weak var toMainLabel: UILabel!
    @IBOutlet weak var toTopLabel: UILabel!
    @IBOutlet weak var toSubLabel: UILabel!
    
    @IBOutlet weak var fromView: UIView!
    @IBOutlet weak var fromTextField: UITextField!
    @IBOutlet weak var fromTopLabel: UILabel!
    @IBOutlet weak var fromSubLabel: UILabel!
    
    @IBOutlet weak var ctrlView: UIView!
    @IBOutlet weak var ctrlRefreshButton: UIButton!
    @IBOutlet weak var ctrlRunButton: UIButton!
    
    var currentCurrency: Currency = .usDollar
    var currentRate: CurrencyRateModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        paint()
        
        loadDefautValues()
        
    }
    
    private func paint() {
        for container in [rateView, toView, fromView, ctrlView ]{
            container?.backgroundColor = Painting.defViewColor
            container?.layer.cornerRadius = Painting.defRadius
        }
        for button in [ctrlRefreshButton, ctrlRunButton] {
            button?.backgroundColor = Painting.lightBlue
            button?.layer.cornerRadius = Painting.defRadius
            button?.tintColor = Painting.cream
        }
        for label in [rateHeaderLabel, rateValueLabel, timeStampHeaderLabel, timeStampValueLabel, toMainLabel] {
            label?.textColor = Painting.cream
        }
        for label in [toTopLabel, toSubLabel, fromTopLabel, fromSubLabel] {
            label?.textColor = Painting.cream
            label?.textAlignment = .center
        }
        rateHeaderLabel.text = "Taux : "
        timeStampHeaderLabel.text = "Rechargé : "
        
        
    }
    
    private func loadDefautValues() {
        getRate(ofAmount: 1.0, from: .euro, to: .usDollar)
    }
    
    @IBAction func didTapButton(_ sender: Any) {
        guard let text = fromTextField.text, let amount = Double(text) else {
            return
        }
        let from = Currency.euro
        let to = Currency.usDollar
        getRate(ofAmount: amount, from: from, to: to)
    }
    
    private func getRate(ofAmount amount: Double, from: Currency, to: Currency) {
        CurrencyService.shared.getRate(from: from, to: to) { [weak self] result in
         
            guard let self  = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                    print("🔴 Currency service KO : " + error.localizedDescription)
                    self.ShowError(with: "L'appel réseau a échoué")
                case .success(let result):
                    print("🟢 Currency service OK.")
                    self.rateValueLabel.text = "\(result.rate)"
                    self.timeStampValueLabel.text = result.timeStamp
                    self.toMainLabel.text = result.getString(amount: amount)
                    self.toTopLabel.text = to.rawValue
                    self.toSubLabel.text = to.name
                    
                    self.fromTextField.text = amount.toString()
                    self.fromTopLabel.text = from.rawValue
                    self.fromSubLabel.text = from.name
                     
                }
            }
            
        }
    }
    
    private func ShowError(with message: String) {
        let alert = UIAlertController(title: "Erreur :", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        return
    }
    
}


