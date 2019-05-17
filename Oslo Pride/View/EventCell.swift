//
//  EventCell.swift
//  Oslo Pride
//
//  Created by Adrian Evensen on 12/05/2019.
//  Copyright © 2019 Adrian Evensen. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell {
    
    var event: Event? {
        didSet {
            setupUI()
        }
    }
    
    let eventImageView: UIImageView = {
        let imv = UIImageView()
        imv.translatesAutoresizingMaskIntoConstraints = false
        imv.contentMode = .scaleAspectFill
        imv.clipsToBounds = true
        imv.layer.cornerRadius = 5
        
        return imv
    }()
    
    let eventTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 18)
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        addSubview(eventImageView)
        [
            eventImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            eventImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            eventImageView.widthAnchor.constraint(equalToConstant: 100),
            eventImageView.heightAnchor.constraint(equalToConstant: 100),
            eventImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
            ].forEach { $0.isActive = true }
        

        addSubview(eventTitleLabel)
        eventTitleLabel.leftAnchor.constraint(equalTo: eventImageView.rightAnchor, constant: 10).isActive = true
        eventTitleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        eventTitleLabel.topAnchor.constraint(equalTo: eventImageView.topAnchor).isActive = true
        
        addSubview(eventOrganizerLabel)
        [
            eventOrganizerLabel.leftAnchor.constraint(equalTo: eventTitleLabel.leftAnchor),
            eventOrganizerLabel.rightAnchor.constraint(equalTo: eventTitleLabel.rightAnchor),
            eventOrganizerLabel.topAnchor.constraint(equalTo: eventTitleLabel.bottomAnchor, constant: 5)
            ].forEach { $0.isActive = true }
    }
    
    fileprivate func setupUI() {
        eventTitleLabel.text = event?.title ?? ""
        eventOrganizerLabel.text = event?.organizer ?? ""
        if event?.imageURL == nil {
            eventImageView.image = nil
        }
        
        if let image = event?.image {
            eventImageView.image = UIImage(data: image, scale: 0.5)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
