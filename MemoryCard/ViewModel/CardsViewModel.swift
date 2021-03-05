//
//  CardsViewModel.swift
//  MemoryCard
//
//  Created by Zhanibek on 02.03.2021.
//

import Foundation

class CardsViewModel {
    private let manager: DeckManager&CardManager
    private let notificationCenter: NotificationCenter
    private var deck: Deck? {
        didSet { modelDidChange() }
    }
    
    var cardViewModels: [CardViewModel]?
    
    init(manager: DeckManager&CardManager, deckName name: String, notificationCenter: NotificationCenter = .default) {
        self.manager = manager
        self.notificationCenter = notificationCenter
        deck = try? manager.getDeck(byName: name)
        modelDidChange()
    }
    
    func update() {
        modelDidChange()
    }
    
    private func modelDidChange() {
        guard let deck = deck else { return }
        cardViewModels = deck.cards.map { CardViewModel(manager: manager, model: $0, notificationCenter: notificationCenter) }
    }
}
