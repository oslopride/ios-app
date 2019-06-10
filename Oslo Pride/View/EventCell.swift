//
//  EventCell.swift
//  Oslo Pride
//
//  Created by Adrian Evensen on 12/05/2019.
//  Copyright © 2019 Adrian Evensen. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell {
    
    let eventImageView: UIImageView = {
        let imv = UIImageView()
        imv.translatesAutoresizingMaskIntoConstraints = false
        imv.contentMode = .scaleAspectFill
        imv.clipsToBounds = true
        imv.layer.cornerRadius = 5
        //imv.backgroundColor = .hotYellow //UIColor(white: 0, alpha: 0.2)
        imv.tintColor = .hotYellow
        return imv
    }()
    
    let eventTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    
    let eventOrganizerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = 0
        label.textColor = .graySuit
        
        return label
    }()
    
    let eventCategoryLabel: EventCategoryLabel = {
        let label = EventCategoryLabel()
        label.textColor = .graySuit
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        //label.textColor = .white
        
        return label
    }()
    
    let favouriteIndicator: UIImageView = {
        let img = UIImageView(image: UIImage(named: "star_border"))
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleAspectFit
        img.tintColor = .graySuit
        img.isHidden = true
        
        return img
    }()
    
    var event: Event? {
        didSet {
            setupUI()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //eventImageView.image = nil
        setupLayout()
        
        NotificationCenter.default.addObserver(self, selector: #selector(imageDownloaded), name: .imageDownloadeddd, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didToggleFavourite), name: .didToggleFavourite, object: nil)
        
        
    }
    
    @objc fileprivate func didToggleFavourite(notification: Notification) {
        guard let id = notification.userInfo?["id"] as? String, id == event?.id else { return }
        guard let toggle = notification.userInfo?["toggle"] as? Bool else { return }
        favouriteIndicator.isHidden = !toggle
    }
    
    @objc fileprivate func imageDownloaded(notification: Notification) {
        guard let id = notification.userInfo?["id"] as? String, id == event?.id else { return }
        guard let imageData = notification.object as? Data else { return }
        DispatchQueue.main.async {
            guard let image = UIImage(data: imageData) else { return }
            self.eventImageView.contentMode = .scaleAspectFill
            self.eventImageView.image = image
        }
    }
    
    fileprivate func setupUI() {
        guard let event = event else { return }

        eventTitleLabel.text = event.title ?? "whap"

        if let imageData = event.image {
            eventImageView.image = UIImage(data: imageData)
            eventImageView.contentMode = .scaleAspectFill
        } else {
            eventImageView.image = UIImage(named: "trekanter")
            eventImageView.contentMode = .scaleAspectFit
        }
        
        if event.isFavourite {
            favouriteIndicator.isHidden = false
        }

        
        if let startingTime = event.startingTime, let endingTime = event.endingTime {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            eventOrganizerLabel.text = "\(formatter.string(from: startingTime)) - \(formatter.string(from: endingTime))"
        }
        eventCategoryLabel.category = event.category
        
    }
    
    fileprivate func setupLayout() {
        addSubview(eventImageView)
        [
            eventImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            eventImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            eventImageView.widthAnchor.constraint(equalToConstant: 100),
            eventImageView.heightAnchor.constraint(equalToConstant: 100),
            eventImageView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -10)
            ].forEach { $0.isActive = true }
        

        addSubview(eventTitleLabel)
        eventTitleLabel.leftAnchor.constraint(equalTo: eventImageView.rightAnchor, constant: 10).isActive = true
        eventTitleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        eventTitleLabel.topAnchor.constraint(equalTo: eventImageView.topAnchor).isActive = true

        addSubview(eventCategoryLabel)
        [
            eventCategoryLabel.leftAnchor.constraint(equalTo: eventTitleLabel.leftAnchor),
            eventCategoryLabel.topAnchor.constraint(equalTo: eventTitleLabel.bottomAnchor, constant: 5),
            ].forEach { $0.isActive = true }
        
        addSubview(favouriteIndicator)
        [
            favouriteIndicator.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
            favouriteIndicator.centerYAnchor.constraint(equalTo: eventCategoryLabel.centerYAnchor),
            favouriteIndicator.heightAnchor.constraint(equalToConstant: 18),
            ].forEach { $0.isActive = true }
        
        addSubview(eventOrganizerLabel)
        [
            eventOrganizerLabel.leftAnchor.constraint(equalTo: eventTitleLabel.leftAnchor),
            eventOrganizerLabel.rightAnchor.constraint(equalTo: eventTitleLabel.rightAnchor),
            eventOrganizerLabel.topAnchor.constraint(equalTo: eventCategoryLabel.bottomAnchor, constant: 5),
            eventOrganizerLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -20)
            ].forEach { $0.isActive = true }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
