//
//  EventController.swift
//  Oslo Pride
//
//  Created by Adrian Evensen on 12/05/2019.
//  Copyright © 2019 Adrian Evensen. All rights reserved.
//

import UIKit
import WebKit
import SafariServices

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
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "trekanter")
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    let descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = .darkGray
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return descriptionLabel
    }()
    
    let toggleFavouriteButton: UIButton = {
        let toggleFavouriteButton = UIButton(type: .system)
        toggleFavouriteButton.setImage(UIImage(named: "star_twotone_large"), for: .normal)
        toggleFavouriteButton.translatesAutoresizingMaskIntoConstraints = false
        toggleFavouriteButton.addTarget(self, action: #selector(toggleFavourite), for: .touchUpInside)
        toggleFavouriteButton.tintColor = .prideGreen
        
        return toggleFavouriteButton
    }()
    
    let presentSalesWebpageButton: UIButton = {
        let webpageButton = UIButton(type: .system)
        webpageButton.setImage(UIImage(named: "store"), for: .normal)
        webpageButton.tintColor = .pridePurple
        webpageButton.addTarget(self, action: #selector(displaySalesWebpage), for: .touchUpInside)
        
        return webpageButton
    }()
    
    let actionsStackView : UIStackView = {
        let actionsStack = UIStackView()
        actionsStack.translatesAutoresizingMaskIntoConstraints = false
        actionsStack.distribution = .fillEqually
        
        return actionsStack
    }()
    
    let detailsStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = event?.title
        setupLayout()
    }
    
    fileprivate func setupUI() {
        guard let event = event else { return }
        
        // Display description
        descriptionLabel.text = event.eventDescription

        // Display Image if present
        if let imageData = event.image, let image = UIImage(data: imageData) {
            imageView.image = image
            imageView.contentMode = .scaleAspectFill
        }
        
        // Setup Actions Row
        if let _ = event.ticketSaleWebpage {
            actionsStackView.addArrangedSubview(presentSalesWebpageButton)
        } else {
            actionsStackView.addArrangedSubview(UIView())
        }
        actionsStackView.addArrangedSubview(toggleFavouriteButton)
        

        // Setup details stackview
        if let start = event.startingTime, let end = event.endingTime {
            let dateLabel = UILabel()
            dateLabel.numberOfLines = 0
            dateLabel.setupEventDateLabel(start: start, end: end)
            detailsStackView.addArrangedSubview(dateLabel)
        }
    
        
    }
    
    fileprivate func setupLayout() {
        view.addSubview(scrollView)
        [
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ].forEach { $0.isActive = true }

        scrollView.addSubview(imageView)
        [
            imageView.leftAnchor.constraint(equalTo: view.leftAnchor),
            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0),
            imageView.rightAnchor.constraint(equalTo: view.rightAnchor),
            imageView.heightAnchor.constraint(equalToConstant: view.frame.width*0.618033989)
            ].forEach { $0.isActive = true }
        
        
        scrollView.addSubview(detailsStackView)
        [
            detailsStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            detailsStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            detailsStackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 24),
            detailsStackView.bottomAnchor.constraint(lessThanOrEqualTo: scrollView.bottomAnchor, constant: -24)
            ].forEach { $0.isActive = true }

        scrollView.addSubview(actionsStackView)
        [
            actionsStackView.centerYAnchor.constraint(equalTo: detailsStackView.centerYAnchor),
            actionsStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            actionsStackView.heightAnchor.constraint(equalToConstant: 55),
            actionsStackView.leftAnchor.constraint(equalTo: view.centerXAnchor)
            ].forEach { $0.isActive = true }
        
        scrollView.addSubview(descriptionLabel)
        [
            descriptionLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            descriptionLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24),
            descriptionLabel.topAnchor.constraint(equalTo: detailsStackView.bottomAnchor, constant: 10),
            descriptionLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -24)
            ].forEach { $0.isActive = true }
        
    }

    
    @objc fileprivate func displaySalesWebpage() {
        guard let url = event?.ticketSaleWebpage else { return }
        let controller = SFSafariViewController(url: url)
        present(controller, animated: true, completion: nil)
    }
    
    @objc fileprivate func toggleFavourite() {
        guard let event = event else { return }
        CoreDataManager.shared.toggleFavourite(event: event) { (err) in
            if let err = err {
                print("failed to save event: ", err)
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
    
    
    
}
