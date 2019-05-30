//
//  DownloadController.swift
//  Oslo Pride
//
//  Created by Adrian Evensen on 17/05/2019.
//  Copyright © 2019 Adrian Evensen. All rights reserved.
//

import UIKit

class DownloadController: UIViewController {
    
    let progressBar: UIProgressView = {
        let pb = UIProgressView(progressViewStyle: .bar)
        pb.translatesAutoresizingMaskIntoConstraints = false
        pb.progressTintColor = .prideGreen
        pb.backgroundColor = UIColor(white: 0, alpha: 0.2)
        pb.layer.cornerRadius = 5
        pb.clipsToBounds = true
        
        return pb
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textColor = .kindaBlack
        label.text = "Laster ned 🏳️‍🌈 eventer"
        label.numberOfLines = 0
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        downloadEvents()
    }
    
    var total = 0
    var current = 0
    
    fileprivate func setupUI() {
        view.addSubview(progressBar)
        [
            progressBar.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            progressBar.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24),
            progressBar.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -24),
            progressBar.heightAnchor.constraint(equalToConstant: 10)
            ].forEach { $0.isActive = true }
        
        view.addSubview(titleLabel)
        [
            //titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            titleLabel.bottomAnchor.constraint(equalTo: progressBar.topAnchor, constant: -24),
            titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            titleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24),
            ].forEach { $0.isActive = true }
    }
    
    fileprivate func downloadEvents() {
        NetworkAPI.shared.fetchEvents { [unowned self] (sanityEvents) in
            guard let sanityEvents = sanityEvents else { return }
            self.total = sanityEvents.count-1
            let group = DispatchGroup()
            
            var eventCache = [Event]()
            
            sanityEvents.forEach({ (sanityEvent) in
                group.enter()
                CoreDataManager.shared.save(event: sanityEvent, completion: { (event, err) in
                    if let err = err {
                        print("failed to add event to core data: ", err)
                        return
                    }
                    guard let event = event else { return }
                    eventCache.append(event)
                    if let url = event.imageURL {
                        NetworkAPI.shared.fetchImage(from: url, completion: { [unowned self] (data) in
                            guard let data = data else { return }
                            
                            let formatter = ByteCountFormatter()
                            formatter.allowedUnits = [.useMB]
                            formatter.countStyle = .file
                            let string = formatter.string(fromByteCount: Int64(data.count))
                            print("formatted result: ", string)
                            
                            guard let img = UIImage(data: data)?.jpegData(compressionQuality: 0.3) else { return }
                                CoreDataManager.shared.updateEventImage(event, image: img, completion: { (err) in
                                    group.leave()
                                    self.current += 1
                                    //DispatchQueue.main.async {
                                        let percentage = Float(self.current)/Float(self.total)
                                        self.progressBar.setProgress(percentage, animated: true)
                                    //}
                                    print("\(self.current) / \(self.total)")
                                })
  
                        })
                        
                    } else {
                        group.leave()
                    }
                })
            })
            group.notify(queue: .main, execute: { [unowned self] in
                EventsManager.shared.set(events: eventCache)
                self.dismiss(animated: true, completion: nil)
                
            })
        }
    }
    
    deinit {
        print("goodbye download controller")
    }
    
}
