//
//  EventsManager.swift
//  Oslo Pride
//
//  Created by Adrian Evensen on 28/05/2019.
//  Copyright © 2019 Adrian Evensen. All rights reserved.
//

import Foundation
import UIKit

class EventsManager {
    static let shared = EventsManager()
    
    fileprivate var days: [[Event]]?
    fileprivate var downloadStack = [Event]()
    
    fileprivate var isDownloading = false
    
    func set(events: [Event]) {
        days = standardSortByDay(filtered: events)
        DispatchQueue.global(qos: .background).async {
            for event in events {
                if event.image == nil && event.imageURL != nil {
                    var exists = false
                    for i in self.downloadStack {
                        if i.id == event.id {
                            exists = true
                            break
                        }
                    }
                    
                    if !exists {
                        self.downloadStack.append(event)
                    }
                }
            }
            self.processDownloadStack()
        }
    }
    
    func get(day: Int, n: Int) -> Event? {
        return days?[day][n] ?? nil
    }
    
    func numberOfDays() -> Int {
        return days?.count ?? 0
    }
    
    func numberInDay(_ n: Int) -> Int {
        return days?[n].count ?? 0
    }
    
    fileprivate var categories = [String]()
    
    func addCategoryFilter(_ category: String, remove: Bool) {
        if remove {
            categories.append(category)
        } else {
            var newFilter = [String]()
            for f in categories {
                if f != category {
                    newFilter.append(f)
                }
            }
            categories = newFilter
        }
    }
    
    fileprivate func filterByCategory(days: [[Event]]) -> [[Event]] {
        var categoryFilter = [[Event]]()
        days.forEach({ (events) in
            var cache = [Event]()
            events.forEach({ (event) in
                for f in categories {
                    if event.category == f {
                        return
                    }
                }
                cache.append(event)
            })
            if cache.count > 0 {
                categoryFilter.append(cache)
            }
        })
        return categoryFilter
    }
    
    var shallFilterFromToday = true
    func toggleFilterFromToday() {
        shallFilterFromToday = !shallFilterFromToday
    }
    
    fileprivate func filterFromToday(days: [[Event]]) -> [[Event]] {
        guard shallFilterFromToday else {
            return days
        }
        var dateFilter = [[Event]]()
        let now = Date()
        days.forEach { (events) in
            var cache = [Event]()
            events.forEach({ (event) in
                if event.endingTime ?? Date() < now {
                    return
                }
                cache.append(event)

            })
            if cache.count > 0 {
                dateFilter.append(cache)
            }
        }
        return dateFilter
    }
    
    func get() -> [[Event]] {
        var newFilter = [[Event]]()
        guard let days = days else { return newFilter }
        
        newFilter = filterFromToday(days: days)
        newFilter = filterByCategory(days: newFilter)

        return newFilter
    }

    // Sorting alg in this function is a hack for Pride 2019.
    // It does not work if pride events overlaps month bondary
    // UPDATE: Not longer a hack, checks for months and year aswell
    func standardSortByDay(filtered: [Event]) -> [[Event]] {
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

extension EventsManager {
    
    func compare(local: [Event], remote: [SanityEvent]) -> [SanityEvent] {
        var unsyncedEvents = [SanityEvent]()
        remote.forEach { (remoteEvent) in
            var exists = false
            for i in 0..<local.count {
                guard let remoteID = remoteEvent.id, let localID = local[i].id else { continue }
                if remoteID == localID {
                    updateIfNecessary(local: local[i], remote: remoteEvent)
                    exists = true
                    break
                }
            }
            
            if !exists {
                unsyncedEvents.append(remoteEvent)
            }
        }
        
        if !isDownloading {
            DispatchQueue.global(qos: .background).async {
                self.processDownloadStack()
            }
        }

        return unsyncedEvents
    }
    
    fileprivate func processDownloadStack() {
        print("starting..")
        guard self.downloadStack.count > 0 && !isDownloading else { return }
        isDownloading = true
        for i in (0..<downloadStack.count).reversed() {
            let event = downloadStack.remove(at: i)
            guard let imageURL = event.imageURL else { continue }
            let semaphore = DispatchSemaphore(value: 0)
            
            NetworkAPI.shared.fetchImage(from: imageURL, completion: { (imageData) in
                guard let imageData = imageData, let img = UIImage(data: imageData)?.jpegData(compressionQuality: 0.3) else {
                    print("failed to download image")
                    semaphore.signal()
                    return
                }
                DispatchQueue.main.async {
                    CoreDataManager.shared.updateEventImage(event, image: img, completion: { (err) in
                        if let err = err {
                            print("failed to save image: ", err)
                        }
                        NotificationCenter.default.post(name: .imageDownloadeddd, object: img, userInfo: ["id":event.id as Any])
                        semaphore.signal()
                        print("did download image for event: ", event.title ?? "")
                        
                        print("Number: \(i) of \(self.downloadStack.count)")
                    })
                }
            })
            semaphore.wait()
        }
        print("Done")
        isDownloading = false
        self.downloadStack = [Event]()
    }
    
    fileprivate func updateIfNecessary(local: Event, remote: SanityEvent) {
        if (local.image == nil && local.imageURL != nil) || (local.imageURL?.absoluteString != remote.imageURL) {
            
            var exists = false
            for i in downloadStack {
                if i.id == local.id {
                    exists = true
                    break
                }
            }
            
            if !exists {
                downloadStack.append(local)
            }
            
        }
        DispatchQueue.main.async {
            CoreDataManager.shared.update(local: local, remote: remote, completion: { err in
                if let err = err {
                    print("failed to update event: ", err)
                }
            })
        }
    }
}
