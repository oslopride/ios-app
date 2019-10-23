//
//  TableViewHeaderLabel.swift
//  Oslo Pride
//
//  Created by Adrian Evensen on 19/05/2019.
//  Copyright © 2019 Adrian Evensen. All rights reserved.
//

import UIKit

class TableViewHeaderLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white //.primaryBlue
        textAlignment = .center
        //font = UIFont.monospacedDigitSystemFont(ofSize: 16, weight: UIFont.Weight.black)
        font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.black)
        
        textColor = .prideDeepPurple//.prideYellow//.graySuit//.white//.prideGreen
        backgroundColor = .white//.prideDeepPurple
        clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        let originalSize = super.intrinsicContentSize
        let height = originalSize.height + 10
        let width = originalSize.width + 16
        
        layer.cornerRadius = height/2.2
        
        return CGSize(width: width, height: height)
    }
}

