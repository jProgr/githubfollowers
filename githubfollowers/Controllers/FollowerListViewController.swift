import UIKit

class FollowerListViewController: UIViewController
{
    enum Section
    {
        case main
    }

    var username: String!
    var followers: [Follower] = []
    var filteredFollowers: [Follower] = []
    var page = 1
    var hasMoreFollowers = true
    var isSearching = false

    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!

    override func viewDidLoad()
    {
        super.viewDidLoad()

        configureViewController()
        configureSearchController()
        configureCollectionView()
        getFollowers(username: username, page: page)
        configureDataSource()
    }

    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    func configureViewController()
    {
        view.backgroundColor = .systemBackground
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    func getFollowers(username: String, page: Int)
    {
        showLoadingView()

        NetworkManager.shared.getFollowers(for: username, page: page) { [weak self] result in
            guard let self = self else { return }
            self.dismissLoadingView()
            switch result
            {
                case .success(let followers):
                    if followers.count < 100 { self.hasMoreFollowers = false }
                    self.followers.append(contentsOf: followers)

                    if self.followers.isEmpty
                    {
                        let message = "This user doesn't have any followers."
                        DispatchQueue.main.async { self.showEmptyStateView(with: message, in: self.view) }
                        return
                    }

                    self.updateData(on: self.followers)

                case .failure(let error):
                    self.presentGFAlertOnMainThread(title: "?", message: error.rawValue, buttonTitle: "Ok")
            }
       }
    }

    func configureCollectionView()
    {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
        collectionView.delegate = self
    }

    func configureDataSource()
    {
        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, follower) -> UICollectionViewCell? in
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: FollowerCell.reuseID,
                    for: indexPath
                ) as! FollowerCell
                cell.set(follower: follower)

                return cell
            }
        )
    }

    func updateData(on followers: [Follower])
    {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        DispatchQueue.main.async { self.dataSource.apply(snapshot, animatingDifferences: true) }
    }

    func configureSearchController()
    {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search for a username"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
    }
}

extension FollowerListViewController: UICollectionViewDelegate
{
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate delerate: Bool)
    {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height

        if offsetY > contentHeight - height
        {
            guard hasMoreFollowers else { return }
            page += 1
            getFollowers(username: username, page: page)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let activeArray = isSearching ? filteredFollowers : followers
        let follower = activeArray[indexPath.item]

        let destinationViewController = UserInfoViewController()
        destinationViewController.username = follower.login
        let navigationController = UINavigationController(rootViewController: destinationViewController)

        present(navigationController, animated: true)
    }
}

extension FollowerListViewController: UISearchResultsUpdating, UISearchBarDelegate
{
    func updateSearchResults(for searchController: UISearchController)
    {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else { return }

        isSearching = true

        filteredFollowers = followers.filter { $0.login.lowercased().contains(filter.lowercased()) }
        updateData(on: filteredFollowers)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        isSearching = false
        updateData(on: followers)
    }
}
