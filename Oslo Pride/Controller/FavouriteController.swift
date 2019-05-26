//
//  FavouriteController.swift
//  Oslo Pride
//
//  Created by Adrian Evensen on 17/05/2019.
//  Copyright © 2019 Adrian Evensen. All rights reserved.
//

import UIKit
import MapKit
import UserNotifications

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
    func createNotification(_ event: Event) {
        
        let actionSheet = UIAlertController(title: "Påminnelse", message: "Velg tiden før eventet starter du vil få påminnelsen", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "En Time", style: .default, handler: { (_) in
            self.addNotification(after: 3600, title: event.title ?? "", body: "en time", id: event.id ?? "")
        }))
        actionSheet.addAction(UIAlertAction(title: "45 Minutter", style: .default, handler: { (_) in
            self.addNotification(after: 2700, title: event.title ?? "", body: "45 minutter", id: event.id ?? "")
        }))
        actionSheet.addAction(UIAlertAction(title: "30 Minutter", style: .default, handler: { (_) in
            self.addNotification(after: 1800, title: event.title ?? "", body: "30 minutter", id: event.id ?? "")
        }))
        actionSheet.addAction(UIAlertAction(title: "15 Minutter", style: .default, handler: { (_) in
            self.addNotification(after: 900, title: event.title ?? "", body: "15 minutter", id: event.id ?? "")
        }))
        actionSheet.addAction(UIAlertAction(title: "10 sekunder", style: .default, handler: { (_) in
            self.addNotification(after: 10, title: event.title ?? "", body: "10 sekunder", id: event.id ?? "")
        }))
        actionSheet.addAction(UIAlertAction(title: "Avbryt", style: .cancel, handler: nil))

        present(actionSheet, animated: true, completion: nil)
    }
    
    fileprivate func addNotification(after time: TimeInterval, title: String, body: String, id: String) {
        let auth = UNAuthorizationOptions(arrayLiteral: [.alert])
        UNUserNotificationCenter.current().requestAuthorization(options: auth) { [unowned self] (didConsent, err) in
            if let err = err {
                print("failed to ask for consent: ", err)
                return
            }
            
            guard didConsent else {
                print("did not consent")
                return
            }
            
            let content = UNMutableNotificationContent()
            content.title = title
            content.body = "Eventet starter om " + body
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: time, repeats: false)
            let req = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(req) { (err) in
                if let err = err {
                    print("failed to create notification: ", err)
                    return
                }
                print("all good")
            }
        }
    }
    
    func presentDirections(_ event: Event) {
        let address = event.locationAddress?.replacingOccurrences(of: " ", with: "+")
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
