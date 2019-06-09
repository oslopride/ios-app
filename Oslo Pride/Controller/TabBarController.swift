//
//  TabBarController.swift
//  Oslo Pride
//
//  Created by Adrian Evensen on 12/05/2019.
//  Copyright © 2019 Adrian Evensen. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewController = EventsController()
        viewController.tabBarItem = UITabBarItem(title: "Events", image: UIImage(named: "event_twotone"), tag: 0)
        
        let mapController = MapController()
        mapController.tabBarItem = UITabBarItem(title: "Kart", image: UIImage(named: "map_twotone"), tag: 1)
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: view.frame.width-14*2, height: 420 /* ☘️ */) //(view.frame.width-14*2) * 1.18)
        flowLayout.minimumLineSpacing = 24
        
        let favouriteController = FavouriteController(collectionViewLayout: flowLayout)
        favouriteController.collectionView.contentInset = .init(top: 24, left: 0, bottom: 24, right: 0)
        //favouriteController.tabBarItem = UITabBarItem(title: "Favoritter", image: UIImage(named: "star_twotone"), tag: 2)
        let favouriteNavController = UINavigationController(rootViewController: favouriteController)
        favouriteNavController.tabBarItem = UITabBarItem(title: "Favoritter", image: UIImage(named: "star_twotone"), tag: 2)
        favouriteNavController.view.backgroundColor = .white
        tabBar.tintColor = .prideRed
        
        let navViewController = UINavigationController(rootViewController: viewController)
        navViewController.view.backgroundColor = .white
        
        let infoController = UIViewController()
        infoController.view.backgroundColor = .white
        infoController.tabBarItem = UITabBarItem(title: "Info", image: UIImage(named: "info"), tag: 3)
        
        viewControllers = [
            favouriteNavController,
            navViewController,
            mapController,
            infoController
        ]
    }
}
