//
//  DeckPersistenceManagerTestCase.swift
//  MemoryCardTests
//
//  Created by Zhanibek on 16.03.2021.
//

import XCTest
@testable import MemoryCard

class DeckPersistenceManagerTestCase: XCTestCase {
    private var sut: DeckPersistenceManager!
    private var cardManager: CardPersistenceManager!
    private var notificationCenter: TestNotificationCenter!

    override func setUp() {
        let coreDataStack = TestCoreDataStack()
        notificationCenter = TestNotificationCenter()
        sut = DeckPersistenceManager(coreDataStack: coreDataStack, notificationCenter: notificationCenter)
        cardManager = CardPersistenceManager(coreDataStack: coreDataStack, notificationCenter: notificationCenter)
    }
    
    override func tearDown() {
        sut = nil
        cardManager = nil
        notificationCenter = nil
    }
    
    func testSaveDeck() throws {
        let deck = try sut.saveDeck(named: "Test")
        let decks = try sut.getAllDecks()
        
        XCTAssertEqual(decks.count, 1)
        XCTAssertEqual(deck, decks.first)
    }
    
    func testUpdateDeck() throws {
        let newName = "NewName"
        let deck = try sut.saveDeck(named: "Test")
        
        try sut.updateDeck(deck, name: newName)
        
        let decks = try sut.getAllDecks()
        XCTAssertEqual(decks.first?.name, newName)
    }
    
    func testDeleteDeck() throws {
        let deck = try sut.saveDeck(named: "Test")
        
        sut.deleteDeck(deck)
        
        let decks = try sut.getAllDecks()
        XCTAssertEqual(decks.count, 0)
    }
    
    func testGetAllDecks() throws {
        for _ in 0..<10 {
            try! sut.saveDeck(named: "Test")
        }
        
        let decks = try sut.getAllDecks()
        
        XCTAssertEqual(decks.count, 10)
    }
    
    func testGetDeckByName() throws {
        let deckName = "Test"
        let deck = try sut.saveDeck(named: deckName)
        
        let deckGotByName = try sut.getDeck(byName: deckName)
        
        XCTAssertEqual(deck, deckGotByName)
    }
    
    func testGetDecksToLearn() throws {
        let _ = try sut.saveDeck(named: "WithoutCardsToLearn")
        let deckWithCardsToLearn = try sut.saveDeck(named: "WithCardsToLearn")
        try! cardManager.saveCard(question: "", answer: "", in: deckWithCardsToLearn)
        
        let decksToLearn = try sut.getDecksToLearn()
        
        XCTAssertEqual(decksToLearn.count, 1)
    }
    
    func testGetCardsToLearnFromDeck() throws {
        let deck = try sut.saveDeck(named: "Test")
        for _ in 0..<10 {
            try cardManager.saveCard(question: "", answer: "", in: deck)
        }
        let cardToLearnNotToday = try cardManager.saveCard(question: "", answer: "", in: deck)
        try cardManager.answerCard(cardToLearnNotToday, withComplexity: .easy)
        
        let cardsToLearn = try sut.getCardsToLearn(from: deck)
        
        XCTAssertEqual(cardsToLearn.count, 10)
    }
    
    func testSavingPostsNotification() throws {
        let deck = try sut.saveDeck(named: "Test")
        
        XCTAssertEqual(notificationCenter.postedNotificationName, .CardDidChange)
        XCTAssertNotNil(notificationCenter.postedNotificationUserInfo)
        XCTAssertEqual(notificationCenter.postedNotificationUserInfo?["deck"] as! Deck, deck)
        XCTAssertEqual(notificationCenter.postedNotificationUserInfo?["action"] as! Action, .create)
    }
    
    func testUpdatingPostsNotification() throws {
        let deck = try sut.saveDeck(named: "Test")
            
        try sut.updateDeck(deck, name: "newName")
        
        XCTAssertEqual(notificationCenter.postedNotificationName, .CardDidChange)
        XCTAssertNotNil(notificationCenter.postedNotificationUserInfo)
        XCTAssertEqual(notificationCenter.postedNotificationUserInfo?["deck"] as! Deck, deck)
        XCTAssertEqual(notificationCenter.postedNotificationUserInfo?["action"] as! Action, .update)
    }
    
    func testDeletingPostsNotification() throws {
        let deck = try sut.saveDeck(named: "Test")
            
        sut.deleteDeck(deck)
        
        XCTAssertEqual(notificationCenter.postedNotificationName, .CardDidChange)
        XCTAssertNotNil(notificationCenter.postedNotificationUserInfo)
        XCTAssertEqual(notificationCenter.postedNotificationUserInfo?["deck"] as! Deck, deck)
        XCTAssertEqual(notificationCenter.postedNotificationUserInfo?["action"] as! Action, .delete)

    }
}
