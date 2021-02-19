//
//  PersistenceManager.swift
//  MemoryCard
//
//  Created by Zhanibek Sagintayev on 2021-01-23.
//

import Foundation
import CoreData

final class PersistenceManager {
    weak var cardObserver: CardObserver?
    
    private let container: NSPersistentContainer
    private let modelName = "Model"
    private let notificationCenter: NotificationCenter
    
    var viewContext: NSManagedObjectContext {
        container.viewContext
    }
    
    init(notificationCenter: NotificationCenter = .default) {
        self.notificationCenter = notificationCenter
        container = NSPersistentContainer(name: modelName)
        setupPersistentContainer()
        setupObservers()
    }
    
    private func delete(_ object: NSManagedObject) {
        viewContext.delete(object)
        saveContextOrRollbackIfFail(viewContext)
    }
    
    private func setupPersistentContainer() {
        container.loadPersistentStores { (description, error) in
            guard error == nil else { fatalError("Failed to load persistent stores") }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    private func setupObservers() {
        notificationCenter.addObserver(self, selector: #selector(contextDidSave), name: .NSManagedObjectContextDidSave, object: viewContext)
    }
    
    @objc
    private func contextDidSave(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        if let inserted = userInfo["inserted"] as? Set<Card> {
            inserted.forEach { cardObserver?.cardManager(self, didInsertCard: $0) }
        }
        if let updated = userInfo["updated"] as? Set<Card> {
            updated.forEach { cardObserver?.cardManager(self, didUpdateCard: $0) }
        }
        if let deleted = userInfo["deleted"] as? Set<Card> {
            deleted.forEach { cardObserver?.cardManager(self, didDeleteCard: $0) }
        }
    }
    
    private func saveContextOrRollbackIfFail(_ context: NSManagedObjectContext) {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch let error {
            context.rollback()
            print("Failed to save managed object context: \(error)")
        }
    }
    
    deinit {
        notificationCenter.removeObserver(self)
    }
}

// MARK: - Card Manager
extension PersistenceManager: CardManager {
    func saveCard(question: String, answer: String, in deck: Deck) {
        let card = Card(context: viewContext)
        card.question = question
        card.answer = answer
        card.creationDate = Date()
        card.testDate = Date()
        card.deck = deck
        saveContextOrRollbackIfFail(viewContext)
    }
    
    func updateCard(_ card: Card, question: String? = nil, answer: String? = nil, deck: Deck? = nil) {
        if let question = question {
            card.question = question
        }
        if let answer = answer {
            card.answer = answer
        }
        if let deck = deck {
            card.deck = deck
        }
        saveContextOrRollbackIfFail(viewContext)
    }
    
    func deleteCard(_ card: Card) {
        delete(card)
    }
    
    func getAllCards() throws -> [Card] {
        let request: NSFetchRequest<Card> = Card.fetchRequest()
        return try viewContext.fetch(request)
    }
}

// MARK: - Deck Manager
extension PersistenceManager: DeckManager {
    func saveDeck(named name: String) {
        let deck = Deck(context: viewContext)
        deck.name = name
        saveContextOrRollbackIfFail(viewContext)
    }
    
    func updateDeck(_ deck: Deck, name: String) {
        deck.name = name
        saveContextOrRollbackIfFail(viewContext)
    }
    
    func deleteDeck(_ deck: Deck) {
        delete(deck)
    }
    
    func getAllDecks() throws -> [Deck] {
        let request: NSFetchRequest<Deck> = Deck.fetchRequest()
        return try viewContext.fetch(request)
    }
    
    func getDeck(byName name: String) throws -> Deck {
        let request: NSFetchRequest<Deck> = Deck.fetchRequest()
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(Deck.name), name)
        return try viewContext.fetch(request)[0]
    }
        
    func getDecksToLearn() throws -> [Deck] {
        var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
        components.hour = 23
        components.minute = 59
        components.second = 59
        guard let date = Calendar.current.date(from: components) else { return [] }
        
        let request: NSFetchRequest<Deck> = Deck.fetchRequest()
        request.predicate = NSPredicate(format: "ANY %K <= %@", #keyPath(Deck.cards.testDate), date as NSDate)
        //request.sortDescriptors = [NSSortDescriptor(keyPath: \Deck.cards.testDate.count, ascending: false)]
        return try viewContext.fetch(request)
    }
}
