import MapKit
import UIKit
import UserNotifications

class FavoriteController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var favorites: [Event]?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
    }
    
    fileprivate func setupController() {
        collectionView.backgroundColor = UIColor(red: 0.93, green: 0.93, blue: 0.96, alpha: 1.0)
        view.backgroundColor = .white
        collectionView.register(FavoriteCell.self, forCellWithReuseIdentifier: "cellid")
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "bottom")
        navigationController?.isNavigationBarHidden = true
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(didDismissEvent))
    }
    
    @objc fileprivate func didDismissEvent() {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        CoreDataManager.shared.getFavorites { fav in
            var fav = fav
            fav.sort(by: { (e1, e2) -> Bool in
                guard let t1 = e1.startingTime, let t2 = e2.startingTime else { return false }
                return t1 < t2
            })
            
            DispatchQueue.main.async {
                self.favorites = fav
                self.collectionView.reloadData()
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let event = favorites?[indexPath.row] else { return }
        let eventController = EventController()
        eventController.event = event
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.pushViewController(eventController, animated: true)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favorites?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellid", for: indexPath) as! FavoriteCell
        cell.layer.cornerRadius = 15
        cell.clipsToBounds = true
        
        cell.backgroundColor = .white
        cell.event = favorites![indexPath.row]
        cell.delegate = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return favorites?.count ?? 0 > 0 ? CGSize(width: view.frame.width, height: 0) : CGSize(width: view.frame.width, height: 300)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "bottom", for: indexPath)
            let label = UILabel()
            label.font = UIFont.boldSystemFont(ofSize: 16)
            label.textColor = .graySuit
            label.numberOfLines = 0
            label.textAlignment = .center
            label.text = "Du kan legge til favoritter fra Events"
            label.translatesAutoresizingMaskIntoConstraints = false
            footer.addSubview(label)
            label.centerXAnchor.constraint(equalTo: footer.centerXAnchor).isActive = true
            label.centerYAnchor.constraint(equalTo: footer.centerYAnchor).isActive = true
            return footer
        }
        
        return UICollectionReusableView()
    }
}

extension FavoriteController: FavoriteCellDelegate {
    func createNotification(_ event: Event, handler: @escaping (Error?) -> ()) {
        let actionSheet = UIAlertController(title: "Påminnelse", message: "Velg tiden før eventet starter du vil få påminnelsen", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "En Time", style: .default, handler: { _ in
            self.addNotification(on: event.startingTime?.addingTimeInterval(-3600) ?? Date(), title: event.title ?? "", body: "en time", id: event.id ?? "", handler: handler)
        }))
        actionSheet.addAction(UIAlertAction(title: "45 Minutter", style: .default, handler: { _ in
            self.addNotification(on: event.startingTime?.addingTimeInterval(-2700) ?? Date(), title: event.title ?? "", body: "45 minutter", id: event.id ?? "", handler: handler)
        }))
        actionSheet.addAction(UIAlertAction(title: "30 Minutter", style: .default, handler: { _ in
            self.addNotification(on: event.startingTime?.addingTimeInterval(-1800) ?? Date(), title: event.title ?? "", body: "30 minutter", id: event.id ?? "", handler: handler)
        }))
        actionSheet.addAction(UIAlertAction(title: "15 Minutter", style: .default, handler: { _ in
            self.addNotification(on: event.startingTime?.addingTimeInterval(-900) ?? Date(), title: event.title ?? "", body: "15 minutter", id: event.id ?? "", handler: handler)
        }))
//        actionSheet.addAction(UIAlertAction(title: "10 sekunder", style: .default, handler: { (_) in
//            self.addNotification(on: Date().addingTimeInterval(10), title: event.title ?? "", body: "10 sekunder", id: event.id ?? "", handler: handler)
//        }))
        actionSheet.addAction(UIAlertAction(title: "Avbryt", style: .cancel, handler: nil))
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    fileprivate func addNotification(on time: Date, title: String, body: String, id: String, handler: @escaping (Error?) -> ()) {
        let auth = UNAuthorizationOptions(arrayLiteral: [.alert])
        UNUserNotificationCenter.current().requestAuthorization(options: auth) { didConsent, err in
            if let err = err {
                print("failed to ask for consent: ", err)
                handler(err)
                return
            }
            
            guard didConsent else {
                print("did not consent")
                return
            }
            
            let content = UNMutableNotificationContent()
            content.title = title
            content.body = "Eventet starter om " + body
            let interval = time.timeIntervalSinceNow
            print("Interval: ", interval)
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: false)
            let req = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(req) { err in
                if let err = err {
                    print("failed to create notification: ", err)
                    handler(err)
                    return
                }
                print("all good")
                handler(nil)
            }
        }
    }
    
    func presentDirections(_ event: Event) {
        let address = event.locationAddress?.replacingOccurrences(of: " ", with: "+")
        guard let url = URL(string: "http://maps.apple.com/?address=\(address ?? "")") else { return }
        print("yay")
        UIApplication.shared.open(url)
    }
    
    func presentDeleteConfirmation(_ event: Event) {
        let confimationController = UIAlertController(title: "Fjern Event", message: "Du kan finne det igjen under Events", preferredStyle: .actionSheet)
        confimationController.addAction(UIAlertAction(title: "Fjern", style: .destructive, handler: { _ in
            CoreDataManager.shared.toggleFavorite(event: event, completion: { err in
                if let err = err {
                    print("failed to toggle favorite: ", err)
                }
                
                var index = -1
                for i in 0..<(self.favorites?.count ?? 0) {
                    if self.favorites?[i].id == event.id {
                        index = i
                        break
                    }
                }
                guard index >= 0 else { return }
                
                DispatchQueue.main.async {
                    self.favorites?.remove(at: index)
                    self.collectionView.deleteItems(at: [IndexPath(row: index, section: 0)])
                }
            })
        }))
        confimationController.addAction(UIAlertAction(title: "Avbryt", style: .cancel, handler: nil))
        present(confimationController, animated: true, completion: nil)
    }
}
