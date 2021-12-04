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
    @IBOutlet weak var toAmountLabel: UILabel!

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
    @IBOutlet weak var fromAmountTextField: UITextField!

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

        // Match each zone to a Zone controller so they can be used in a Switch controller
        topZoneController = CurrencyZoneController(
            headerLabel: mainMoneyHeaderLabel,
            textLabel: mainMoneySubLabel,
            currency: .usDollar)
        subZoneController = CurrencyZoneController(
            headerLabel: secondMoneyHeaderLabel,
            textLabel: secondMoneySubLabel,
            currency: .euro)
        // Assign each zone to a Swith controller that can switch them
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
                switchController.fromZone.currency,
                switchController.toZone.currency)
        }

        paint()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fromAmountTextField.becomeFirstResponder()
    }

    private func paint() {
        activityView.hidesWhenStopped = true
        for container in [rateView, toView, fromView, ctrlView ] {
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
        guard let text = fromAmountTextField.text?
                .trimmingCharacters(in: .whitespaces)
                .replacingOccurrences(of: ",", with: "."),
              let amount = Double(text) else {
            fromAmountTextField.text = nil
            fromAmountTextField.becomeFirstResponder()
            return
        }
        fromAmountTextField.text = text
        let fromZone = switchController.fromZone.currency
        let toZone = switchController.toZone.currency
        displayResult(ofAmount: amount, fromZone, toZone)
    }

    @IBAction func didTapClearButton(_ sender: Any) {
        Shared.clearText(of: fromAmountTextField, rotating: clearTextImageView)
    }
    @IBAction func didTapSwitch(_ sender: Any) {
        performSwitch()
    }

    // MARK: - Tools

    // Empty

    // MARK: - Functions

    private func displayResult(ofAmount amount: Double, _ fromZone: Currency, _ toZone: Currency) {

        Shared.startAnimation(of: activityView, locking: ctrlButton)
        CurrencyService.shared.getRate { [weak self] result in

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
                        self.toAmountLabel.text = ""

                        Shared.showError(with: Shared.defaultShowErrorMessage, inView: self)

                    case .success(let result):
                        print("🟢 Currency service OK.")

                        self.lastSearchResult = result
                        CurrencyLegacy.saveLastResult(result: result)

                        self.rateValueLabel.text =
                            self.switchController.isDollarToEuro ?
                        result.dollarToEuroRate.toString(6) :
                            result.euroToDollarRate.toString(6)
                        self.timeStampValueLabel.text = result.timeStamp

                        self.toAmountLabel.text =
                            self.switchController.isDollarToEuro ?
                            result.getDollarToEuro(amount: amount) :
                            result.getEuroToDollar(amount: amount)

                        self.fromAmountTextField.text = amount.toString(2)
                        self.switchController.fromZone.headerLabel.text = fromZone.rawValue
                        self.switchController.fromZone.textLabel.text = fromZone.name

                        self.switchController.toZone.headerLabel.text = toZone.rawValue
                        self.switchController.toZone.textLabel.text = toZone.name
                    }
                }
            }
        }
    }

    private func performSwitch() {
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
        (fromAmountTextField.text, toAmountLabel.text) = (toAmountLabel.text, fromAmountTextField.text)
        switchController.switchZones()
    }
}
