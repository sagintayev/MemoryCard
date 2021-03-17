//
//  CardViewModelTestCase.swift
//  MemoryCardTests
//
//  Created by Zhanibek on 14.03.2021.
//

import XCTest
@testable import MemoryCard

class CardViewModelTestCase: XCTestCase {
    var sut: CardViewModel!
    var cardManager: CardPersistenceManager!
    var deckManager: DeckPersistenceManager!
    var testDeck: Deck!

    override func setUpWithError() throws {
        let coreDataStack = TestCoreDataStack()
        cardManager = CardPersistenceManager(coreDataStack: coreDataStack, notificationCenter: .default)
        sut = CardViewModel(cardManager: cardManager, model: nil, notificationCenter: .default)
        sut.question = Observable("testQuestion")
        sut.answer = Observable("testAnswer")
        sut.deck = Observable("testDeck")
        deckManager = DeckPersistenceManager(coreDataStack: coreDataStack, notificationCenter: .default)
        testDeck = try deckManager.saveDeck(named: "")
    }
    
    override func tearDown() {
        sut = nil
        cardManager = nil
        testDeck = nil
    }
    
    func testSetModel() throws {
        let question = "Q"
        let answer = "A"
        let newModel = try cardManager.saveCard(question: question, answer: answer, in: testDeck)
        
        sut.setModel(newModel)
            
        XCTAssertEqual(sut.question.value, question)
        XCTAssertEqual(sut.answer.value, answer)
        XCTAssertEqual(sut.deck.value, testDeck.name)
    }

    func testRemoveObservers() throws {
        let observables = [sut.question, sut.answer, sut.deck]
        observables.forEach {$0.observe {_ in }}
        
        sut.removeObservers()
        
        observables.forEach {
            XCTAssertFalse($0.isObserved)
        }
    }
    
    func testReactingToModelUpdate() throws {
        let newQuestion = "newQ"
        let newAnswer = "newA"
        let newDeckName = "newD"
        let newDeck = try deckManager.saveDeck(named: newDeckName)
        let card = try cardManager.saveCard(question: "", answer: "", in: testDeck)
        sut.setModel(card)
        
        try cardManager.updateCard(card, question: newQuestion, answer: newAnswer, deck: newDeck)
        
        XCTAssertEqual(sut.question.value, newQuestion)
        XCTAssertEqual(sut.answer.value, newAnswer)
        XCTAssertEqual(sut.deck.value, newDeckName)
    }
    
    func testReactingToModelDelete() throws {
        let card = try cardManager.saveCard(question: "", answer: "", in: testDeck)
        sut.setModel(card)
        
        cardManager.deleteCard(card)
        
        XCTAssertEqual(sut.question.value, "")
        XCTAssertEqual(sut.answer.value, "")
        XCTAssertEqual(sut.deck.value, "")
    }

}
