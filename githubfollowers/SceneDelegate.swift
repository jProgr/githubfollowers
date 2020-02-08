import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate
{
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions)
    {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let searchNavigationController = UINavigationController(rootViewController: SearchViewController())
        let favsNavigationController = UINavigationController(rootViewController: FavoritesListViewController())

        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [searchNavigationController, favsNavigationController]

        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene)
    {
    }

    func sceneDidBecomeActive(_ scene: UIScene)
    {
    }

    func sceneWillResignActive(_ scene: UIScene)
    {
    }

    func sceneWillEnterForeground(_ scene: UIScene)
    {
    }

    func sceneDidEnterBackground(_ scene: UIScene)
    {
    }
}
