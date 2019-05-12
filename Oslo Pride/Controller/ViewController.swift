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
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.register(EventCell.self, forCellReuseIdentifier: cellID)
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Events"
        
        navigationController?.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor.hotPurple
        ]
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor.hotPurple
        ]
        
        fetchEvents()
    }

    fileprivate func fetchEvents() {
        NetworkAPI.shared.fetchEvents { (events) in
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
        //let cell = EventCell()
        guard let event = events?[indexPath.row] else { return cell }
        
        if let imgURL = event.imageURL, let imgData = NetworkAPI.shared.imageCache[imgURL] {
            cell.eventImageView.image = UIImage(data: imgData, scale: 0.2)
            
        } else {
            cell.eventImageView.image = nil
        }
        
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
