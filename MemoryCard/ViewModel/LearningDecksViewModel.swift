//
//  LearningDecksViewModel.swift
//  MemoryCard
//
//  Created by Zhanibek on 28.02.2021.
//

import Foundation

class LearningDecksViewModel {
    private var decks: [Deck] {
        didSet { decksDidChange() }
    }
    private let notificationCenter: NotificationCenter
    private let manager: DeckManager
    
    var decksTitles = Observable([""])
    var decksCardsCounts: Observable<[Int]> = Observable([])
    
    init?(manager: DeckManager, notificationCenter: NotificationCenter = .default) {
        guard let decks = try? manager.getDecksToLearn() else { return nil }
        self.decks = decks
        self.notificationCenter = notificationCenter
        self.manager = manager
        decksDidChange()
    }
    
    func refresh() {
        if let decks = try? manager.getDecksToLearn() {
            self.decks = decks
        }
    }
    
    private func decksDidChange() {
        decksTitles.value = decks.compactMap { $0.name }
        decksCardsCounts.value = decks.compactMap { try? manager.getCardsToLearn(from: $0).count }
    }
}
