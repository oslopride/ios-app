//
//  ViewController.swift
//  Oslo Pride
//
//  Created by Adrian Evensen on 28/04/2019.
//  Copyright © 2019 Adrian Evensen. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var events: [Event]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    var imageCache = [String : UIImage]()
    
    let cellID = "cellID"
    
    var refreshController = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Events"
        view.backgroundColor = .white
        tableView.register(EventCell.self, forCellReuseIdentifier: cellID)
        navigationController?.navigationBar.prefersLargeTitles = true
        setupNavItems()
        navigationController?.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor.pridePurple
        ]
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor.pridePurple
        ]
        
        refreshController.addTarget(self, action: #selector(downloadEvents), for: .valueChanged)
        tableView.refreshControl = refreshController
        
        displayEvents()
    }
    
    fileprivate func setupNavItems() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Slett", style: .plain, target: self, action: #selector(reset))
    }
    
    @objc fileprivate func reset() {
        guard let events = events else { return }
        CoreDataManager.shared.delete(events: events)
        displayEvents()
    }

    @objc fileprivate func downloadEvents() {
        NetworkAPI.shared.fetchEvents { (sanityEvents) in
            let group = DispatchGroup()
            var events = [Event]()
            sanityEvents.forEach({ (sanityEvent) in
                var exists = false
                let len = self.events?.count ?? 0
                for i in 0..<len {
                    if self.events?[i].id == sanityEvent.id {
                        exists = true
                        break
                    }
                }
                group.enter()
                if !exists {
                    CoreDataManager.shared.save(event: sanityEvent, completion: { (event, err) in
                        if let err = err {
                            print("failed to add event to core data: ", err)
                            return
                        }
                        guard let event = event else { return }
                        events.append(event)
                        group.leave()
                    })
                } else {
                    group.leave()
                    // Update current event
                    
                }
            })
            group.notify(queue: .main, execute: {
                self.refreshController.endRefreshing()
                self.displayEvents()
            })
        }
    }
    
    fileprivate func displayEvents() {
        CoreDataManager.shared.getAllEvents { (events) in
            DispatchQueue.main.async {
                self.events = events
            }
        }
    }

}

extension ViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events?.count ?? 0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! EventCell
        guard let event = events?[indexPath.row] else { return cell }
        cell.event = event
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let c = EventController()
        c.title = events?[indexPath.row].title ?? ""
        navigationController?.pushViewController(c, animated: true)
    }
    
}

extension ViewController {
    
    
    
}
