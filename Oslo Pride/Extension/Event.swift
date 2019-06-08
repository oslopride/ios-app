//
//  Event.swift
//  Oslo Pride
//
//  Created by Adrian Evensen on 08/06/2019.
//  Copyright © 2019 Adrian Evensen. All rights reserved.
//

import Foundation
import UIKit

extension Event {
    
    func categoryName() -> NSAttributedString {
        switch self.category {
        case "0":
            return NSAttributedString(string: "Ekstern Arena", attributes: [
                NSAttributedString.Key.foregroundColor : UIColor.prideYellow
                ])
        case "1":
            return NSAttributedString(string: "Pride Parade", attributes: [
                NSAttributedString.Key.foregroundColor : UIColor.prideRed
                ])
        case "2":
            return NSAttributedString(string: "Pride Park", attributes: [
                NSAttributedString.Key.foregroundColor : UIColor.prideGreen
                ])
        case "3":
            return NSAttributedString(string: "Pride House", attributes: [
                NSAttributedString.Key.foregroundColor : UIColor.prideBlue
                ])
        case "4":
            return NSAttributedString(string: "Pride Art", attributes: [
                NSAttributedString.Key.foregroundColor : UIColor.pridePurple
                ])
        default:
            return NSAttributedString(string: "Annet", attributes: [
                NSAttributedString.Key.foregroundColor : UIColor.graySuit
                ])
        }
    }
    
}
