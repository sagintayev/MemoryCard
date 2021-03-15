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
    
    private var decks: [Deck] {
        didSet { decksDidChange() }
    }
    
    var decksNames = Observable([""])
    var decksCardsCounts: Observable<[Int]> = Observable([])
    
    init?(manager: DeckPersistenceManager, decksType: DecksType) {
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
        decksDidChange()
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

}
