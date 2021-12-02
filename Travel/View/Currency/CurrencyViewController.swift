import Foundation
import UIKit

class CurrencyViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var rateView: UIView!
    @IBOutlet weak var rateHeaderLabel: UILabel!
    @IBOutlet weak var rateValueLabel: UILabel!
    @IBOutlet weak var timeStampHeaderLabel: UILabel!
    @IBOutlet weak var timeStampValueLabel: UILabel!
    
    @IBOutlet weak var toView: UIView!
    @IBOutlet weak var toMainLabel: UILabel!
    
    @IBOutlet weak var topMoneyView: UIView!
    @IBOutlet weak var subMoneyView: UIView!
    
    @IBOutlet weak var mainMoneyStack: UIStackView!
    @IBOutlet weak var mainMoneyHeaderLabel: UILabel!
    @IBOutlet weak var mainMoneySubLabel: UILabel!
    
    @IBOutlet weak var secondMoneyStack: UIStackView!
    @IBOutlet weak var secondMoneyHeaderLabel: UILabel!
    @IBOutlet weak var secondMoneySubLabel: UILabel!
    
    @IBOutlet weak var orderImageView: UIImageView!
    
    @IBOutlet weak var fromView: UIView!
    @IBOutlet weak var fromTextField: UITextField!

    @IBOutlet weak var ctrlView: UIView!
    @IBOutlet weak var ctrlButton: UIButton!
    @IBOutlet weak var ctrlSwitch: UISwitch!
    
    @IBOutlet weak var clearTextImageView: UIImageView!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    // MARK: - Properties
    
    var topZoneController: CurrencyZoneController!
    var subZoneController: CurrencyZoneController!
    var switchController: CurrencySwitchController!
    var currentCurrency: Currency = .usDollar
    var lastSearchResult: CurrencyResult?
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topZoneController = CurrencyZoneController(
            headerLabel: mainMoneyHeaderLabel,
            textLabel: mainMoneySubLabel,
            currency: .usDollar)
        subZoneController = CurrencyZoneController(
            headerLabel: secondMoneyHeaderLabel,
            textLabel: secondMoneySubLabel,
            currency: .euro)
        switchController = CurrencySwitchController(
            isSwitchedOn: ctrlSwitch.isOn,
            topZone: topZoneController,
            subZone: subZoneController)
        
        CurrencyLegacy.printAll()
        
        if let euroToDollar = CurrencyLegacy.euroToDollarRate,
           let dollarToEuro = CurrencyLegacy.dollarToEuroRate,
           let timeStamp = CurrencyLegacy.timeStamp {
            
            print("🟣 Currency from UserDefault.")
            let userDefault = CurrencyResult(
                euroToDollar: euroToDollar,
                dollarToEuro: dollarToEuro,
                timeStamp: timeStamp)
            lastSearchResult = userDefault
            
            rateValueLabel.text = ctrlSwitch.isOn ?
            userDefault.dollarToEuroRate.toString(6) :
            userDefault.euroToDollarRate.toString(6)
            timeStampValueLabel.text = timeStamp
        } else {
            displayResult(
                ofAmount: 1.0,
                from: switchController.fromZone.currency,
                to: switchController.toZone.currency)
        }
       
        paint()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fromTextField.becomeFirstResponder()
    }
    
    private func paint() {
        activityView.hidesWhenStopped = true
        for container in [rateView, toView, fromView, ctrlView ]{
            container?.backgroundColor = Painting.defViewColor
            container?.layer.cornerRadius = Painting.defRadius
        }
        for button in [ctrlButton] {
            button?.layer.cornerRadius = Painting.defRadius
        }

        rateHeaderLabel.text = "Taux : "
        timeStampHeaderLabel.text = "Date : "
    }
    
    // MARK: - Actions

    @IBAction func didTapButton(_ sender: Any) {
        guard let text = fromTextField.text?
                .trimmingCharacters(in: .whitespaces)
                .replacingOccurrences(of: ",", with: "."),
              let amount = Double(text) else {
            fromTextField.text = nil
            fromTextField.becomeFirstResponder()
            return
        }
        fromTextField.text = text
        let from = switchController.fromZone.currency
        let to = switchController.toZone.currency
        displayResult(ofAmount: amount, from: from, to: to)
    }
    
    @IBAction func didTapClearButton(_ sender: Any) {
        Shared.clearText(of: fromTextField, rotating: clearTextImageView)
    }
    @IBAction func didTapSwitch(_ sender: Any) {
        performSwitch()
    }
    
    // MARK: - Tools
    
    // Empty

    // MARK: - Functions

    private func displayResult(ofAmount amount: Double, from: Currency, to: Currency) {
        
        Shared.startAnimation(of: activityView, locking: ctrlButton)
        CurrencyService.shared.getRate() { [weak self] result in

            DispatchQueue.main.async {
                Shared.stopAnimation(of: self?.activityView, unlocking: self?.ctrlButton)
                guard let self  = self else { return }
                
                DispatchQueue.main.async {
                    switch result {
                    case .failure(let error):
                        print("🔴 Currency service KO.")
                        print(error.localizedDescription)
                        
                        self.rateValueLabel.text = "-"
                        self.timeStampValueLabel.text = "-"
                        self.toMainLabel.text = ""
                        
                        Shared.ShowError(with: Shared.defaultShowErrorMessage, inView: self)
                        
                    case .success(let result):
                        print("🟢 Currency service OK.")
                        
                        self.lastSearchResult = result
                        CurrencyLegacy.saveLastResult(result: result)
                        
                        self.rateValueLabel.text = "\(result.euroToDollarRate)"
                        self.timeStampValueLabel.text = result.timeStamp
                        
                        self.toMainLabel.text = self.switchController.isDollarToEuro ?
                        result.getDollarToEuro(amount: amount) :
                        result.getEuroToDollar(amount: amount)
                        
                        self.switchController.toZone.headerLabel.text = to.rawValue
                        self.switchController.toZone.textLabel.text = to.name
                        
                        self.fromTextField.text = amount.toString(2)
                        self.switchController.fromZone.headerLabel.text = from.rawValue
                        self.switchController.fromZone.textLabel.text = from.name
                    }
                }
            }
        }
    }
    
    private func performSwitch(){
        if ctrlSwitch.isOn {
            let yMotion = abs(mainMoneyStack.frame.origin.y - secondMoneyStack.frame.origin.y)
            UIView.animate(withDuration: 0.5, animations: {
                self.mainMoneyStack.transform = CGAffineTransform(translationX: 0, y: yMotion)
                self.secondMoneyStack.transform = CGAffineTransform(translationX: 0, y: 0 - yMotion)
                self.rateValueLabel.text = self.lastSearchResult?.dollarToEuroRate.toString(6)
            })
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                self.mainMoneyStack.transform = CGAffineTransform.identity
                self.secondMoneyStack.transform = CGAffineTransform.identity
                self.rateValueLabel.text = self.lastSearchResult?.euroToDollarRate.toString(6)
            })
        }
        (fromTextField.text, toMainLabel.text) = (toMainLabel.text, fromTextField.text)
        switchController.switchZones()
    }
}
