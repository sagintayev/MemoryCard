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
        setupObservers()
    }
    
    deinit {
        notificationCenter.removeObserver(self)
    }
    
    @objc
    private func contextDidSave(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        
        for (userInfoKey, action) in [("inserted", Action.create), ("updated", Action.update), ("deleted", Action.delete)]{
            (userInfo[userInfoKey] as? Set<Card>)?.forEach {
                notificationCenter.post(name: .CardDidChange, object: self, userInfo: ["card": $0, "action": action])
            }
        }
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
    }
    
    func answerCard(_ card: Card, withComplexity complexity: AnswerComplexity) throws {
        let multiplier = Int(max(card.correctAnswersChain, 1))
        let nextTestDate = Calendar.current.date(byAdding: .day, value: complexity.daysUntilNextCheck(multiplier: multiplier), to: card.testDate ) ?? Date()
        card.testDate = nextTestDate
        card.correctAnswersChain = (complexity == AnswerComplexity.impossible) ? 0 : +1
        try coreDataStack.viewContext.save()
    }
    
    func deleteCard(_ card: Card) {
        coreDataStack.viewContext.delete(card)
    }
    
    func getAllCards() throws -> [Card] {
        let request: NSFetchRequest<Card> = Card.fetchRequest()
        return try coreDataStack.viewContext.fetch(request)
    }
    
    private func setupObservers() {
        notificationCenter.addObserver(self, selector: #selector(contextDidSave), name: .NSManagedObjectContextDidSave, object: nil)
    }
}
