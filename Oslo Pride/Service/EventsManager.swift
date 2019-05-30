//
//  EventsManager.swift
//  Oslo Pride
//
//  Created by Adrian Evensen on 28/05/2019.
//  Copyright © 2019 Adrian Evensen. All rights reserved.
//

import Foundation

class EventsManager {
    static let shared = EventsManager()
    
    //fileprivate var raw: [Event]?
    
    fileprivate var days: [[Event]]?
    
    func set(events: [Event]) {
        days = standardSortByDay(filtered: events)
    }
    
    func get(day: Int, n: Int) -> Event? {
        return days?[day][n] ?? nil
    }
    
    var numberOfDays: Int {
        get {
            return days?.count ?? 0
        }
    }
    
    func numberInDay(_ n: Int) -> Int {
        return days?[n].count ?? 0
    }
    
    func filter(types: [String]) {
        
    }

    // Sorting alg in this function is a hack for Pride 2019.
    // It does not work if pride events overlaps month bondary
    // UPDATE: Not longer a hack, checks for months and year aswell
    fileprivate func standardSortByDay(filtered: [Event]) -> [[Event]] {
        // Step 1: Sort events by time & date (descending).
        var filtered = filtered
        filtered.sort { (e1, e2) -> Bool in
            guard let e1ST = e1.startingTime, let e2ST = e2.startingTime else { return false }
            return e1ST < e2ST
        }
        
        // Step 2: Split sorted array into double array by day.
        var days = [[Event]]()
        for i in 0..<filtered.count {
            if days.count == 0 {
                days.append([filtered[0]])
                continue
            }
            
            if let last = days.last?.last?.startingTime, let current = filtered[i].startingTime {
                let lastDay = Calendar.current.component(.day, from: last)
                let currentDay = Calendar.current.component(.day, from: current)
                
                let lastMonth = Calendar.current.component(.month, from: last)
                let currentMonth = Calendar.current.component(.month, from: current)
                
                let lastYear = Calendar.current.component(.year, from: last)
                let currentYear = Calendar.current.component(.year, from: current)
                
                if currentDay > lastDay || currentMonth > lastMonth || currentYear > lastYear {
                    days.append([filtered[i]])
                } else {
                    days[days.count-1].append(filtered[i])
                }
            }
        }
        return days
    }
    
    
    
    
    
}
