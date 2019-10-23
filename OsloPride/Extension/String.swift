//
//  String.swift
//  Oslo Pride
//
//  Created by Adrian Evensen on 18/05/2019.
//  Copyright © 2019 Adrian Evensen. All rights reserved.
//

import UIKit

extension UILabel {
    func setupEventDateLabel(start: Date, end: Date) {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "no_BM_POSIX")
        formatter.dateFormat = "EEEE dd MMMM"
        let dayString = formatter.string(from: start)
        formatter.dateFormat = "HH:mm"
        let startTime = formatter.string(from: start)
        let endTime = formatter.string(from: end)
        
        let attrText = NSMutableAttributedString()
        attrText.append(NSAttributedString(string: (dayString.first?.uppercased() ?? "") + dayString.dropFirst().lowercased() + "\n", attributes: [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16),
            NSAttributedString.Key.foregroundColor: UIColor.graySuit
        ]))
        attrText.append(NSAttributedString(string: "\(startTime) - \(endTime)", attributes: [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16),
            NSAttributedString.Key.foregroundColor: UIColor.kindaBlack
        ]))
        attributedText = attrText
    }
}
