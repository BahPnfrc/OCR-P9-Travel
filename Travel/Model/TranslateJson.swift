import Foundation

struct TranslateJson: Codable {
    let data: DataClass

    // MARK: - DataClass
    struct DataClass: Codable {
        let translations: [Translation]
    }

    // MARK: - Translation
    struct Translation: Codable {
        let translatedText: String
    }
}
