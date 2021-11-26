import Foundation
import UIKit

class TranslationZoneController {
    var lang: Langage {
        didSet {
            label.text = lang.data.flag
        }
    }
    
    private weak var label: UILabel!
    private weak var textView: UITextView!
    
    init(lang: Langage, label: UILabel, textView: UITextView) {
        self.lang = lang
        self.label = label
        self.textView = textView
    }
    
    func getText() -> String {
        return textView.text ?? ""
    }
    
    func setText(_ text: String) {
        textView.text = text
    }
}

class TranslationFromToController {
    var topToSub: Bool
    var fromZone: TranslationZoneController
    var toZone: TranslationZoneController
    
    init(isSwitchedOn: Bool, topZone: TranslationZoneController, subZone: TranslationZoneController) {
        self.topToSub = !isSwitchedOn
        if topToSub {
            self.fromZone = topZone
            self.toZone = subZone
        } else {
            self.fromZone = subZone
            self.toZone = topZone
        }
    }
    
    func switchZones() {
        topToSub = !topToSub
        (fromZone, toZone) = (toZone, fromZone)
    }
}

class TranslateViewController: UIViewController {
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var topLangButton: UIButton!
    @IBOutlet weak var topTextView: UITextView!
    @IBOutlet weak var topDeleteImageView: UIImageView!
    
    @IBOutlet weak var orderImageView: UIImageView!
    
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var subLabel: UILabel!
    @IBOutlet weak var subLangButton: UIButton!
    @IBOutlet weak var subTextView: UITextView!
    @IBOutlet weak var subDeleteImageView: UIImageView!
    
    @IBOutlet weak var ctrlView: UIView!
    @IBOutlet weak var ctrlButton: UIButton!
    @IBOutlet weak var ctrlLabel: UILabel!
    @IBOutlet weak var ctrlSwitch: UISwitch!
    
    
    var topZoneController: TranslationZoneController!
    var subZoneController: TranslationZoneController!
    var fromTo: TranslationFromToController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topZoneController = TranslationZoneController(lang: .french, label: topLabel, textView: topTextView)
        subZoneController = TranslationZoneController(lang: .english, label: subLabel, textView: subTextView)
        topLabel.text = topZoneController.lang.data.flag
        subLabel.text = subZoneController.lang.data.flag
        
        fromTo = TranslationFromToController(
            isSwitchedOn: ctrlSwitch.isOn,
            topZone: topZoneController,
            subZone: subZoneController)
        
        paint()
        loadButtons()
    }
    
    private func paint() {
        for view in [topView, subView, ctrlView] {
            view?.backgroundColor = Painting.darkBlue
            view?.layer.cornerRadius = Painting.defRadius
        }
        for label in [topLabel, subLabel, ctrlLabel] {
            label?.textColor = Painting.cream
        }
        for button in [topLangButton, subLangButton, ctrlButton] {
            button?.backgroundColor = Painting.lightBlue
            button?.layer.cornerRadius = Painting.defRadius
            button?.tintColor = UIColor.white
        }
        ctrlSwitch.onTintColor = Painting.lightBlue
        orderImageView.tintColor = Painting.lightBlue
        
        topTextView.layer.cornerRadius = Painting.defRadius
        subTextView.layer.cornerRadius = Painting.defRadius
    }
    
    private func loadButtons(){
        var topChildrens = [UIAction]()
        for langage in Langage.allCases {
            let action = UIAction(title: langage.data.name, image: langage.data.flag.image()) { (_) in
                self.topZoneController.lang = langage
                self.checkButtons()
            }
            topChildrens.append(action)
        }
        var subChildrens = [UIAction]()
        for langage in Langage.allCases {
            let action = UIAction(title: langage.data.name, image: langage.data.flag.image()) { (_) in
                self.subZoneController.lang = langage
                self.checkButtons()
            }
            subChildrens.append(action)
        }
        
        let topMenu = UIMenu(title: "Origine", options: .displayInline, children: topChildrens)
        let subMenu = UIMenu(title: "Destination", options: .displayInline, children: subChildrens)
        if #available(iOS 14.0, *) {
            topLangButton.menu = topMenu
            topLangButton.isContextMenuInteractionEnabled = true
            subLangButton.menu = subMenu
            subLangButton.isContextMenuInteractionEnabled = true
        } else {
            // TODO: Fallback on earlier versions
        }
    }
    
    private func checkButtons() {
        if fromTo.fromZone.lang == fromTo.toZone.lang {
            ctrlButton.isUserInteractionEnabled = false
            ctrlButton.backgroundColor = UIColor.systemPink
        } else {
            ctrlButton.isUserInteractionEnabled = true
            ctrlButton.backgroundColor = Painting.lightBlue
        }
    }
    
    @IBAction func didTapButton(_ sender: Any) {
        let text = fromTo.fromZone.getText()
        let from = fromTo.fromZone.lang
        let to = fromTo.toZone.lang
        
         TranslateService.shared.getTranslation(of: text, from: from, to: to) { result in
            
             switch result {
             case .failure(let error):
                 print("🔴 Translate service KO.")
                 print(error.localizedDescription)
             case .success(let model):
                 print("🟢 Translate service OK.")
                 DispatchQueue.main.async {
                     let text = model.data.translations[0].translatedText
                     self.fromTo.toZone.setText(text)
                 }
             }
        }
    }
    
    
    
    @IBAction func didTapSwitch(_ sender: Any) {
        switchController()
    }
    
    private func switchController(){
        if ctrlSwitch.isOn {
            UIView.animate(withDuration: 0.5, animations: {
                self.orderImageView.transform = CGAffineTransform(rotationAngle: .pi)
            })
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                 self.orderImageView.transform = CGAffineTransform.identity
            })
        }
        fromTo.switchZones()
    }
    
}
