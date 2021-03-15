//
//  CardsViewModel.swift
//  MemoryCard
//
//  Created by Zhanibek on 02.03.2021.
//

import Foundation

class CardsViewModel {
    private let deckManager: DeckPersistenceManager
    private let cardManager: CardPersistenceManager
    private let notificationCenter: NotificationCenter
    
    private var deck: Deck? {
        didSet { modelDidChange() }
    }
    
    var cardViewModels: [CardViewModel]?
    
    init(deckManager: DeckPersistenceManager, cardManager: CardPersistenceManager, deckName name: String, notificationCenter: NotificationCenter) {
        self.deckManager = deckManager
        self.cardManager = cardManager
        self.notificationCenter = notificationCenter
        deck = try? deckManager.getDeck(byName: name)
        modelDidChange()
    }
    
    func update() {
        modelDidChange()
    }
    
    private func modelDidChange() {
        guard let deck = deck else { return }
        cardViewModels = deck.cards.map { CardViewModel(cardManager: cardManager, model: $0, notificationCenter: notificationCenter) }
    }
}
