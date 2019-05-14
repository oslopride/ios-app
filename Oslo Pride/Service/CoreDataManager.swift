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
    
    func save(event: SanityEvent, completion: @escaping (Event) -> ()) {
        guard let newEvent = NSEntityDescription.insertNewObject(forEntityName: "Event", into: pc.viewContext) as? Event else { return }
        
        newEvent.title = event.title
        newEvent.organizer = event.organizer
        //newEvent.eventDescription = event.description
        
    }
    
    
}
