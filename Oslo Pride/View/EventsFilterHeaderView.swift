//
//  EventsFilterHeaderView.swift
//  Oslo Pride
//
//  Created by Adrian Evensen on 28/05/2019.
//  Copyright © 2019 Adrian Evensen. All rights reserved.
//

import UIKit

class FilterStackView: UIStackView {
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: frame.width + 20, height: frame.height + 20)

    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

protocol EventsFilterHeaderViewDelegte {
    func updateFilter(_ filter: Filter, remove: Bool)
}

class EventsFilterHeaderView: UIView {
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        //scrollView.backgroundColor = .prideBlue
        
        return scrollView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        scrollView.contentSize = CGSize(width: frame.width + 100, height: frame.height)
        setupLayout()
    }
    
    var delegate: EventsFilterHeaderViewDelegte?
    
    fileprivate func setupLayout() {
        addSubview(scrollView)
        [
         scrollView.leftAnchor.constraint(equalTo: leftAnchor),
         scrollView.rightAnchor.constraint(equalTo: rightAnchor),
         scrollView.topAnchor.constraint(equalTo: topAnchor),
         scrollView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ].forEach { $0.isActive = true }
        
        let stackView = FilterStackView()
        
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 10
        
        //stackView.distribution = .fillEqually
        
        scrollView.addSubview(stackView)
        [
            //stackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            stackView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            stackView.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            //stackView.heightAnchor.constraint(equalToConstant: 50)
            ].forEach { $0.isActive = true }
        
        
        [
          Filter(name: "Pride House", category: "3", color: .prideBlue),
          Filter(name: "Pride Park", category: "2", color: .prideGreen),
          Filter(name: "Pride Art", category: "4", color: .pridePurple),
          Filter(name: "Eksterne", category: "0", color: .prideYellow)
        ].forEach { (filter) in
            let butt = FilterButton(type: .system)
            butt.setTitle(" \(filter.name) ", for: .normal)
            
            butt.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)

            butt.addTarget(self, action: #selector(updateFilter), for: .touchUpInside)
            butt.filter = filter
            
            stackView.addArrangedSubview(butt)
        }
    }
    
    @objc fileprivate func updateFilter(sender: FilterButton) {
        print(sender.filter.name)
        sender.isActivated = !sender.isActivated
        delegate?.updateFilter(sender.filter, remove: !sender.isActivated)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

struct Filter {
    var name: String
    var category: String
    var color: UIColor
}

class FilterButton: UIButton {
    var filter: Filter! {
        didSet {
            backgroundColor = filter.color
        }
    }
    
    let bc = UIColor.prideGreen
    let tc = UIColor.white
    
    var isActivated = true {
        didSet {
            UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: .curveEaseInOut, animations: {
                if self.isActivated {
                    self.backgroundColor = self.filter.color //self.bc
                    self.tintColor = self.tc
                } else {
                    self.backgroundColor = self.tc
                    self.tintColor = .graySuit //self.bc
                }
            }, completion: nil)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        tintColor = .white
        layer.cornerRadius = 5
        clipsToBounds = true

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
