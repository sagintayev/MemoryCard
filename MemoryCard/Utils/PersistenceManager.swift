//
//  PersistenceManager.swift
//  MemoryCard
//
//  Created by Zhanibek Sagintayev on 2021-01-23.
//

import Foundation
import CoreData

class PersistenceManager {
    private let container: NSPersistentContainer
    private let modelName = "Model"
    lazy var defaultDeck: Deck = {
        let deck = Deck(context: container.viewContext)
        deck.name = "Default"
        return deck
    }()
    
    init() {
        container = NSPersistentContainer(name: modelName)
        container.loadPersistentStores { (description, error) in
            guard error == nil else { fatalError("Failed to load persistent stores") }
        }
    }
    
    func delete(_ object: NSManagedObject) {
        container.viewContext.delete(object)
        saveViewContextOrRollbackIfFail()
    }
    
    private func saveViewContextOrRollbackIfFail() {
        do {
            try container.viewContext.save()
        } catch let error {
            container.viewContext.rollback()
            print("Failed to save managed object context: \(error)")
        }
    }
}

// MARK: - Card handling
extension PersistenceManager {
    func saveCard(question: String, answer: String, in deck: Deck) {
        let card = Card(context: container.viewContext)
        card.question = question
        card.answer = answer
        card.creationDate = Date()
        card.testDate = Date()
        card.deck = deck
        saveViewContextOrRollbackIfFail()
    }
    
    func getAllCards() throws -> [Card] {
        let request: NSFetchRequest<Card> = Card.fetchRequest()
        return try container.viewContext.fetch(request)
    }
}

// MARK: - Deck handling
extension PersistenceManager {
    func saveDeck(named name: String) {
        let deck = Deck(context: container.viewContext)
        deck.name = name
        saveViewContextOrRollbackIfFail()
    }
    
    func getAllDecks() throws -> [Deck] {
        let request: NSFetchRequest<Deck> = Deck.fetchRequest()
        return try container.viewContext.fetch(request)
    }
}
