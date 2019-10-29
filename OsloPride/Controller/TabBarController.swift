import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let eventsController = EventsController()
        eventsController.tabBarItem = UITabBarItem(title: "Program", image: UIImage(named: "event_twotone"), tag: 0)

        let eventsNavigationController = UINavigationController(rootViewController: eventsController)
        eventsNavigationController.view.backgroundColor = .white

        let mapController = MapController()
        let mapNavigationController = UINavigationController(rootViewController: mapController)
        mapNavigationController.tabBarItem = UITabBarItem(title: "Kart", image: UIImage(named: "map_twotone"), tag: 1)
        mapNavigationController.isNavigationBarHidden = true
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: view.frame.width - 14 * 2, height: 440)
        flowLayout.minimumLineSpacing = 24
        
        let favouriteController = FavouriteController(collectionViewLayout: flowLayout)
        favouriteController.collectionView.contentInset = .init(top: 24, left: 0, bottom: 24, right: 0)
        
        let favouriteNavigationController = UINavigationController(rootViewController: favouriteController)
        favouriteNavigationController.tabBarItem = UITabBarItem(title: "Favoritter", image: UIImage(named: "star_twotone"), tag: 2)
        favouriteNavigationController.view.backgroundColor = .white
        favouriteNavigationController.isNavigationBarHidden = true

        let infoController = InfoController()
        infoController.tabBarItem = UITabBarItem(title: "Info", image: UIImage(named: "info"), tag: 3)

        tabBar.tintColor = .prideRed

        viewControllers = [
            eventsNavigationController,
            favouriteNavigationController,
            mapNavigationController,
            infoController
        ]
    }
}
