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
        case .french: return ("Franรงais", "๐ซ๐ท", false)
        case .english: return ("Anglais", "๐บ๐ธ", false)
        case .italian: return ("Italien", "๐ฎ๐น", true)
        case .spanish: return ("Espagnol", "๐ช๐ธ", true)
        case .deutsch: return ("Allemand", "๐ฉ๐ช", true)
        case .russian: return ("Russe", "๐ท๐บ", true)
        case .hindi: return ("Hindi", "๐ฎ๐ณ", true)
        case .chinese: return ("Chinois", "๐จ๐ณ", true)
        case .japanese: return ("Japonais", "๐ฏ๐ต", true)
        case .hebrew: return ("Hรฉbreu", "๐ฎ๐ฑ", true)
        case .arabic: return ("Arabe", "๐ธ๐ฆ", true)
        }
    }

    var toLabel: String {
        return self.data.name + " " + self.data.flag
    }
}
