//
//  FavouriteController.swift
//  Oslo Pride
//
//  Created by Adrian Evensen on 17/05/2019.
//  Copyright © 2019 Adrian Evensen. All rights reserved.
//

import UIKit
import MapKit

class FavouriteController: UICollectionViewController {
    
    var favourites: [Event]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = UIColor(red:0.93, green:0.93, blue:0.96, alpha:1.0)
        view.backgroundColor = .white
        collectionView.register(FavouriteCell.self, forCellWithReuseIdentifier: "cellid")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        CoreDataManager.shared.getFavourites { (fav) in
            var fav = fav
            fav.sort(by: { (e1, e2) -> Bool in
                guard let t1 = e1.startingTime, let t2 = e2.startingTime else { return false }
                return t1 < t2
            })
            DispatchQueue.main.async {
                self.favourites = fav
                self.collectionView.reloadData()
            }
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favourites?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellid", for: indexPath) as! FavouriteCell
        cell.layer.cornerRadius = 15
        cell.clipsToBounds = true
        
        cell.backgroundColor = .white
        cell.event = favourites![indexPath.row]
        cell.delegate = self
        
        return cell
    }
    
    
}

extension FavouriteController: FavouriteCellDelegate {
    func presentDirections(_ event: Event) {
        let address = event.locationAddress?.replacingOccurrences(of: " ", with: "")
        guard let url = URL(string:"http://maps.apple.com/?address=\(address ?? "")") else { return }
        print("yay")
        UIApplication.shared.open(url)
    }
    
    func presentDeleteConfirmation(_ event: Event) {
        let confimationController = UIAlertController(title: "Fjern Event", message: "Du kan finne det igjen under Events", preferredStyle: .actionSheet)
        confimationController.addAction(UIAlertAction(title: "Fjern", style: .destructive, handler: { (_) in
            CoreDataManager.shared.toggleFavourite(event: event, completion: { (err) in
                if let err = err {
                    print("failed to toggle favorite: ", err)
                }
                
                var index = -1
                for i in 0..<(self.favourites?.count ?? 0) {
                    if self.favourites?[i].id == event.id {
                        index = i
                        break
                    }
                }
                guard index >= 0 else { return }

                DispatchQueue.main.async {
                    self.favourites?.remove(at: index)
                    self.collectionView.deleteItems(at: [IndexPath(row: index, section: 0)])
                }
            })
        }))
        confimationController.addAction(UIAlertAction(title: "Avbryt", style: .cancel, handler: nil))
        present(confimationController, animated: true, completion: nil)
    }
    
    
}
