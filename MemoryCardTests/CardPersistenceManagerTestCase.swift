//
//  CardPersistenceManagerTestCase.swift
//  MemoryCardTests
//
//  Created by Zhanibek on 16.03.2021.
//

import XCTest
@testable import MemoryCard

class CardPersistenceManagerTestCase: XCTestCase {
    
    private var cardManager: CardPersistenceManager!
    private var coreDataStack: CoreDataStack!
    private var notificationCenter: TestNotificationCenter!

    override func setUpWithError() throws {
        notificationCenter = TestNotificationCenter()
        coreDataStack = TestCoreDataStack()
        cardManager = CardPersistenceManager(coreDataStack: coreDataStack, notificationCenter: notificationCenter)
    }

    override func tearDownWithError() throws {
        cardManager = nil
    }
    
    func testSaveCard() {
        let testQuestion = "testQ"
        let testAnswer = "testA"
        let testDeck = createTestDeck()
        
        let card = try? cardManager.saveCard(question: testQuestion, answer: testAnswer, in: testDeck)
        
        XCTAssertEqual(card?.question, testQuestion)
        XCTAssertEqual(card?.answer, testAnswer)
        XCTAssertEqual(card?.deck, testDeck)
    }
    
    func testSaveCardSavesOnlyOne() {
        let testDeck = createTestDeck()
        
        _ = try? cardManager.saveCard(question: "", answer: "", in: testDeck)
        
        let cards = try? cardManager.getAllCards()
        XCTAssertEqual(cards?.count, 1)
    }
    
    func testUpdateCard() {
        let testCard = createTestCard()
        let newQuestion = "newQ"
        let newAnswer = "newA"
        let newDeck = createTestDeck()
        
        try? cardManager.updateCard(testCard, question: newQuestion, answer: newAnswer, deck: newDeck)
        
        let cards = try? cardManager.getAllCards()
        XCTAssertEqual(cards?.first?.question, newQuestion)
        XCTAssertEqual(cards?.first?.answer, newAnswer)
        XCTAssertEqual(cards?.first?.deck, newDeck)
    }
    
    func testDeleteCard() {
        let card = try! cardManager.saveCard(question: "", answer: "", in: createTestDeck())
        
        cardManager.deleteCard(card)
        
        let cards = try? cardManager.getAllCards()
        XCTAssertEqual(cards?.count, 0)
    }
    
    func testGetAllCards() {
        var cards = try? cardManager.getAllCards()
        XCTAssertEqual(cards?.count, 0)
        
        for _ in 0..<10 {
            try! cardManager.saveCard(question: "", answer: "", in: createTestDeck())
        }
        
        cards = try? cardManager.getAllCards()
        XCTAssertEqual(cards?.count, 10)
    }
    
    func testInitialCorrectAnswersChainZero() {
        let deck = createTestDeck()
        let card = try? cardManager.saveCard(question: "", answer: "", in: deck)
        
        XCTAssertEqual(card?.correctAnswersChain, 0)
    }
    
    func testInitialCardTestDayIsToday() {
        let card = try! cardManager.saveCard(question: "", answer: "", in: createTestDeck())
        
        XCTAssertTrue(Calendar.current.isDateInToday(card.testDate))
    }
    
    func testCreationDayIsToday() {
        let card = try! cardManager.saveCard(question: "", answer: "", in: createTestDeck())
        
        XCTAssertTrue(Calendar.current.isDateInToday(card.creationDate))
    }
    
    func testRightAnswerIncreasesCorrectAnswerChain() {
        let card = try! cardManager.saveCard(question: "", answer: "", in: createTestDeck())
        
        try! cardManager.answerCard(card, withComplexity: .easy)
        try! cardManager.answerCard(card, withComplexity: .good)
        try! cardManager.answerCard(card, withComplexity: .hard)
        XCTAssertEqual(card.correctAnswersChain, 3)
    }
    
    func testWrongAnswerNullifyCorrectAnswerChain() {
        let card = try! cardManager.saveCard(question: "", answer: "", in: createTestDeck())
        try! cardManager.answerCard(card, withComplexity: .easy)
        
        try! cardManager.answerCard(card, withComplexity: .impossible)
        
        XCTAssertEqual(card.correctAnswersChain, 0)
    }
    
    func testRightAnswerSetsCorrectNextTestDate() {
        let card = try! cardManager.saveCard(question: "", answer: "", in: createTestDeck())
        
        
        for answerComplexity in [AnswerComplexity.easy, .good, .hard, .impossible] {
            let initialTestDate = card.testDate
            let initialCorrectAnswerChain = card.correctAnswersChain
            
            try! cardManager.answerCard(card, withComplexity: answerComplexity)
    
            let days = answerComplexity.daysUntilNextCheck(multiplier: Int(max(initialCorrectAnswerChain, 1)))
            
            XCTAssertEqual(card.testDate, Calendar.current.date(byAdding: .day, value: days, to: initialTestDate))
        }
    }
    
    func testWrongAnswerDoesNotChangeTestDate() {
        let card = try! cardManager.saveCard(question: "", answer: "", in: createTestDeck())
        let initialTestDate = card.testDate
        
        try! cardManager.answerCard(card, withComplexity: .impossible)
        
        XCTAssertEqual(card.testDate, initialTestDate)
    }
    
    func testSavingPostsNotification() {
        let card = try! cardManager.saveCard(question: "a", answer: "a", in: createTestDeck())
        
        XCTAssertEqual(notificationCenter.postedNotificationName, .CardDidChange)
        XCTAssertNotNil(notificationCenter.postedNotificationUserInfo)
        XCTAssertEqual(notificationCenter.postedNotificationUserInfo?["card"] as! Card, card)
        XCTAssertEqual(notificationCenter.postedNotificationUserInfo?["action"] as! Action, .create)
    }
    
    func testUpdatingPostsNotification() {
        let card = try! cardManager.saveCard(question: "", answer: "", in: createTestDeck())
            
        try! cardManager.updateCard(card, question: "", answer: "", deck: nil)
        
        XCTAssertEqual(notificationCenter.postedNotificationName, .CardDidChange)
        XCTAssertNotNil(notificationCenter.postedNotificationUserInfo)
        XCTAssertEqual(notificationCenter.postedNotificationUserInfo?["card"] as! Card, card)
        XCTAssertEqual(notificationCenter.postedNotificationUserInfo?["action"] as! Action, .update)
    }
    
    func testDeletingPostsNotification() {
        let card = try! cardManager.saveCard(question: "", answer: "", in: createTestDeck())
            
        cardManager.deleteCard(card)
        
        XCTAssertEqual(notificationCenter.postedNotificationName, .CardDidChange)
        XCTAssertNotNil(notificationCenter.postedNotificationUserInfo)
        XCTAssertEqual(notificationCenter.postedNotificationUserInfo?["card"] as! Card, card)
        XCTAssertEqual(notificationCenter.postedNotificationUserInfo?["action"] as! Action, .delete)
    }
    
    
    private func createTestDeck() -> Deck {
        let testDeck = Deck(context: coreDataStack.viewContext)
        testDeck.name = "testDeck"
        try? coreDataStack.viewContext.save()
        return testDeck
    }
    
    @discardableResult
    private func createTestCard() -> Card {
        let testCard = Card(context: coreDataStack.viewContext)
        try? coreDataStack.viewContext.save()
        return testCard
    }
}

