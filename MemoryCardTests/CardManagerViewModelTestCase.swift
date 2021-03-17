//
//  CardManagerViewModelTestCase.swift
//  MemoryCardTests
//
//  Created by Zhanibek on 16.03.2021.
//

import XCTest
@testable import MemoryCard

class CardManagerViewModelTestCase: XCTestCase {
    var sut: CardManagerViewModel!
    var deckManager: DeckPersistenceManager!
    var cardManager: CardPersistenceManager!

    override func setUpWithError() throws {
        let coreDataStack = TestCoreDataStack()
        deckManager = DeckPersistenceManager(coreDataStack: coreDataStack, notificationCenter: .default)
        cardManager = CardPersistenceManager(coreDataStack: coreDataStack, notificationCenter: .default)
        sut = CardManagerViewModel(deckManager: deckManager, cardManager: cardManager, notificationCenter: .default)
    }

    override func tearDown() {
        sut = nil
        deckManager = nil
        cardManager = nil
    }
    
    func testSaveCard() throws {
        let deck = try deckManager.saveDeck(named: "Test")
        let question = "Q"
        let answer = "A"
        
        sut.saveCard(question: question, answer: answer, deckName: deck.name)
        
        let cards = try cardManager.getAllCards()
        XCTAssertEqual(cards.first?.question, question)
        XCTAssertEqual(cards.first?.answer, answer)
        XCTAssertEqual(cards.first?.deck.name, deck.name)
    }
    
    func testUpdateCard() throws {
        let newQuestion = "Q"
        let newAnswer = "A"
        let newDeck = try deckManager.saveDeck(named: "D")
        let deck = try deckManager.saveDeck(named: "Test")
        let card = try cardManager.saveCard(question: "", answer: "", in: deck)
        sut.setModel(card)
   
        sut.saveCard(question: newQuestion, answer: newAnswer, deckName: newDeck.name)
        
        let cards = try cardManager.getAllCards()
        XCTAssertEqual(cards.first?.question, newQuestion)
        XCTAssertEqual(cards.first?.answer, newAnswer)
        XCTAssertEqual(cards.first?.deck.name, newDeck.name)
    }
    
    func testInitialStateWithoutModel() {
        XCTAssertEqual(sut.question.value, "")
        XCTAssertEqual(sut.answer.value, "")
        XCTAssertEqual(sut.deck.value, "")
        XCTAssertEqual(sut.allDecks.value, [])
        XCTAssertEqual(sut.buttonText.value, "Create")
    }
    
    func testSetModel() throws {
        let deck = try deckManager.saveDeck(named: "Test")
        let card = try cardManager.saveCard(question: "Q", answer: "A", in: deck)
        
        sut.setModel(card)
        
        XCTAssertEqual(sut.question.value, card.question)
        XCTAssertEqual(sut.question.value, card.question)
        XCTAssertEqual(sut.deck.value, card.deck.name)
        XCTAssertEqual(sut.allDecks.value, [deck.name])
        XCTAssertEqual(sut.buttonText.value, "Update")
    }
    
    func testReactionToDeckCreation() throws {
        let deckName = "Test"
        try deckManager.saveDeck(named: deckName)
        
        XCTAssertEqual(sut.allDecks.value, [deckName])
    }
}
