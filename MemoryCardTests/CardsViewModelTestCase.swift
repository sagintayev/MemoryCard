//
//  CardsViewModelTestCase.swift
//  MemoryCardTests
//
//  Created by Zhanibek on 17.03.2021.
//

import XCTest
@testable import MemoryCard

class CardsViewModelTestCase: XCTestCase {
    var sut: CardsViewModel!
    var cardManager: CardPersistenceManager!
    var deck: Deck!

    override func setUpWithError() throws {
        let coreDataStack = TestCoreDataStack()
        let deckManager = DeckPersistenceManager(coreDataStack: coreDataStack, notificationCenter: .default)
        cardManager = CardPersistenceManager(coreDataStack: coreDataStack, notificationCenter: .default)
        let deckName = "Test"
        deck = try deckManager.saveDeck(named: deckName)
        sut = CardsViewModel(deckManager: deckManager, cardManager: cardManager, deckName: deckName, notificationCenter: .default)
    }

    override func tearDown() {
        sut = nil
        cardManager = nil
        deck = nil
    }
    
    func testCardViewModels() throws {
        let cardsCount = 3
        for _ in 0..<cardsCount {
            try cardManager.saveCard(question: "", answer: "", in: deck)
        }
        
        XCTAssertEqual(sut.cardViewModels?.count, 3)
    }
}
