//
//  Deck+CoreDataProperties.swift
//  MemoryCard
//
//  Created by Zhanibek on 03.03.2021.
//
//

import Foundation
import CoreData


extension Deck {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Deck> {
        return NSFetchRequest<Deck>(entityName: "Deck")
    }

    @NSManaged public var name: String
    @NSManaged public var cards: Set<Card>

}

// MARK: Generated accessors for cards
extension Deck {

    @objc(addCardsObject:)
    @NSManaged public func addToCards(_ value: Card)

    @objc(removeCardsObject:)
    @NSManaged public func removeFromCards(_ value: Card)

    @objc(addCards:)
    @NSManaged public func addToCards(_ values: Set<Card>)

    @objc(removeCards:)
    @NSManaged public func removeFromCards(_ values: Set<Card>)

}

extension Deck : Identifiable {

}
