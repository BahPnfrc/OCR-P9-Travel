import Foundation
import UIKit

class Shared {
    
    static var defaultShowErrorMessage = "Un appel réseau n'a pas abouti.\nMerci de réessayer plus tard."
    
    static func startAnimation(of spinner: UIActivityIndicatorView?, locking button: UIButton?) {
        guard let spinner = spinner, let button = button else { return }
        spinner.startAnimating()
        button.isUserInteractionEnabled = false
        button.backgroundColor = UIColor.systemPink
    }
    
    static func stopAnimation(of spinner: UIActivityIndicatorView?, unlocking button: UIButton?) {
        guard let spinner = spinner, let button = button else { return }
        spinner.stopAnimating()
        button.isUserInteractionEnabled = true
        button.backgroundColor = UIColor.systemGreen
    }
    
    static func ShowError(with message: String, inView view: UIViewController) {
        let alert = UIAlertController(title: "Travel", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        view.present(alert, animated: true, completion: nil)
        return
    }
    
    static func clearText(of textController: UIView, rotating image: UIImageView) {
        guard textController is UITextField || textController is UITextView else { return }
        UIView.animate(withDuration: 0.5, animations: {
            image.transform = CGAffineTransform.init(rotationAngle: .pi)
            if let textController = textController as? UITextField {
                textController.text = nil
            } else if let textController = textController as? UITextView {
                textController.text = nil
            }
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, animations: {
                image.transform = CGAffineTransform.identity
                textController.becomeFirstResponder()
            })
        })
    }
    
}
