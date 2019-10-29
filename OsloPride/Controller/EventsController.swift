//
//  ViewController.swift
//  Oslo Pride
//
//  Created by Adrian Evensen on 28/04/2019.
//  Copyright © 2019 Adrian Evensen. All rights reserved.
//

import SafariServices
import UIKit

class EventsController: UITableViewController {
    var events: [Event]?
    var days: [[Event]]?
    
    let cellID = "cellID"
    
    var refreshController = UIRefreshControl()
    
    let headerView = EventsFilterHeaderView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Program"
        view.backgroundColor = .white
        tableView.register(EventCell.self, forCellReuseIdentifier: cellID)
        navigationController?.navigationBar.tintColor = .prideDeepPurple
        setupNavItems()

        refreshController.addTarget(self, action: #selector(updateEvents), for: .valueChanged)
        tableView.refreshControl = refreshController
        
        headerView.delegate = self
        tableView.tableHeaderView = headerView
        tableView.tableHeaderView?.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 100) // 70)
        tableView.tableFooterView = UIView()
        
        displayEvents()
        updateEvents()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        headerView.scrollView.flashScrollIndicators()
    }

    fileprivate func setupNavItems() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)        
    }

    @objc fileprivate func updateEvents() {
        CoreDataManager.shared.getAllEvents { local in
            NetworkAPI.shared.fetchEvents { remote in
                
                guard let remote = remote else { return }
                let newEvents = EventsManager.shared.compare(local: local, remote: remote)
                print("We have \(newEvents.count) unsynced events")
                
                DispatchQueue.main.async {
                    CoreDataManager.shared.save(events: newEvents, completion: { newLocalEvents, err in
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
            CoreDataManager.shared.getAllEvents { events in
                EventsManager.shared.set(events: events)
                let days = EventsManager.shared.get()
                if days.count == 0 {
                    self.days = nil
                } else {
                    self.days = EventsManager.shared.get()
                }
                self.tableView.reloadData()
                self.refreshController.endRefreshing()
            }
        }
    }
}

extension EventsController {
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if days == nil {
            return 70
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let activityIndicator = UIActivityIndicatorView(style: .white)
        activityIndicator.color = UIColor.kindaBlack
        activityIndicator.startAnimating()
        
        return activityIndicator
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if days?.count == 0 || days == nil {
            return 1
        }
        return days?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return days?[section].count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! EventCell
        cell.eventImageView.image = nil
        cell.favouriteIndicator.isHidden = true
        guard let event = days?[indexPath.section][indexPath.row] else { return cell }
        cell.event = event
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if days == nil {
            let view = UIView()
            view.backgroundColor = .white
            return view
        }
        let headerLabel = TableViewHeaderLabel()
        headerLabel.numberOfLines = 2
        guard let t = days?[section].first?.startingTime else { return nil }
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE dd"
        formatter.locale = Locale(identifier: "NO-BM")
        
        let timeText = formatter.string(from: t)
        let txt = (timeText.first?.uppercased() ?? "") + timeText.dropFirst().lowercased()
        let day = Calendar.current.component(.day, from: t)
        
        let attrText = NSMutableAttributedString(string: txt, attributes: nil)
        attrText.append(NSAttributedString(string: "\nDag \(day - 13)", attributes: [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16),
            NSAttributedString.Key.foregroundColor: UIColor.graySuit
        ]))
        
        headerLabel.attributedText = attrText
        
        let containerView = UIView()
        containerView.addSubview(headerLabel)
        headerLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        headerLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        headerLabel.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        return containerView
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let c = EventController()
        c.event = days?[indexPath.section][indexPath.row]
        
        navigationController?.pushViewController(c, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 65
    }
}

extension EventsController: EventsFilterHeaderViewDelegte {
    func updateFilter(_ filter: Filter, remove: Bool) {
        EventsManager.shared.addCategoryFilter(filter.category, remove: remove)
        self.days = EventsManager.shared.get()
        tableView.reloadData()
    }
    
    func reloadTableview() {
        self.days = EventsManager.shared.get()
        self.tableView.reloadData()
    }
}
