//
//  TestCoreDataStack.swift
//  MemoryCardTests
//
//  Created by Zhanibek on 15.03.2021.
//

import Foundation
import CoreData
@testable import MemoryCard

class TestCoreDataStack: CoreDataStack {
    override func configurePersistentContainer() {
        super.configurePersistentContainer()
        let description = NSPersistentStoreDescription(url: URL(fileURLWithPath: "/dev/null"))
        container.persistentStoreDescriptions = [description]
    }
}

