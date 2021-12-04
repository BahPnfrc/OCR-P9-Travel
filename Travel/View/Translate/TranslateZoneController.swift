import Foundation
import UIKit

class TranslateZoneController {

    enum Position {
        case top, sub
    }

    var langage: Langage {
        didSet {
            flag.image = langage.data.flag.emojiToImage()
        }
    }

    private(set) var position: Position
    private weak var flag: UIImageView!
    private weak var textView: UITextView!

    init(position: Position, lang: Langage, flag: UIImageView, textView: UITextView) {
        self.position = position
        self.langage = lang
        self.flag = flag
        self.textView = textView
    }

    func getText() -> String {
        return textView.text ?? ""
    }

    func setText(_ text: String) {
        textView.text = text
    }
}
