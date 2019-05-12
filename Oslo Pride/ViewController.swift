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
    let cellID = "cellID"
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Events"
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        cell.textLabel?.text = events?[indexPath.row].title ?? ""
        return cell
    }
    
}
