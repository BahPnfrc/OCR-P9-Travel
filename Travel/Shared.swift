import Foundation
import UIKit

class Shared {

    static var defaultShowErrorMessage = "L'opération demandée a échoué. Vérifiez ou différez la demande."

    /// Animate a spinner while locking a button
    static func startAnimation(of spinner: UIActivityIndicatorView?, locking button: UIButton?) {
        guard let spinner = spinner, let button = button else { return }
        spinner.startAnimating()
        button.isUserInteractionEnabled = false
        button.backgroundColor = UIColor.systemPink
    }

    /// Stop a spinner while unlocking a button
    static func stopAnimation(of spinner: UIActivityIndicatorView?, unlocking button: UIButton?) {
        guard let spinner = spinner, let button = button else { return }
        spinner.stopAnimating()
        button.isUserInteractionEnabled = true
        button.backgroundColor = UIColor.systemGreen
    }

    /// Show an alert in a given `view` when an error occur
    static func showError(with message: String, inView view: UIViewController) {
        let alert = UIAlertController(title: "Travel", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        view.present(alert, animated: true, completion: nil)
        return
    }

    /// Animate an `image` while clearing the text of a controller
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
