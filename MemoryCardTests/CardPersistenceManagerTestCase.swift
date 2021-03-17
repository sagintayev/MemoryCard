//
//  CardPersistenceManagerTestCase.swift
//  MemoryCardTests
//
//  Created by Zhanibek on 16.03.2021.
//

import XCTest
@testable import MemoryCard

class CardPersistenceManagerTestCase: XCTestCase {
    var sut: CardPersistenceManager!
    var notificationCenter: TestNotificationCenter!
    var testDeck: Deck!

    override func setUpWithError() throws {
        notificationCenter = TestNotificationCenter()
        let coreDataStack = TestCoreDataStack()
        sut = CardPersistenceManager(coreDataStack: coreDataStack, notificationCenter: notificationCenter)
        let deckManager = DeckPersistenceManager(coreDataStack: coreDataStack, notificationCenter: notificationCenter)
        testDeck = try deckManager.saveDeck(named: "")
    }
    
    override func tearDown() {
        sut = nil
        notificationCenter = nil
        testDeck = nil
    }
    
    func testSaveCard() throws {
        let testQuestion = "testQ"
        let testAnswer = "testA"
        
        let card = try sut.saveCard(question: testQuestion, answer: testAnswer, in: testDeck)
        
        XCTAssertEqual(card.question, testQuestion)
        XCTAssertEqual(card.answer, testAnswer)
        XCTAssertEqual(card.deck, testDeck)
    }
    
    func testSaveCardSavesOnlyOne() throws {
        try sut.saveCard(question: "", answer: "", in: testDeck)
        
        let cards = try sut.getAllCards()
        XCTAssertEqual(cards.count, 1)
    }
    
    func testUpdateCard() throws {
        let card = try sut.saveCard(question: "", answer: "", in: testDeck)
        let newQuestion = "newQ"
        let newAnswer = "newA"
        
        try sut.updateCard(card, question: newQuestion, answer: newAnswer, deck: testDeck)
        
        XCTAssertEqual(card.question, newQuestion)
        XCTAssertEqual(card.answer, newAnswer)
        XCTAssertEqual(card.deck, testDeck)
    }
    
    func testDeleteCard() throws {
        let card = try sut.saveCard(question: "", answer: "", in: testDeck)
        
        sut.deleteCard(card)
        
        let cards = try sut.getAllCards()
        XCTAssertEqual(cards.count, 0)
    }
    
    func testGetAllCards() throws {
        var cards = try sut.getAllCards()
        XCTAssertEqual(cards.count, 0)
        
        for _ in 0..<10 {
            try sut.saveCard(question: "", answer: "", in: testDeck)
        }
        
        cards = try sut.getAllCards()
        XCTAssertEqual(cards.count, 10)
    }
    
    func testInitialCorrectAnswersChainZero() throws {
        let card = try sut.saveCard(question: "", answer: "", in: testDeck)
        
        XCTAssertEqual(card.correctAnswersChain, 0)
    }
    
    func testInitialCardTestDayIsToday() throws {
        let card = try sut.saveCard(question: "", answer: "", in: testDeck)
        
        XCTAssertTrue(Calendar.current.isDateInToday(card.testDate))
    }
    
    func testCreationDayIsToday() throws {
        let card = try sut.saveCard(question: "", answer: "", in: testDeck)
        
        XCTAssertTrue(Calendar.current.isDateInToday(card.creationDate))
    }
    
    func testRightAnswerIncreasesCorrectAnswerChain() throws {
        let card = try sut.saveCard(question: "", answer: "", in: testDeck)
        
        try sut.answerCard(card, withComplexity: .easy)
        try sut.answerCard(card, withComplexity: .good)
        try sut.answerCard(card, withComplexity: .hard)
        XCTAssertEqual(card.correctAnswersChain, 3)
    }
    
    func testWrongAnswerNullifyCorrectAnswerChain() throws {
        let card = try sut.saveCard(question: "", answer: "", in: testDeck)
        try sut.answerCard(card, withComplexity: .easy)
        
        try sut.answerCard(card, withComplexity: .impossible)
        
        XCTAssertEqual(card.correctAnswersChain, 0)
    }
    
    func testRightAnswerSetsCorrectNextTestDate() throws {
        let card = try sut.saveCard(question: "", answer: "", in: testDeck)
        
        for answerComplexity in [AnswerComplexity.easy, .good, .hard, .impossible] {
            let initialTestDate = card.testDate
            let initialCorrectAnswerChain = card.correctAnswersChain
            
            try sut.answerCard(card, withComplexity: answerComplexity)
    
            let days = answerComplexity.daysUntilNextCheck(multiplier: Int(max(initialCorrectAnswerChain, 1)))
            
            XCTAssertEqual(card.testDate, Calendar.current.date(byAdding: .day, value: days, to: initialTestDate))
        }
    }
    
    func testWrongAnswerDoesNotChangeTestDate() throws {
        let card = try sut.saveCard(question: "", answer: "", in: testDeck)
        let initialTestDate = card.testDate
        
        try sut.answerCard(card, withComplexity: .impossible)
        
        XCTAssertEqual(card.testDate, initialTestDate)
    }
    
    func testSavingPostsNotification() throws {
        let card = try sut.saveCard(question: "a", answer: "a", in: testDeck)
        
        XCTAssertEqual(notificationCenter.postedNotificationName, .CardDidChange)
        XCTAssertNotNil(notificationCenter.postedNotificationUserInfo)
        XCTAssertEqual(notificationCenter.postedNotificationUserInfo?["card"] as! Card, card)
        XCTAssertEqual(notificationCenter.postedNotificationUserInfo?["action"] as! Action, .create)
    }
    
    func testUpdatingPostsNotification() throws {
        let card = try sut.saveCard(question: "", answer: "", in: testDeck)
            
        try sut.updateCard(card, question: "", answer: "", deck: nil)
        
        XCTAssertEqual(notificationCenter.postedNotificationName, .CardDidChange)
        XCTAssertNotNil(notificationCenter.postedNotificationUserInfo)
        XCTAssertEqual(notificationCenter.postedNotificationUserInfo?["card"] as! Card, card)
        XCTAssertEqual(notificationCenter.postedNotificationUserInfo?["action"] as! Action, .update)
    }
    
    func testDeletingPostsNotification() throws {
        let card = try sut.saveCard(question: "", answer: "", in: testDeck)
            
        sut.deleteCard(card)
        
        XCTAssertEqual(notificationCenter.postedNotificationName, .CardDidChange)
        XCTAssertNotNil(notificationCenter.postedNotificationUserInfo)
        XCTAssertEqual(notificationCenter.postedNotificationUserInfo?["card"] as! Card, card)
        XCTAssertEqual(notificationCenter.postedNotificationUserInfo?["action"] as! Action, .delete)

    }
}

