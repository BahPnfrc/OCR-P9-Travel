import Foundation
import UIKit

class TranslateViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var topFlagImageView: UIImageView!
    @IBOutlet weak var topLangButton: UIButton!
    @IBOutlet weak var topTextView: UITextView!
    @IBOutlet weak var topDeleteImageView: UIImageView!

    @IBOutlet weak var orderImageView: UIImageView!

    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var subFlagImageView: UIImageView!
    @IBOutlet weak var subLangButton: UIButton!
    @IBOutlet weak var subTextView: UITextView!
    @IBOutlet weak var subDeleteImageView: UIImageView!

    @IBOutlet weak var ctrlView: UIView!
    @IBOutlet weak var ctrlButton: UIButton!
    @IBOutlet weak var ctrlLabel: UILabel!
    @IBOutlet weak var ctrlSwitch: UISwitch!

    @IBOutlet weak var topCopyImageView: UIImageView!
    @IBOutlet weak var subCopyImageView: UIImageView!

    @IBOutlet weak var activityView: UIActivityIndicatorView!

    // MARK: - Properties

    private var topZoneController: TranslateZoneController!
    private var subZoneController: TranslateZoneController!
    private var switchController: TranslateSwitchController!

    private let defaultTopLang = Langage.french
    private let defaultSubLang = Langage.english

    private var showFlag = true

    // MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()

        // Match each zone to a Zone controller so they can be used in a Switch controller
        topZoneController = TranslateZoneController(
            position: .top,
            lang: defaultTopLang,
            flag: topFlagImageView,
            textView: topTextView)
        subZoneController = TranslateZoneController(
            position: .sub,
            lang: defaultSubLang,
            flag: subFlagImageView,
            textView: subTextView)
        topFlagImageView.image = topZoneController.langage.data.flag.emojiToImage()
        subFlagImageView.image = subZoneController.langage.data.flag.emojiToImage()

        // Assign each zone to a Swith controller that can switch them
        switchController = TranslateSwitchController(
            isSwitchedOn: ctrlSwitch.isOn,
            topZone: topZoneController,
            subZone: subZoneController)

        paint()
        loadMenu()
        canPerformTranslation()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        topTextView.becomeFirstResponder()
    }

    private func paint() {
        activityView.hidesWhenStopped = true
        for view in [topView, subView, ctrlView] {
            view?.backgroundColor = Painting.defViewColor
            view?.layer.cornerRadius = Painting.defRadius
        }

        for button in [topLangButton, subLangButton, ctrlButton] {
            button?.layer.cornerRadius = Painting.defRadius
        }
        topTextView.layer.cornerRadius = Painting.defRadius
        subTextView.layer.cornerRadius = Painting.defRadius
        if !showFlag {
            topFlagImageView.isHidden = true
            subFlagImageView.isHidden = true
        }
    }

    // MARK: - Actions

    @IBAction func didTapButton(_ sender: Any) {
        let text = switchController.fromZone.getText().trimmingCharacters(in: .whitespaces)
        guard text.count > 0 else { return }
        let fromLangage = switchController.fromZone.langage
        let toLangage = switchController.toZone.langage
        displayTranslation(text: text, fromLangage, toLangage)
    }

    @IBAction func didTapTopClearTextButton(_ sender: Any) {
        Shared.clearText(of: topTextView, rotating: topDeleteImageView)
    }

    @IBAction func didTapSubClearTextButton(_ sender: Any) {
        Shared.clearText(of: subTextView, rotating: subDeleteImageView)
    }

    @IBAction func didTapTopCopyButton(_ sender: Any) {
        copyText(from: topTextView, rotating: topCopyImageView)
    }

    @IBAction func didTapSubCopyButton(_ sender: Any) {
        copyText(from: subTextView, rotating: subCopyImageView)
    }

    @IBAction func didTapSwitch(_ sender: Any) {
        performSwitch()
    }

    // MARK: - Tools

    /// Check weither or not the same langage is used both as source and destination of translation
    private func canPerformTranslation() {
        if switchController.fromZone.langage == switchController.toZone.langage {
            ctrlButton.isUserInteractionEnabled = false
            ctrlButton.backgroundColor = UIColor.systemPink
        } else {
            ctrlButton.isUserInteractionEnabled = true
            ctrlButton.backgroundColor = UIColor.systemGreen
        }
    }

    /// Copy the text of a given `textView` controller while rotating an `image` to show the action
    private func copyText(from textView: UITextView, rotating image: UIImageView) {
        guard let currentText = textView.text, currentText.count > 0 else { return }
        UIView.animate(withDuration: 0.5, animations: {
            image.transform = CGAffineTransform.init(rotationAngle: .pi)
            UIPasteboard.general.string = currentText
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, animations: {
                image.transform = CGAffineTransform.identity
            })
        })
    }

    // MARK: - Functions

    /// Assign a menu of langages to required buttons
    private func loadMenu() {
        let topChildrens = createMenu(forZone: topZoneController)
        let subChildrens = createMenu(forZone: subZoneController)

        let topMenu = UIMenu(title: "Choisir une langue", options: .displayInline, children: topChildrens)
        let subMenu = UIMenu(title: "Choisir une langue", options: .displayInline, children: subChildrens)

        if #available(iOS 14.0, *) {
            topLangButton.menu = topMenu
            topLangButton.isContextMenuInteractionEnabled = true
            subLangButton.menu = subMenu
            subLangButton.isContextMenuInteractionEnabled = true
        } else {
            // Not required since target is iOS 15
        }
    }

    /// Generate a menu of langages for the user to choose a langage from from
    private func createMenu(forZone zone: TranslateZoneController) -> [UIAction] {
        var children = [UIAction]()
        switch zone.position {
        case .top:
            children.append(newMenuAction(forZone: zone, withLangage: defaultTopLang))
            children.append(newMenuAction(forZone: zone, withLangage: defaultSubLang))
        case .sub:
            children.append(newMenuAction(forZone: zone, withLangage: defaultSubLang))
            children.append(newMenuAction(forZone: zone, withLangage: defaultTopLang))
        }
        for langage in Langage.allCases
                .filter({ $0.data.isExtra == true })
                .sorted(by: { $0.data.name < $1.data.name }) {
            children.append(newMenuAction(forZone: zone, withLangage: langage))
        }
        return children
    }

    /// Generate an array of langages as UIAction to assign to a menu
    private func newMenuAction(forZone zone: TranslateZoneController, withLangage langage: Langage) -> UIAction {
        return UIAction(title: langage.data.name, image: langage.data.flag.emojiToImage()) { _ in
            zone.langage = langage
            self.canPerformTranslation()
        }
    }

    private func displayTranslation(text: String, _ fromLangage: Langage, _ toLangage: Langage) {

        Shared.startAnimation(of: activityView, locking: ctrlButton)
        TranslateService.shared.getTranslation(of: text, fromLangage, toLangage) { [weak self] result in

            DispatchQueue.main.async {
                Shared.stopAnimation(of: self?.activityView, unlocking: self?.ctrlButton)
                 guard let self = self else { return }

                 switch result {
                 case .failure(let error):
                     print("🔴 Translate service KO.")
                     print(error.localizedDescription)
                     Shared.showError(with: Shared.defaultShowErrorMessage, inView: self)

                 case .success(let model):
                     print("🟢 Translate service OK.")
                     let text = model.data.translations[0].translatedText
                     self.switchController.toZone.setText(text)
                 }
             }
        }
    }

    // Do some animation before calling the Switch controller
    private func performSwitch() {
        if ctrlSwitch.isOn {
            UIView.animate(withDuration: 0.5, animations: {
                self.orderImageView.transform = CGAffineTransform(rotationAngle: .pi)
            })
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                 self.orderImageView.transform = CGAffineTransform.identity
            })
        }
        switchController.switchZones()
    }
}
