import Foundation

extension Double {
    func toString() -> String {
        let string = String(format: "%.1f",self)
        return string
    }
}
