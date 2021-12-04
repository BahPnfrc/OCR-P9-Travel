import Foundation

// https://cloud.google.com/translate/docs/languages

enum Langage: String, CaseIterable {

    case french = "fr"
    case english = "en"
    case italian = "it"
    case spanish = "es"
    case deutsch = "de"
    case russian = "ru"
    case hindi = "hi"
    case chinese = "zh"
    case japanese = "ja"
    case hebrew = "he"
    case arabic = "ar"

    /// Tuple value `isExtra` means the langage is not required in a button's menu
    var data: (name: String, flag: String, isExtra: Bool) {
        switch self {
        case .french: return ("Français", "🇫🇷", false)
        case .english: return ("Anglais", "🇺🇸", false)
        case .italian: return ("Italien", "🇮🇹", true)
        case .spanish: return ("Espagnol", "🇪🇸", true)
        case .deutsch: return ("Allemand", "🇩🇪", true)
        case .russian: return ("Russe", "🇷🇺", true)
        case .hindi: return ("Hindi", "🇮🇳", true)
        case .chinese: return ("Chinois", "🇨🇳", true)
        case .japanese: return ("Japonais", "🇯🇵", true)
        case .hebrew: return ("Hébreu", "🇮🇱", true)
        case .arabic: return ("Arabe", "🇸🇦", true)
        }
    }

    var toLabel: String {
        return self.data.name + " " + self.data.flag
    }
}
