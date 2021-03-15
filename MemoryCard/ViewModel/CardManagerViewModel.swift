//
//  CardManagerViewModel.swift
//  MemoryCard
//
//  Created by Zhanibek on 15.02.2021.
//

import Foundation

/// The ViewModel is used to create/update/delete a Card and if possible to present the Card data. Changes is persisted to Core Data Store.
final class CardManagerViewModel {
    private let deckManager: DeckPersistenceManager
    private let cardManager: CardPersistenceManager
    private var model: Card?
    private var cardViewModel: CardViewModel?
    private let notificationCenter: NotificationCenter
    
    var question: Observable<String>? {
        cardViewModel?.question
    }
    var answer: Observable<String>? {
        cardViewModel?.answer
    }
    var deck: Observable<String>? {
        cardViewModel?.deck
    }
    var allDecks = Observable([""])
    var buttonText = Observable("")
    
    init(model: Card? = nil, deckManager: DeckPersistenceManager, cardManager: CardPersistenceManager, notificationCenter: NotificationCenter) {
        self.cardManager = cardManager
        self.deckManager = deckManager
        self.notificationCenter = notificationCenter
        self.cardViewModel = CardViewModel(cardManager: cardManager, model: nil, notificationCenter: notificationCenter)

        setModel(model)
        
        if let decks = try? deckManager.getAllDecks() {
            allDecks = Observable(decks.compactMap { $0.name })
        }
    }
    
    deinit {
        notificationCenter.removeObserver(self)
    }
    
    func saveCard(question: String, answer: String, deckName: String) {
        if let model = model {
            let deck = try? deckManager.getDeck(byName: deckName)
            try? cardManager.updateCard(model, question: question, answer: answer, deck: deck)
        } else {
            guard let deck = try? deckManager.getDeck(byName: deckName) else { return }
            try? cardManager.saveCard(question: question, answer: answer, in: deck)
        }
        setModel(model)
    }
    
    func setModel(_ model: Card?) {
        cardViewModel?.setModel(model)
        buttonText.value = model == nil ? "Create" : "Update"
    }
    
    private func setObservers() {
        notificationCenter.addObserver(self, selector: #selector(deckNotificationRecieved), name: .DeckDidChange, object: nil)
    }
    
    @objc
    private func deckNotificationRecieved(_ notification: Notification) {
        if let decks = try? deckManager.getAllDecks() {
            allDecks.value = decks.compactMap { $0.name }
        }
    }
}

