//
//  ViewController.swift
//  Oslo Pride
//
//  Created by Adrian Evensen on 28/04/2019.
//  Copyright © 2019 Adrian Evensen. All rights reserved.
//

import UIKit

class EventsController: UITableViewController {

    var events: [Event]?
    var days: [[Event]]?
    
    let cellID = "cellID"
    
    var refreshController = UIRefreshControl()
    
    let headerView = EventsFilterHeaderView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Events"
        view.backgroundColor = .white
        tableView.register(EventCell.self, forCellReuseIdentifier: cellID)
        navigationController?.navigationBar.tintColor = .prideDeepPurple//.prideYellow
        setupNavItems()
//        navigationController?.navigationBar.prefersLargeTitles = true
//        navigationController?.navigationBar.largeTitleTextAttributes = [
//            NSAttributedString.Key.foregroundColor : UIColor.pridePurple
//        ]
//        navigationController?.navigationBar.titleTextAttributes = [
//            NSAttributedString.Key.foregroundColor : UIColor.pridePurple
//        ]
        
        refreshController.addTarget(self, action: #selector(updateEvents), for: .valueChanged)
        tableView.refreshControl = refreshController
        
        headerView.delegate = self
        tableView.tableHeaderView = headerView
        tableView.tableHeaderView?.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 70)
        
        tableView.tableFooterView = UIView()
        
        displayEvents()
    }
    
    lazy var right = UIBarButtonItem(image: UIImage(named: "refresh"), style: .plain, target: self, action: #selector(updateEvents))
    
    fileprivate func setupNavItems() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Slett", style: .plain, target: self, action: #selector(reset))
        navigationItem.rightBarButtonItem = right
    }
    
    @objc fileprivate func reset() {
//        CoreDataManager.shared.delete(events: EventsManager.shared.get(), completion: { err in
//            if let err = err {
//                print("failed to delete: ", err)
//            }
//            self.displayEvents()
//        })
    }
    
    @objc fileprivate func updateEvents() {
        right.isEnabled = false
        
        CoreDataManager.shared.getAllEvents { (local) in
            NetworkAPI.shared.fetchEvents { (remote) in
                
                guard let remote = remote else { return }
                let newEvents = EventsManager.shared.compare(local: local, remote: remote)
                print("We have \(newEvents.count) unsynced events")
                
                DispatchQueue.main.async {
                    CoreDataManager.shared.save(events: newEvents, completion: { (newLocalEvents, err) in
                        if let err = err {
                            print("failed to batch save: ", err)
                        }
                        print("We saved \(newLocalEvents?.count ?? 0) new events")
                        self.displayEvents()
                    })
                }
            }
        }
    }
    
    @objc fileprivate func displayEvents() {
        DispatchQueue.main.async {
            CoreDataManager.shared.getAllEvents { (events) in
                EventsManager.shared.set(events: events)
                self.days = EventsManager.shared.get()
                self.tableView.reloadData()
                self.refreshController.endRefreshing()
                self.right.isEnabled = true
            }
        }
    }

}

extension EventsController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return days?.count ?? 0
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return days?[section].count ?? 0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! EventCell
        cell.eventImageView.image = nil
        
        guard let event = days?[indexPath.section][indexPath.row] else { return cell }
        cell.eventTitleLabel.text = event.title ?? "whap"
        if let imageData = event.image {
            cell.eventImageView.image = UIImage(data: imageData)
            cell.eventImageView.contentMode = .scaleAspectFill
        } else {
            cell.eventImageView.image = UIImage(named: "trekanter")
            cell.eventImageView.contentMode = .scaleAspectFit
        }
        cell.event = event
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerLabel = TableViewHeaderLabel()
        guard let t = days?[section].first?.startingTime else { return nil }
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE dd"
        formatter.locale = Locale(identifier: "NO-BM")
        
        let timeText = formatter.string(from: t)
        
        headerLabel.text = (timeText.first?.uppercased() ?? "") + timeText.dropFirst().lowercased()
        
        let containerView = UIView()
        containerView.addSubview(headerLabel)
        headerLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        headerLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        
        
        return containerView
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let c = EventController()
        c.event = days?[indexPath.section][indexPath.row]
        
        navigationController?.pushViewController(c, animated: true)
    }
    
}

extension EventsController: EventsFilterHeaderViewDelegte {
    
    func updateFilter(_ filter: Filter, remove: Bool) {
        print("updating")
        EventsManager.shared.addCategoryFilter(filter.category, remove: remove)
        self.days = EventsManager.shared.get()
        tableView.reloadData()
    }
    
    
    
    
}
