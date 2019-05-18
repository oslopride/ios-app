//
//  FavouriteCell.swift
//  Oslo Pride
//
//  Created by Adrian Evensen on 17/05/2019.
//  Copyright © 2019 Adrian Evensen. All rights reserved.
//

import UIKit

protocol FavouriteCellDelegate {
    func presentDeleteConfirmation(_ event: Event)
    func presentDirections(_ event: Event)
}

class FavouriteCell: UICollectionViewCell {
    
    var event: Event! {
        didSet {
            setupUI()
        }
    }
    
    var delegate: FavouriteCellDelegate?
    
    let eventImageView: UIImageView = {
        let imv = UIImageView()
        imv.translatesAutoresizingMaskIntoConstraints = false
        imv.contentMode = .scaleAspectFill
        imv.tintColor = .graySuit
        imv.clipsToBounds = true
        
        return imv
    }()
    
    let eventTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .black)
        label.numberOfLines = 0
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        
        return label
    }()
    
    let countdownLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.numberOfLines = 2
        lbl.textAlignment = .center
        
        return lbl
    }()
    
    lazy var deleteButton: UIButton = {
        let butt = UIButton(type: .system)
        butt.setImage(UIImage(named: "delete"), for: .normal)
        butt.tintColor = UIColor.prideRed
        butt.addTarget(self, action: #selector(displayDeleteConfirmation), for: .touchUpInside)
        
        return butt
    }()
    
    lazy var directionsButton: UIButton = {
        let butt = UIButton(type: .system)
        butt.setImage(UIImage(named: "directions"), for: .normal)
        butt.tintColor = UIColor.prideBlue
        butt.addTarget(self, action: #selector(displayDirections), for: .touchUpInside)
        
        return butt
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    @objc fileprivate func displayDirections() {
        print("hai")
        delegate?.presentDirections(event)
    }
    
    @objc fileprivate func displayDeleteConfirmation() {
        delegate?.presentDeleteConfirmation(event)
    }
    
    fileprivate func setupLayout() {
        addSubview(eventImageView)
        [
            eventImageView.leftAnchor.constraint(equalTo: leftAnchor),
            eventImageView.topAnchor.constraint(equalTo: topAnchor),
            eventImageView.rightAnchor.constraint(equalTo: rightAnchor),
            eventImageView.heightAnchor.constraint(equalToConstant: (frame.width-14*2)*0.68)
            ].forEach { $0.isActive = true }
        
        addSubview(eventTitleLabel)
        [
            eventTitleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 14),
            eventTitleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -14),
            eventTitleLabel.topAnchor.constraint(equalTo: eventImageView.bottomAnchor, constant: 10)
            ].forEach { $0.isActive = true }
        
        addSubview(dateLabel)
        [
            dateLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 14),
            dateLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -14),
            dateLabel.topAnchor.constraint(equalTo: eventTitleLabel.bottomAnchor, constant: 10)
            ].forEach { $0.isActive = true }
        
        addSubview(countdownLabel)
        [
            countdownLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -14),
            countdownLabel.topAnchor.constraint(equalTo: dateLabel.topAnchor),
            countdownLabel.leftAnchor.constraint(equalTo: centerXAnchor)
            ].forEach { $0.isActive = true }
        
        let actionsStack = UIStackView(arrangedSubviews: [deleteButton, directionsButton])
        actionsStack.translatesAutoresizingMaskIntoConstraints = false
        actionsStack.distribution = .fillEqually
        addSubview(actionsStack)
        [
            actionsStack.leftAnchor.constraint(equalTo: leftAnchor, constant: 14),
            actionsStack.rightAnchor.constraint(equalTo: rightAnchor, constant: -14),
            actionsStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -14)
            ].forEach { $0.isActive = true }
        
    }
    
    
    fileprivate func setupUI() {
        if let imageData = event.image {
            eventImageView.image = UIImage(data: imageData)
        }
        eventTitleLabel.text = event.title
        
        guard let start = event?.startingTime, let end = event?.endingTime else { return }
        dateLabel.setupEventDateLabel(start: start, end: end)
        
        let countdown = Calendar.current.dateComponents([.day, .hour, .minute], from: Date(), to: start)
        let day = String(countdown.day ?? 0)
        let hours = String(countdown.hour ?? 0)
        let minutes = String(countdown.minute ?? 0)
        let attrString = NSMutableAttributedString()
        
        attrString.append(NSAttributedString(string: "<- Som Betyr Om\n", attributes: [
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16),
            NSAttributedString.Key.foregroundColor : UIColor.graySuit
            ]))
        
        if (countdown.day ?? 0) > 1 {
            attrString.append(NSAttributedString(string: "\(day) dager", attributes: [
                NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16),
                NSAttributedString.Key.foregroundColor : UIColor.kindaBlack
                ]))
        } else if (countdown.hour ?? 0) > 1 {
            attrString.append(NSAttributedString(string: "\(hours) timer", attributes: [
                NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16),
                NSAttributedString.Key.foregroundColor : UIColor.kindaBlack
                ]))
        } else {
            attrString.append(NSAttributedString(string: "\(minutes) minutter", attributes: [
                NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16),
                NSAttributedString.Key.foregroundColor : UIColor.kindaBlack
                ]))
        }


        countdownLabel.attributedText = attrString
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
