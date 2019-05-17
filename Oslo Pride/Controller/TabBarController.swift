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
        
        let viewController = ViewController()
        viewController.tabBarItem = UITabBarItem(title: "Events", image: UIImage(named: "event_twotone"), tag: 0)
        
        let mapController = MapController()
        mapController.tabBarItem = UITabBarItem(title: "Kart", image: UIImage(named: "map_twotone"), tag: 1)
        
        let favouriteController = FavouriteController()
        favouriteController.tabBarItem = UITabBarItem(title: "Favoritter", image: UIImage(named: "star_twotone"), tag: 2)
        
        tabBar.tintColor = .prideRed
        
        let navViewController = UINavigationController(rootViewController: viewController)
        navViewController.view.backgroundColor = .white
        
        viewControllers = [
            favouriteController,
            navViewController,
            mapController
        ]
    }
}
