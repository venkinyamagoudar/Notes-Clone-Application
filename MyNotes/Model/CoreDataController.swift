//
//  CoreDataController.swift
//  MyNotes
//
//  Created by Venkatesh Nyamagoudar on 1/19/23.
//

import Foundation
import CoreData

/*
    1.hold a persistant container instance
    2.Load the persistant store
    3.access the managed object context
*/

class CoreDataController {
    let persistantContainer: NSPersistentContainer
    
    init(modelName: String) {
        self.persistantContainer = NSPersistentContainer(name: modelName)
    }
    
    var viewContext: NSManagedObjectContext {
        return persistantContainer.viewContext
    }
    
    //used to call persistant containers loadPersistant function
    func load(completion handler: (() -> Void)? = nil ) {
        persistantContainer.loadPersistentStores { description, error in
            guard error == nil else {
                fatalError("Persistant Container not loaded. Error: \(error)")
            }
        }
        handler?()
    }
}
