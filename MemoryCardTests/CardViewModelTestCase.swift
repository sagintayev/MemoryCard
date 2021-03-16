//
//  CardViewModelTestCase.swift
//  MemoryCardTests
//
//  Created by Zhanibek on 14.03.2021.
//

import XCTest
@testable import MemoryCard

class CardViewModelTestCase: XCTestCase {
    var cardViewModel: CardViewModel!

    override func setUpWithError() throws {
        let coreDataStack = TestCoreDataStack()
        let cardManager = CardPersistenceManager(coreDataStack: coreDataStack, notificationCenter: .default)
        cardViewModel = CardViewModel(cardManager: cardManager, model: nil, notificationCenter: .default)
        cardViewModel.question = Observable("testQuestion")
        cardViewModel.answer = Observable("testAnswer")
        cardViewModel.deck = Observable("testDeck")
    }

    override func tearDownWithError() throws {
        cardViewModel = nil
    }

    func testRemoveObservers() throws {
        let observables = [cardViewModel.question, cardViewModel.answer, cardViewModel.deck]
        observables.forEach {$0.observe {_ in }}
        
        cardViewModel.removeObservers()
        
        observables.forEach {
            XCTAssertFalse($0.isObserved)
        }
    }

}
