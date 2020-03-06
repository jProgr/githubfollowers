import UIKit

class FollowerListViewController: UIViewController
{
    var username: String!

    override func viewDidLoad()
    {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.prefersLargeTitles = true

        getFollowers()
    }

    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    func getFollowers()
    {
        NetworkManager.shared.getFollowers(for: username, page: 1) { result in
            switch result
            {
                case .success(let followers):
                    print(followers)
                case .failure(let error):
                    self.presentGFAlertOnMainThread(title: "?", message: error.rawValue, buttonTitle: "Ok")
            }
       }
    }
}
