//
//  CoreDataManager.swift
//  Oslo Pride
//
//  Created by Adrian Evensen on 14/05/2019.
//  Copyright © 2019 Adrian Evensen. All rights reserved.
//

import CoreData
import Foundation

class CoreDataManager {
    static let shared = CoreDataManager()
    
    let pc: NSPersistentContainer = {
        let persistentContainer = NSPersistentContainer(name: "PrideDataModels")
        persistentContainer.loadPersistentStores(completionHandler: { _, err in
            if let err = err {
                fatalError("failed to load PrideDataModels")
            }
        })
        return persistentContainer
    }()
    
    // MARK: - Create
    
    func save(events: [SanityEvent], completion: @escaping ([Event]?, Error?) -> ()) {
        pc.performBackgroundTask { backgroundContext in
            var newEvents = [Event]()
            events.forEach { event in
                guard let newEvent = NSEntityDescription.insertNewObject(forEntityName: "Event", into: backgroundContext) as? Event else { return }
                // self.populate(event: &newEvent, from: event)
                newEvent.id = event.id
                newEvent.title = event.title
                newEvent.organizer = event.organizer
                newEvent.category = event.category
                newEvent.deafInterpretation = event.deafInterpretation ?? false
                newEvent.accessible = event.accessible ?? false
                newEvent.eventDescription = event.description
                newEvent.startingTime = event.startingTime
                newEvent.endingTime = event.endingTime
                if let url = URL(string: event.ticketSaleWebpage ?? "") {
                    newEvent.ticketSaleWebpage = url
                }
                if let url = URL(string: event.imageURL ?? "") {
                    newEvent.imageURL = url
                }
                newEvent.ageLimit = event.ageLimit
                newEvent.locationName = event.location?.name
                newEvent.locationAddress = event.location?.address
                newEvent.venue = event.venue
                newEvent.contactPersonName = event.contactPerson?.name
                newEvent.contactPersonEmail = event.contactPerson?.epost
                newEvent.free = event.free ?? false
                
                newEvents.append(newEvent)
            }
            
            do {
                try backgroundContext.save()
                completion(newEvents, nil)
            } catch let err {
                completion(nil, err)
            }
        }
    }
    
//    func save(event: SanityEvent, completion: @escaping (Event?, Error?) -> ()) {
//        pc.performBackgroundTask { (backgroundContext) in
//            guard let newEvent = NSEntityDescription.insertNewObject(forEntityName: "Event", into: backgroundContext) as? Event else { return }
//            newEvent.id = event.id
//            newEvent.title = event.title
//            newEvent.organizer = event.organizer
//            newEvent.eventDescription = event.description
//            newEvent.startingTime = event.startingTime
//            newEvent.endingTime = event.endingTime
//            if let url = URL(string: event.ticketSaleWebpage ?? "") {
//                newEvent.ticketSaleWebpage = url
//            }
//            if let url = URL(string: event.imageURL ?? "") {
//                newEvent.imageURL = url
//            }
//            newEvent.ageLimit = event.ageLimit
//            newEvent.locationName = event.location?.name
//            newEvent.locationAddress = event.location?.address
//            newEvent.venue = event.location?.venue
//            newEvent.contactPersonName = event.contactPerson?.name
//            newEvent.contactPersonEmail = event.contactPerson?.epost
//
//            do {
//                try backgroundContext.save()
//                completion(newEvent, nil)
//            } catch let err {
//                completion(nil, err)
//            }
//        }
//
//    }
    
    func update(local: Event, remote: SanityEvent, completion: @escaping (Error?) -> ()) {
        // pc.performBackgroundTask { (backgroundContext) in
        local.id = remote.id
        local.title = remote.title
        local.organizer = remote.organizer
        local.category = remote.category
        local.eventDescription = remote.description
        local.startingTime = remote.startingTime
        local.endingTime = remote.endingTime
        if let url = URL(string: remote.ticketSaleWebpage ?? "") {
            local.ticketSaleWebpage = url
        }
        if let url = URL(string: remote.imageURL ?? "") {
            local.imageURL = url
        }
        local.ageLimit = remote.ageLimit
        local.locationName = remote.location?.name
        local.locationAddress = remote.location?.address
        local.venue = remote.venue
        local.contactPersonName = remote.contactPerson?.name
        local.contactPersonEmail = remote.contactPerson?.epost
        local.free = remote.free ?? false
        do {
            if pc.viewContext.hasChanges {
                try pc.viewContext.save()
            }
            completion(nil)
        } catch let err {
            print("failed to update event: ", err)
            completion(err)
        }
        // }
    }
    
    // TODO: Why doesn't this work?
    fileprivate func populate(event: UnsafeMutablePointer<Event>, from sanityEvent: SanityEvent) {
        guard event.pointee.id != nil else { return }
        event.pointee.id = sanityEvent.id
        event.pointee.title = sanityEvent.title
        event.pointee.organizer = sanityEvent.organizer
        event.pointee.eventDescription = sanityEvent.description
        event.pointee.startingTime = sanityEvent.startingTime
        event.pointee.endingTime = sanityEvent.endingTime
        event.pointee.ageLimit = sanityEvent.ageLimit
        event.pointee.locationName = sanityEvent.location?.name
        event.pointee.locationAddress = sanityEvent.location?.address
        event.pointee.contactPersonName = sanityEvent.contactPerson?.name
        event.pointee.contactPersonEmail = sanityEvent.contactPerson?.epost
        if let url = URL(string: sanityEvent.ticketSaleWebpage ?? "") {
            event.pointee.ticketSaleWebpage = url
        }
        if let url = URL(string: sanityEvent.imageURL ?? "") {
            event.pointee.imageURL = url
        }
    }
    
    // MARK: - Read
    
    func getAllEvents(completionHandler: @escaping ([Event]) -> ()) {
        let fetchRequest = NSFetchRequest<Event>(entityName: "Event")
        do {
            let allEvents = try pc.viewContext.fetch(fetchRequest)
            completionHandler(allEvents)
        } catch let err {
            print("Failed to fetch all events: ", err)
        }
    }
    
    func getFavourites(completion: @escaping ([Event]) -> ()) {
        let fetchRequest = NSFetchRequest<Event>(entityName: "Event")
        fetchRequest.predicate = NSPredicate(format: "(endingTime >= %@) AND isFavourite = true", Date() as CVarArg)
        do {
            let favourites = try pc.viewContext.fetch(fetchRequest)
            completion(favourites)
        } catch let err {
            print("Failed to fetch favourites: ", err)
        }
    }
    
    // MARK: - Update
    
    func updateEventImage(_ event: Event, image: Data, completion: @escaping (Error?) -> ()) {
        event.image = image
        do {
            if !pc.viewContext.hasChanges {
                print("No changes to save")
            }
            try pc.viewContext.save()
            completion(nil)
        } catch let err {
            completion(err)
        }
    }
    
    func toggleFavourite(event: Event, completion: @escaping (Error?) -> ()) {
        event.isFavourite = !event.isFavourite
        do {
            try pc.viewContext.save()
            completion(nil)
        } catch let err {
            completion(err)
        }
    }
    
    func updateCoordinates(event: Event, lat: Double, long: Double, completion: @escaping (Error?) -> ()) {
        event.latitude = lat
        event.longitude = long
        do {
            try pc.viewContext.save()
            completion(nil)
        } catch let err {
            completion(err)
        }
    }
    
    // MARK: - Delete
    
    func delete(events: [Event], completion: @escaping (Error?) -> ()) {
        events.forEach { event in
            pc.viewContext.delete(event)
        }
        do {
            try pc.viewContext.save()
            completion(nil)
        } catch let err {
            completion(err)
        }
    }
}
