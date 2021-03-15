//
//  CoreDataManager.swift
//  MemoryCard
//
//  Created by Zhanibek on 15.03.2021.
//

import Foundation
import CoreData

class CoreDataStack {
    private let container: NSPersistentContainer
    private let modelName = "Model"
    
    var viewContext: NSManagedObjectContext {
        container.viewContext
    }
    
    init() {
        container = NSPersistentContainer(name: modelName)
        setupPersistentContainer()
    }
    
    private func setupPersistentContainer() {
        container.loadPersistentStores { (description, error) in
            guard error == nil else { fatalError("Failed to load persistent stores") }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
