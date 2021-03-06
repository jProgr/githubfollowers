import UIKit

extension UIViewController
{
    func presentGFAlertOnMainThread(title: String, message: String, buttonTitle: String)
    {
        DispatchQueue.main.async {
            let alertViewController = GFAlertViewController(title: title, message: message, buttonTitle: buttonTitle)
            alertViewController.modalPresentationStyle = .overFullScreen
            alertViewController.modalTransitionStyle = .crossDissolve

            self.present(alertViewController, animated: true)
        }
    }
}
