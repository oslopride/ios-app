import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewController = EventsController()
        viewController.tabBarItem = UITabBarItem(title: "Program", image: UIImage(named: "event_twotone"), tag: 0)

        let mapController = MapController()
        let mapNavController = UINavigationController(rootViewController: mapController)
        mapNavController.tabBarItem = UITabBarItem(title: "Kart", image: UIImage(named: "map_twotone"), tag: 1)
        mapNavController.isNavigationBarHidden = true
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: view.frame.width - 14 * 2, height: 440)
        flowLayout.minimumLineSpacing = 24
        
        let favouriteController = FavouriteController(collectionViewLayout: flowLayout)
        favouriteController.collectionView.contentInset = .init(top: 24, left: 0, bottom: 24, right: 0)
        
        let favouriteNavController = UINavigationController(rootViewController: favouriteController)
        favouriteNavController.tabBarItem = UITabBarItem(title: "Favoritter", image: UIImage(named: "star_twotone"), tag: 2)
        favouriteNavController.view.backgroundColor = .white
        favouriteNavController.isNavigationBarHidden = true
        tabBar.tintColor = .prideRed
        
        let navViewController = UINavigationController(rootViewController: viewController)
        navViewController.view.backgroundColor = .white
        
        let infoController = InfoController()
        infoController.tabBarItem = UITabBarItem(title: "Info", image: UIImage(named: "info"), tag: 3)
        
        viewControllers = [
            favouriteNavController,
            navViewController,
            mapNavController,
            infoController
        ]
    }
}
