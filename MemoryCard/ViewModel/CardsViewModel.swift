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
        setupObservers()
    }
    
    deinit {
        notificationCenter.removeObserver(self)
    }
    
    private func modelDidChange() {
        guard let deck = deck else { return }
        cardViewModels = deck.cards.map { CardViewModel(cardManager: cardManager, model: $0, notificationCenter: notificationCenter) }
    }
    
    private func setupObservers() {
        notificationCenter.addObserver(self, selector: #selector(cardDidChange), name: .CardDidChange, object: nil)
    }
    
    @objc
    private func cardDidChange(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        guard let card = userInfo["card"] as? Card else { return }
        guard card.deck == deck else { return }
        guard let action = userInfo["action"] as? Action else { return }
        
        switch action {
        case .create:
            let cardViewModel = CardViewModel(cardManager: cardManager, model: card, notificationCenter: notificationCenter)
            cardViewModels?.append(cardViewModel)
        case .update:
            let cardViewModel = CardViewModel(cardManager: cardManager, model: card, notificationCenter: notificationCenter)
            if let index = cardViewModels?.firstIndex(where: { $0 == cardViewModel }) {
                cardViewModels?[index] = cardViewModel
            }
        case .delete:
            let cardViewModel = CardViewModel(cardManager: cardManager, model: card, notificationCenter: notificationCenter)
            if let index = cardViewModels?.firstIndex(where: { $0 == cardViewModel }) {
                cardViewModels?.remove(at: index)
            }
        }
    }
}
