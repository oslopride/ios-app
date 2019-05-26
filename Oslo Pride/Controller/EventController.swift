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

        scrollView.addSubview(imageView)
        [
            imageView.leftAnchor.constraint(equalTo: view.leftAnchor),
            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0),
            imageView.rightAnchor.constraint(equalTo: view.rightAnchor),
            imageView.heightAnchor.constraint(equalToConstant: view.frame.width*0.618033989)
            ].forEach { $0.isActive = true }
        
        
        let stackView = createStackView()
        scrollView.addSubview(stackView)
        [
            stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            stackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 24),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: scrollView.bottomAnchor, constant: -24)
            ].forEach { $0.isActive = true }
        
        let dateLabel = UILabel()
        dateLabel.numberOfLines = 0
        
        guard let start = event?.startingTime, let end = event?.endingTime else { return }
        dateLabel.setupEventDateLabel(start: start, end: end)
        stackView.addArrangedSubview(dateLabel)
        
        let toggleFavouriteButton = UIButton(type: .system)
        toggleFavouriteButton.setImage(UIImage(named: "star_twotone_large"), for: .normal)
        toggleFavouriteButton.translatesAutoresizingMaskIntoConstraints = false
        toggleFavouriteButton.addTarget(self, action: #selector(toggleFavourite), for: .touchUpInside)
        toggleFavouriteButton.tintColor = .prideGreen//.prideYellow//.pridePurple
        
        let actionsStack = UIStackView()
        actionsStack.translatesAutoresizingMaskIntoConstraints = false
        actionsStack.distribution = .fillEqually
        if let saleURL = event?.ticketSaleWebpage {
            let webpageButton = UIButton(type: .system)
            webpageButton.setImage(UIImage(named: "store"), for: .normal)
            //("Billetter", for: .normal)
            webpageButton.tintColor = .pridePurple
            webpageButton.addTarget(self, action: #selector(displaySalesWebpage), for: .touchUpInside)
            actionsStack.addArrangedSubview(webpageButton)
        } else {
            actionsStack.addArrangedSubview(UIView())
        }
        
        actionsStack.addArrangedSubview(toggleFavouriteButton)
        scrollView.addSubview(actionsStack)
        [
            actionsStack.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor),
            actionsStack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            actionsStack.heightAnchor.constraint(equalToConstant: 55),
            actionsStack.leftAnchor.constraint(equalTo: view.centerXAnchor)
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
    
    
    
    fileprivate func setupUI() {
        
    }
    
 
    
    
    
}
