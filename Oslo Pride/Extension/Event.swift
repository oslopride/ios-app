//
//  Event.swift
//  Oslo Pride
//
//  Created by Adrian Evensen on 08/06/2019.
//  Copyright © 2019 Adrian Evensen. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

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
    
    func ageLimitString() -> String {
        switch self.ageLimit {
        case "0":   return "For Alle"
        case "99":  return "Annet"
        default:    return "\(self.ageLimit ?? "") år"
        }
    }
    
    func coordinates() -> CLLocationCoordinate2D? {
        switch self.category {
        case "0":
            return nil
        case "1":
            return MapCoordinates().prideParadeStart
        case "2":
            if venue == "Bamsescenen" {
                return MapCoordinates().bamseStage
            } else {
                return MapCoordinates().mainStage
            }
        case "3", "4":
            return MapCoordinates().prideHouseArt
        default:
            return nil
        }
    }
    
}
