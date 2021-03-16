//
//  CoreDataManager.swift
//  MemoryCard
//
//  Created by Zhanibek on 15.03.2021.
//

import Foundation
import CoreData

class CoreDataStack {
    let container: NSPersistentContainer
    let modelName = "Model"
    
    var viewContext: NSManagedObjectContext {
        container.viewContext
    }
    
    init() {
        container = NSPersistentContainer(name: modelName)
        configurePersistentContainer()
        container.loadPersistentStores { (description, error) in
            guard error == nil else { fatalError("Failed to load persistent stores") }
        }
    }
    
    func configurePersistentContainer() {
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
