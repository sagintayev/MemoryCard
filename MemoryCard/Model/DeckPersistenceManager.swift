//
//  DeckPersistenceManager.swift
//  MemoryCard
//
//  Created by Zhanibek on 16.03.2021.
//

import Foundation
import CoreData

class DeckPersistenceManager {
    private let coreDataStack: CoreDataStack
    private let notificationCenter: NotificationCenter
    
    init(coreDataStack: CoreDataStack, notificationCenter: NotificationCenter) {
        self.coreDataStack = coreDataStack
        self.notificationCenter = notificationCenter
        setupObservers()
    }
    
    deinit {
        notificationCenter.removeObserver(self)
    }
    
    private func setupObservers() {
        notificationCenter.addObserver(self, selector: #selector(contextDidSave), name: .NSManagedObjectContextDidSave, object: nil)
    }
    
    @objc
    private func contextDidSave(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        
        for (userInfoKey, action) in [("inserted", Action.create), ("updated", Action.update), ("deleted", Action.delete)]{
            (userInfo[userInfoKey] as? Set<Deck>)?.forEach {
                notificationCenter.post(name: .DeckDidChange, object: self, userInfo: ["deck": $0, "action": action])
            }
        }
    }
}

extension DeckPersistenceManager {
    @discardableResult
    func saveDeck(named name: String) throws -> Deck {
        let deck = Deck(context: coreDataStack.viewContext)
        deck.name = name
        try coreDataStack.viewContext.save()
        return deck
    }
    
    func updateDeck(_ deck: Deck, name: String) throws {
        deck.name = name
        try coreDataStack.viewContext.save()
    }
    
    func deleteDeck(_ deck: Deck) {
        coreDataStack.viewContext.delete(deck)
    }
    
    func getAllDecks() throws -> [Deck] {
        let request: NSFetchRequest<Deck> = Deck.fetchRequest()
        return try coreDataStack.viewContext.fetch(request)
    }
    
    func getDeck(byName name: String) throws -> Deck? {
        let request: NSFetchRequest<Deck> = Deck.fetchRequest()
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(Deck.name), name)
        return try coreDataStack.viewContext.fetch(request).first
    }
        
    func getDecksToLearn() throws -> [Deck] {
        guard let date = getTodayLastMoment() else { return [] }
        let request: NSFetchRequest<Deck> = Deck.fetchRequest()
        request.predicate = NSPredicate(format: "ANY %K <= %@", #keyPath(Deck.cards.testDate), date as NSDate)
        return try coreDataStack.viewContext.fetch(request)
    }
    
    func getCardsToLearn(from deck: Deck) throws -> [Card] {
        guard let date = getTodayLastMoment() else { return [] }
        let request: NSFetchRequest<Card> = Card.fetchRequest()
        request.predicate = NSPredicate(format: "%K == %@ AND %K <= %@", #keyPath(Card.deck.name), deck.name, #keyPath(Card.testDate), date as NSDate)
        return try coreDataStack.viewContext.fetch(request)
    }
    
    private func getTodayLastMoment() -> Date? {
        var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
        components.hour = 23
        components.minute = 59
        components.second = 59
        return Calendar.current.date(from: components)
    }
}
