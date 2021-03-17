//
//  CardPersistenceManager.swift
//  MemoryCard
//
//  Created by Zhanibek on 15.03.2021.
//

import Foundation
import CoreData

class CardPersistenceManager {
    private let coreDataStack: CoreDataStack
    private let notificationCenter: NotificationCenter
    
    init(coreDataStack: CoreDataStack, notificationCenter: NotificationCenter) {
        self.coreDataStack = coreDataStack
        self.notificationCenter = notificationCenter
    }
    
    private func postCardNotification(with card: Card, and action: Action) {
        let userInfo: [AnyHashable: Any] = ["card": card, "action": action]
        notificationCenter.post(name: .CardDidChange, object: self, userInfo: userInfo)
    }
    
    private func postDeckNotification(with card: Card) {
        let userInfo: [AnyHashable: Any] = ["deck": card.deck, "action": Action.update]
        notificationCenter.post(name: .DeckDidChange, object: self, userInfo: userInfo)
    }
}

extension CardPersistenceManager {
    @discardableResult
    func saveCard(question: String, answer: String, in deck: Deck) throws -> Card {
        let card = Card(context: coreDataStack.viewContext)
        card.question = question
        card.answer = answer
        card.creationDate = Date()
        card.testDate = Date()
        card.deck = deck
        try coreDataStack.viewContext.save()
        postDeckNotification(with: card)
        postCardNotification(with: card, and: .create)
        return card
    }
    
    func updateCard(_ card: Card, question: String? = nil, answer: String? = nil, deck: Deck? = nil) throws {
        if let question = question {
            card.question = question
        }
        if let answer = answer {
            card.answer = answer
        }
        if let deck = deck {
            card.deck = deck
        }
        try coreDataStack.viewContext.save()
        postCardNotification(with: card, and: .update)
    }
    
    func answerCard(_ card: Card, withComplexity complexity: AnswerComplexity) throws {
        let multiplier = Int(max(card.correctAnswersChain, 1))
        let nextTestDate = Calendar.current.date(byAdding: .day, value: complexity.daysUntilNextCheck(multiplier: multiplier), to: card.testDate ) ?? Date()
        card.testDate = nextTestDate
        if complexity == .impossible {
            card.correctAnswersChain = 0
        } else {
            card.correctAnswersChain += 1
        }
        try coreDataStack.viewContext.save()
    }
    
    func deleteCard(_ card: Card) {
        coreDataStack.viewContext.delete(card)
        postCardNotification(with: card, and: .delete)
    }
    
    func getAllCards() throws -> [Card] {
        let request: NSFetchRequest<Card> = Card.fetchRequest()
        return try coreDataStack.viewContext.fetch(request)
    }
}
