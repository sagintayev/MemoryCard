//
//  DecksViewModel.swift
//  MemoryCard
//
//  Created by Zhanibek on 28.02.2021.
//

import Foundation

enum DecksType {
    case all
    case learning
}

class DecksViewModel {
    private let manager: DeckPersistenceManager
    private let getDecks: () -> [Deck]?
    private let notificationCenter: NotificationCenter
    
    private var decks: [Deck] {
        didSet { decksDidChange() }
    }
    private let decksType: DecksType
    
    var decksNames = Observable([""])
    var decksCardsCounts: Observable<[Int]> = Observable([])
    
    init?(manager: DeckPersistenceManager, decksType: DecksType, notificationCenter: NotificationCenter) {
        getDecks = { () -> [Deck]? in
            switch decksType {
            case .all:
                return try? manager.getAllDecks()
            case .learning:
                return try? manager.getDecksToLearn()
            }
        }
        guard let decks = getDecks() else { return nil }
        self.decks = decks
        self.manager = manager
        self.notificationCenter = notificationCenter
        self.decksType = decksType
        decksDidChange()
        setObservers()
    }
    
    deinit {
        notificationCenter.removeObserver(self)
    }
    
    func refresh() {
        if let decks = getDecks() {
            self.decks = decks
        }
    }
    
    func removeObservers() {
        decksNames.removeObserver()
        decksCardsCounts.removeObserver()
    }
    
    private func decksDidChange() {
        decksNames.value = decks.compactMap { $0.name }
        decksCardsCounts.value = decks.compactMap { try? manager.getCardsToLearn(from: $0).count }
    }
    
    private func setObservers() {
        notificationCenter.addObserver(self, selector: #selector(deckDidChange), name: .DeckDidChange, object: nil)
    }
    
    @objc
    private func deckDidChange(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        guard let deck = userInfo["deck"] as? Deck else { return }
        guard let action = userInfo["action"] as? Action else { return }
        switch action {
        case .create:
            guard decksType == .all else { return }
            decks.append(deck)
        case .update:
            guard deck.cards.contains(where: { Calendar.current.isDateInToday($0.testDate) }) else { return }
                decks.append(deck)
        case .delete:
            decks.removeAll(where: {$0 == deck})
        }
    }
}
