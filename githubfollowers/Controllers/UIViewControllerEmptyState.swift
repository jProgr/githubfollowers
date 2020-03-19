import UIKit

extension UIViewController
{
    func showEmptyStateView(with message: String, in view: UIView)
    {
        let emptyStateView = GFEmptyStateView(message: message)
        emptyStateView.frame = view.bounds
        view.addSubview(emptyStateView)
    }
}
