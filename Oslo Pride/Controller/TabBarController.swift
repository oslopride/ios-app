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
        
        viewControllers = [
            UINavigationController(rootViewController: viewController),
            MapController()
        ]
        
    }
}
