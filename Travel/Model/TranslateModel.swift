//   let translateModel = try? newJSONDecoder().decode(TranslateModel.self, from: jsonData)

import Foundation

// MARK: - TranslateModel
struct TranslateModel: Codable {
    let data: DataClass
    
    // MARK: - DataClass
    struct DataClass: Codable {
        let translations: [Translation]
        
        // MARK: - Translation
        struct Translation: Codable {
            let translatedText: String
        }
    }
    
}


