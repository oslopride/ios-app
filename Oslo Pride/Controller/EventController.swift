//
//  EventController.swift
//  Oslo Pride
//
//  Created by Adrian Evensen on 12/05/2019.
//  Copyright © 2019 Adrian Evensen. All rights reserved.
//

import UIKit
import WebKit

class EventController: UIViewController {
    
    var event: Event? {
        didSet {
            setupUI()
        }
    }
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = event?.title
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        view.addSubview(scrollView)
        [
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ].forEach { $0.isActive = true }
        
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        //imageView.layer.cornerRadius = 15
        imageView.clipsToBounds = true
        if let imageData = event?.image {
            imageView.image = UIImage(data: imageData)
        }
        
//        scrollView.addSubview(imageView)
//        [
//            imageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
//            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10),
//            imageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24),
//            //imageView.heightAnchor.constraint(equalToConstant: (view.frame.width-24*2)*0.618033989)
//            imageView.heightAnchor.constraint(equalToConstant: view.frame.width-24*2)
//            //imageView.heightAnchor.constraint(equalToConstant: 50),
//            //imageView.widthAnchor.constraint(equalToConstant: 50)
//            ].forEach { $0.isActive = true }
        
        
        scrollView.addSubview(imageView)
        [
            imageView.leftAnchor.constraint(equalTo: view.leftAnchor),
            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0),
            imageView.rightAnchor.constraint(equalTo: view.rightAnchor),
            //imageView.heightAnchor.constraint(equalToConstant: (view.frame.width-24*2)*0.618033989)
            imageView.heightAnchor.constraint(equalToConstant: view.frame.width*0.618033989)
            //imageView.heightAnchor.constraint(equalToConstant: 50),
            //imageView.widthAnchor.constraint(equalToConstant: 50)
            ].forEach { $0.isActive = true }
        
        
        let stackView = createStackView()
        scrollView.addSubview(stackView)
        [
            stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            stackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 24),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: scrollView.bottomAnchor, constant: -24)
            //stackView.heightAnchor.constraint(equalToConstant: 1000)
            ].forEach { $0.isActive = true }
        
        let dateLabel = UILabel()
        dateLabel.numberOfLines = 0
        
        guard let start = event?.startingTime, let end = event?.endingTime else { return }
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "no_BM_POSIX")
        formatter.dateFormat = "EEEE dd MMMM"
        let dayString = formatter.string(from: start)
        formatter.dateFormat = "HH:mm"
        let startTime = formatter.string(from: start)
        let endTime = formatter.string(from: end)
        
        
        let attrText = NSMutableAttributedString()
        attrText.append(NSAttributedString(string: (dayString.first?.uppercased() ?? "") + dayString.dropFirst().lowercased() + "\n", attributes: [
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16),
            NSAttributedString.Key.foregroundColor : UIColor.graySuit
            ]))
        attrText.append(NSAttributedString(string: "\(startTime) - \(endTime)", attributes: [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16),
            NSAttributedString.Key.foregroundColor : UIColor.kindaBlack
            ]))
        dateLabel.attributedText = attrText
        
        stackView.addArrangedSubview(dateLabel)
        
        let toggleFavouriteButton = UIButton(type: .system)
        toggleFavouriteButton.setImage(UIImage(named: "star_twotone_large"), for: .normal)
        toggleFavouriteButton.translatesAutoresizingMaskIntoConstraints = false
        toggleFavouriteButton.addTarget(self, action: #selector(toggleFavourite), for: .touchUpInside)
        toggleFavouriteButton.tintColor = .pridePurple
        scrollView.addSubview(toggleFavouriteButton)
        [
            toggleFavouriteButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24),
            toggleFavouriteButton.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor),
            toggleFavouriteButton.heightAnchor.constraint(equalToConstant: 55),
            toggleFavouriteButton.widthAnchor.constraint(equalToConstant: 55)
            ].forEach { $0.isActive = true }
        
        let descriptionLabel = UILabel()
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = .darkGray
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.text = event?.eventDescription
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(descriptionLabel)
        [
            descriptionLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            descriptionLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24),
            descriptionLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10),
            descriptionLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -24)
            ].forEach { $0.isActive = true }
        
        
    }
    
    @objc fileprivate func toggleFavourite() {
        guard let event = event else { return }
        CoreDataManager.shared.toggleFavourite(event: event) { (err) in
            if let err = err {
                print("failed to save event")
                return
            }
            DispatchQueue.main.async {
                
            }
        }
    }
    
    fileprivate func createStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        
 
        
        return stackView
    }
    
    
    
    fileprivate func setupUI() {
        
    }
    
 
    
    
    
}
