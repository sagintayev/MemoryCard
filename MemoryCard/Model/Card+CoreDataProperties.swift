//
//  Card+CoreDataProperties.swift
//  MemoryCard
//
//  Created by Zhanibek on 03.03.2021.
//
//

import Foundation
import CoreData


extension Card {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Card> {
        return NSFetchRequest<Card>(entityName: "Card")
    }

    @NSManaged public var answer: String
    @NSManaged public var correctAnswersChain: Int
    @NSManaged public var creationDate: Date
    @NSManaged public var question: String
    @NSManaged public var testDate: Date
    @NSManaged public var deck: Deck

}

extension Card : Identifiable {

}
