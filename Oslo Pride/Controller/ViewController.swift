//
//  ViewController.swift
//  Oslo Pride
//
//  Created by Adrian Evensen on 28/04/2019.
//  Copyright © 2019 Adrian Evensen. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var events: [Event]?
    var days: [[Event]]?
    
    let cellID = "cellID"
    
    var refreshController = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Events"
        view.backgroundColor = .white
        tableView.register(EventCell.self, forCellReuseIdentifier: cellID)
        
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "headerfooter")
        //navigationController?.navigationBar.prefersLargeTitles = true
        setupNavItems()
        navigationController?.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor.pridePurple
        ]
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor.pridePurple
        ]
        
        refreshController.addTarget(self, action: #selector(displayEvents), for: .valueChanged)
        //tableView.refreshControl = refreshController
        
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
    
    @objc fileprivate func displayEvents() {
        CoreDataManager.shared.getAllEvents { [unowned self] (events) in
            var events = events
            events.sort(by: { (one, two) -> Bool in
                guard let date1 = one.startingTime, let date2 = two.startingTime else { return false }
                return date1 < date2
            })
            
            var days = [[Event]]()
            for i in 0..<events.count {
                if days.count == 0 {
                    days.append([events[0]])
                    continue
                }
                
                if let last = days.last?.last?.startingTime, let current = events[i].startingTime {
                    let lastHour = Calendar.current.component(.hour, from: last)
                    let lastDay = Calendar.current.component(.day, from: last)
                    
                    let currentHour = Calendar.current.component(.hour, from: current)
                    let currentDay = Calendar.current.component(.day, from: current)
                    
                    if currentDay > lastDay {
                        days.append([events[i]])
                    } else {
                        days[days.count-1].append(events[i])
                    }
                }
            }
            
            self.days = days
            
            self.events = events
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.refreshController.endRefreshing()
            }
        }
    }

}

extension ViewController {
    
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
        }
        
        cell.eventOrganizerLabel.text = event.organizer
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UITableViewHeaderFooterView(reuseIdentifier: "headerfooter")
        
        guard let time = days?[section].first?.startingTime else { return nil }
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE dd"
        formatter.locale = Locale(identifier: "NO-BM")
        
        let timeText = formatter.string(from: time)
        
        view.textLabel?.text = (timeText.first?.uppercased() ?? "") + timeText.dropFirst().lowercased()
        
        return view
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let c = EventController()
        //c.title = events?[indexPath.row].title ?? ""
        c.event = days?[indexPath.section][indexPath.row]
        navigationController?.pushViewController(c, animated: true)
    }
    
}

extension ViewController {
    
    
    
}
