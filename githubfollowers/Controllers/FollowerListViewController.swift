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
        NetworkManager.shared.getFollowers(for: username, page: 1) { followers, errorMessage in
            guard let followers = followers else
            {
               self.presentGFAlertOnMainThread(title: "?", message: errorMessage!, buttonTitle: "Ok")
               return
            }

            print(followers)
       }
    }
}
