import Foundation
import UIKit

extension String {

    /// Check weither or not a string contains Emoji
    var containsEmoji: Bool {
            for scalar in unicodeScalars {
                switch scalar.value {
                case 0x1F600...0x1F64F, // Emoticons
                     0x1F300...0x1F5FF, // Misc Symbols and Pictographs
                     0x1F680...0x1F6FF, // Transport and Map
                     0x2600...0x26FF,   // Misc symbols
                     0x2700...0x27BF,   // Dingbats
                     0xFE00...0xFE0F,   // Variation Selectors
                     0x1F900...0x1F9FF, // Supplemental Symbols and Pictographs
                     0x1F1E6...0x1F1FF: // Flags
                    return true
                default:
                    continue
                }
            }
            return false
        }

    /// Transform a single Emoji string into an UIImage object
    func emojiToImage() -> UIImage? {
        guard self.count == 1, self.containsEmoji else { return nil }
        let size = CGSize(width: 40, height: 40)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIColor.white.withAlphaComponent(0).set()
        let rect = CGRect(origin: .zero, size: size)
        UIRectFill(CGRect(origin: .zero, size: size))
        (self as AnyObject).draw(in: rect, withAttributes: [.font: UIFont.systemFont(ofSize: 40)])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }

}
