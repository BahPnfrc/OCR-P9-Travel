import Foundation

extension Double {
    
    func toString(_ decimal: Int = 6) -> String {
        var check = decimal
        if !(1...6 ~= check) { check = 6 }
        let string = String(format: "%.\(check)f",self)
        return string
    }
    
}
