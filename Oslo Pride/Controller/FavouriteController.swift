//
//  FavouriteController.swift
//  Oslo Pride
//
//  Created by Adrian Evensen on 17/05/2019.
//  Copyright © 2019 Adrian Evensen. All rights reserved.
//

import UIKit

class FavouriteController: UITableViewController {
    
    var favourites: [Event]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Fetch saved favourites
        print("fetching")
        CoreDataManager.shared.getFavourites { (fav) in
            fav.forEach({ (f) in
                print(f.title)
            })
        }
    }
    
    
    
    
}
