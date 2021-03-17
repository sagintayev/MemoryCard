//
//  DecksViewModelTestCase.swift
//  MemoryCardTests
//
//  Created by Zhanibek on 17.03.2021.
//

import XCTest
@testable import MemoryCard

class DecksViewModelTestCase: XCTestCase {
    var sut: DecksViewModel!
    var deckManager: DeckPersistenceManager!
    var cardManager: CardPersistenceManager!

    override func setUpWithError() throws {
        let coreDataStack = TestCoreDataStack()
        deckManager = DeckPersistenceManager(coreDataStack: coreDataStack, notificationCenter: .default)
        cardManager = CardPersistenceManager(coreDataStack: coreDataStack, notificationCenter: .default)
        sut = DecksViewModel(manager: deckManager, decksType: .all, notificationCenter: .default)
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testAllDecks() throws {
        let createdDecksCount = 10
        let deletedDecksCount = 2
        for i in 0..<createdDecksCount {
            try deckManager.saveDeck(named: "Test\(i)")
        }
        for i in 0..<deletedDecksCount {
            try deckManager.deleteDeck(deckManager.getDeck(byName: "Test\(i)")!)
        }
        
        XCTAssertEqual(sut.decksNames.value.count, createdDecksCount-deletedDecksCount)
    }
    
    func testLearningDecks() throws {
       sut = DecksViewModel(manager: deckManager, decksType: .learning, notificationCenter: .default)
        let learningDecksCount = 10
        let notLearningDecksCount = 2
        for i in 0..<learningDecksCount {
            let deck = try deckManager.saveDeck(named: "Learning\(i)")
            try cardManager.saveCard(question: "", answer: "", in: deck)
        }
        for i in 0..<notLearningDecksCount {
            try deckManager.saveDeck(named: "Not Learning\(i)")
        }
        
        XCTAssertEqual(sut.decksNames.value.count, learningDecksCount)
    }
    
    func testDecksCardsCounts() throws {
        let cardsCount = 10
        let deck = try deckManager.saveDeck(named: "Test")
        for _ in 0..<cardsCount {
            try cardManager.saveCard(question: "", answer: "", in: deck)
        }
        
        XCTAssertEqual(sut.decksCardsCounts.value.first, cardsCount)
    }
    
    func testRemoveObservers() {
        sut.removeObservers()
        
        XCTAssertFalse(sut.decksNames.isObserved)
        XCTAssertFalse(sut.decksCardsCounts.isObserved)
    }

}
