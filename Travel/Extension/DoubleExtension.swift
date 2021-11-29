import Foundation

extension Double {
    
    func toString(_ decimal: Int = 1) -> String {
        var check = decimal
        if !(1...3 ~= check) { check = 1 }
        let string = String(format: "%.\(check)f",self)
        return string
    }
    
}
