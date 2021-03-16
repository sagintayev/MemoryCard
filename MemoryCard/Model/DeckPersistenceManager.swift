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
    }
    
    private func postNotification(with deck: Deck, and action: Action) {
        let userInfo: [AnyHashable: Any] = ["deck": deck, "action": action]
        notificationCenter.post(name: .DeckDidChange, object: self, userInfo: userInfo)
    }
}

extension DeckPersistenceManager {
    @discardableResult
    func saveDeck(named name: String) throws -> Deck {
        let deck = Deck(context: coreDataStack.viewContext)
        deck.name = name
        try coreDataStack.viewContext.save()
        postNotification(with: deck, and: .create)
        return deck
    }
    
    func updateDeck(_ deck: Deck, name: String) throws {
        deck.name = name
        try coreDataStack.viewContext.save()
        postNotification(with: deck, and: .update)
    }
    
    func deleteDeck(_ deck: Deck) {
        coreDataStack.viewContext.delete(deck)
        postNotification(with: deck, and: .delete)
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
