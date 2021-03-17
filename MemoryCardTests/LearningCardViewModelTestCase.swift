//
//  LearningCardViewModelTestCase.swift
//  MemoryCardTests
//
//  Created by Zhanibek on 17.03.2021.
//

import XCTest
@testable import MemoryCard

class LearningCardViewModelTestCase: XCTestCase {
    var sut: LearningCardViewModel!
    var coreDataStack: CoreDataStack!
    var cardManager: CardPersistenceManager!
    var deck: Deck!
    var cardToLearn: Card!
    
    override func setUpWithError() throws {
        coreDataStack = TestCoreDataStack()
        let notificationCenter: NotificationCenter = .default
        let deckManager = DeckPersistenceManager(coreDataStack: coreDataStack, notificationCenter: notificationCenter)
        deck = try deckManager.saveDeck(named: "Test")
        cardManager = CardPersistenceManager(coreDataStack: coreDataStack, notificationCenter: notificationCenter)
        cardToLearn = try cardManager.saveCard(question: "", answer: "", in: deck)
        sut = LearningCardViewModel(deck: deck, deckManager: deckManager, cardManager: cardManager, notificationCenter: notificationCenter)
    }

    override func tearDown() {
        sut = nil
        coreDataStack = nil
        cardManager = nil
        deck = nil
        cardToLearn = nil
    }
    
    func testCommonInitialState() {
        XCTAssertFalse(sut.answerWasShown.value)
        XCTAssertFalse(sut.isFinished.value)
    }
    
    func testProgressTextWithOneCard() {
        XCTAssertEqual(sut.progressText.value, "The last one")
    }
    
    func testProgressTextWithSeveralCards() throws {
        try cardManager.saveCard(question: "Q", answer: "A", in: deck)
        let cards = try cardManager.getAllCards()
        
        XCTAssertEqual(sut.progressText.value, "\(cards.count) left")
    }
    
    func testBinaryButtonsChoice() throws {
        XCTAssertEqual(sut.answerButtons.value, sut.binaryButtonsChoice.map {$0.choice(multiplier: Int(max(cardToLearn.correctAnswersChain, 1)))})
    }
    
    func testFullButtonsChoice() throws {
        let newCardToLearn = try cardManager.saveCard(question: "", answer: "", in: deck)
        newCardToLearn.correctAnswersChain = 2
        try coreDataStack.viewContext.save()
        sut.answerCard(buttonIndex: 1)
        
        XCTAssertEqual(sut.answerButtons.value, sut.fullButtonsChoice.map {$0.choice(multiplier: Int(max(newCardToLearn.correctAnswersChain, 1)))})
    }
    
    func testIsFinished() {
        sut.answerCard(buttonIndex: 1)
        
        XCTAssertTrue(sut.isFinished.value)
    }
    
    func testWrongAnswerDoesNotChangeProgressText() {
        let oldProgressText = sut.progressText.value
        sut.answerCard(buttonIndex: 0)
        
        XCTAssertEqual(oldProgressText, sut.progressText.value)
    }
    
    func testRightAnswerChangesProgressText() throws {
        try cardManager.saveCard(question: "", answer: "", in: deck)
        let oldProgressText = sut.progressText.value
        
        sut.answerCard(buttonIndex: 1)
        
        XCTAssertNotEqual(oldProgressText, sut.progressText.value)
    }
}
