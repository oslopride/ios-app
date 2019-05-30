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
        
        refreshController.addTarget(self, action: #selector(displayEvents), for: .valueChanged)
        tableView.refreshControl = refreshController
        
        displayEvents()
    }
    
    fileprivate func setupNavItems() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Slett", style: .plain, target: self, action: #selector(reset))
    }
    
    @objc fileprivate func reset() {
        CoreDataManager.shared.getAllEvents { (events) in
            CoreDataManager.shared.delete(events: events)
            self.displayEvents()
        }
    }
    
    @objc fileprivate func updateEvents() {
        CoreDataManager.shared.getAllEvents { (events) in
            EventsManager.shared.set(events: events)
            self.displayEvents()
        }
    }
    
    @objc fileprivate func displayEvents() {
        CoreDataManager.shared.getAllEvents { (events) in
            EventsManager.shared.set(events: events)
            //self.displayEvents()
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.refreshController.endRefreshing()
        }
    }

}

extension EventsController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return EventsManager.shared.numberOfDays
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EventsManager.shared.numberInDay(section)
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! EventCell
        cell.eventImageView.image = nil
        
        guard let event = EventsManager.shared.get(day: indexPath.section, n: indexPath.row) else { return cell }
        cell.eventTitleLabel.text = event.title ?? "whap"
        if let imageData = event.image {
            cell.eventImageView.image = UIImage(data: imageData)
        }
        cell.event = event
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerLabel = TableViewHeaderLabel()
        guard let t = EventsManager.shared.get(day: section, n: 0)?.startingTime else { return nil }
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
        c.event = EventsManager.shared.get(day: indexPath.section, n: indexPath.row)
        navigationController?.pushViewController(c, animated: true)
    }
    
}

extension EventsController {
    
    
    
}
