import Foundation
import UIKit

class TranslateZoneController {
    
    enum Position {
        case top, sub
    }
    
    var langage: Langage {
        didSet {
            label.text = langage.data.flag
        }
    }
    
    private(set) var position: Position
    private weak var label: UILabel!
    private weak var textView: UITextView!
    
    init(position: Position, lang: Langage, label: UILabel, textView: UITextView) {
        self.position = position
        self.langage = lang
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
