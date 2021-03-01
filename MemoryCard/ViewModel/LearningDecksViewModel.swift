//
//  LearningDecksViewModel.swift
//  MemoryCard
//
//  Created by Zhanibek on 28.02.2021.
//

import Foundation

class LearningDecksViewModel {
    private var decks: [Deck]
    private let notificationCenter: NotificationCenter
    
    var decksTitles = Observable([""])
    var decksCardsCounts: Observable<[Int]> = Observable([])
    
    init?(manager: DeckManager, notificationCenter: NotificationCenter = .default) {
        guard let decks = try? manager.getDecksToLearn() else { return nil }
        self.decks = decks
        self.notificationCenter = notificationCenter
        decksTitles.value = decks.compactMap { $0.name }
        decksCardsCounts.value = decks.compactMap { try? manager.getCardsToLearn(from: $0).count }
    }
}
