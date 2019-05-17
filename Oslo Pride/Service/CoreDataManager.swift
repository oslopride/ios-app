//
//  CoreDataManager.swift
//  Oslo Pride
//
//  Created by Adrian Evensen on 14/05/2019.
//  Copyright © 2019 Adrian Evensen. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    let pc: NSPersistentContainer = {
        let persistentContainer = NSPersistentContainer(name: "PrideDataModels")
        persistentContainer.loadPersistentStores(completionHandler: { (_, err) in
            if let err = err {
                fatalError("failed to load PrideDataModels")
            }
        })
        return persistentContainer
    }()
    
    // MARK:- Create
    func save(event: SanityEvent, completion: @escaping (Event?, Error?) -> ()) {
        guard let newEvent = NSEntityDescription.insertNewObject(forEntityName: "Event", into: pc.viewContext) as? Event else { return }
        //populate(event: newEvent, from: event)
        newEvent.id = event.id
        newEvent.title = event.title
        newEvent.organizer = event.organizer
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
        newEvent.contactPersonName = event.contactPerson?.name
        newEvent.contactPersonEmail = event.contactPerson?.epost
        
        do {
            try pc.viewContext.save()
            completion(newEvent, nil)
        } catch let err {
            completion(nil, err)
        }
    }
    
    fileprivate func populate(event: Event, from sanityEvent: SanityEvent) {
        event.id = sanityEvent.id
        event.title = sanityEvent.title
        event.organizer = sanityEvent.organizer
        event.eventDescription = sanityEvent.description
        event.startingTime = sanityEvent.startingTime
        event.endingTime = sanityEvent.endingTime
        event.ageLimit = sanityEvent.ageLimit
        event.locationName = sanityEvent.location?.name
        event.locationAddress = sanityEvent.location?.address
        event.contactPersonName = sanityEvent.contactPerson?.name
        event.contactPersonEmail = sanityEvent.contactPerson?.epost
        if let url = URL(string: sanityEvent.ticketSaleWebpage ?? "") {
            event.ticketSaleWebpage = url
        }
        if let url = URL(string: sanityEvent.imageURL ?? "") {
            event.imageURL = url
        }
    }
    
    // MARK:- Read
    func getAllEvents(completionHandler: @escaping ([Event]) -> ()) {
        let fetchRequest = NSFetchRequest<Event>(entityName: "Event")
        
        do {
            let allEvents = try pc.viewContext.fetch(fetchRequest)
            completionHandler(allEvents)
        } catch let err {
            print("Failed to fetch all events: ", err)
        }
    }
    
    // MARK:- Update
    func updateEventImage(_ event: Event, image: Data, completion: @escaping (Error?) -> ()) {
        event.image = image
        do {
            try pc.viewContext.save()
            completion(nil)
        } catch let err {
            completion(err)
        }
    }
    // ...
    
    
    
    // MARK:- Delete
    func delete(event: Event) {
        pc.viewContext.delete(event)
        let semaphore = DispatchSemaphore(value: 0)
        do {
            try pc.viewContext.save()
            semaphore.signal()
        } catch let err {
            print("failed to delete event: ", err)
            semaphore.signal()
        }
        semaphore.wait()
    }
    
    func delete(events: [Event]) {
        for i in 0..<events.count {
            delete(event: events[i])
        }
    }
    
}
