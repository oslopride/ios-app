import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let eventsFlowLayout = UICollectionViewFlowLayout()
        eventsFlowLayout.itemSize = CGSize(width: view.frame.width - 14, height: 200)
        eventsFlowLayout.minimumLineSpacing = 24
        
        let eventsController = EventsCollectionController(collectionViewLayout: eventsFlowLayout)
        eventsController.tabBarItem = UITabBarItem(title: "Program", image: UIImage(named: "event_twotone"), tag: 0)

        let eventsNavigationController = UINavigationController(rootViewController: eventsController)
        eventsNavigationController.view.backgroundColor = .white

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: view.frame.width - 14 * 2, height: 440)
        flowLayout.minimumLineSpacing = 24

        let favoriteController = FavoriteController(collectionViewLayout: flowLayout)
        favoriteController.collectionView.contentInset = .init(top: 24, left: 0, bottom: 24, right: 0)

        let favoriteNavigationController = UINavigationController(rootViewController: favoriteController)
        favoriteNavigationController.tabBarItem = UITabBarItem(title: "Favoritter", image: UIImage(named: "star_twotone"), tag: 2)
        favoriteNavigationController.view.backgroundColor = .white
        favoriteNavigationController.isNavigationBarHidden = true

        let mapController = MapController()
        let mapNavigationController = UINavigationController(rootViewController: mapController)
        mapNavigationController.tabBarItem = UITabBarItem(title: "Kart", image: UIImage(named: "map_twotone"), tag: 1)
        mapNavigationController.isNavigationBarHidden = true

        let infoController = InfoController()
        infoController.tabBarItem = UITabBarItem(title: "Info", image: UIImage(named: "info"), tag: 3)

        tabBar.tintColor = .prideRed

        viewControllers = [
            eventsNavigationController,
            favoriteNavigationController,
            mapNavigationController,
            infoController
        ]
    }
}
