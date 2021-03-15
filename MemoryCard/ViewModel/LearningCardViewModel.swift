//
//  LearningCardViewModel.swift
//  MemoryCard
//
//  Created by Zhanibek on 23.02.2021.
//

import Foundation

class LearningCardViewModel {
    private let deckManager: DeckPersistenceManager
    private let cardManager: CardPersistenceManager
    private let cardViewModel: CardViewModel
    
    private let fullButtonsChoice: [AnswerComplexity] = [.impossible, .hard, .good, .easy]
    private let binaryButtonsChoice: [AnswerComplexity] = [.impossible, .good]
    private var cardsToLearn: [Card]
    private var currentIndex = 0 {
        didSet {
            currentCardDidChange()
        }
    }
    
    var answerWasShown = Observable(false)
    var isFinished = Observable(false)
    var progressText = Observable("")
    var answerButtons = Observable([""])
    var isNextCardShown = Observable(true)
    var question: Observable<String> {
        cardViewModel.question
    }
    var answer: Observable<String> {
        cardViewModel.answer
    }
    
    init?(deck: Deck, deckManager: DeckPersistenceManager, cardManager: CardPersistenceManager, notificationCenter: NotificationCenter) {
        guard let cardsToLearn = try? deckManager.getCardsToLearn(from: deck) else {
            return nil
        }
        guard cardsToLearn.count > 0 else { return nil }
        self.deckManager = deckManager
        self.cardManager = cardManager
        self.cardViewModel = CardViewModel(cardManager: cardManager, model: nil, notificationCenter: notificationCenter)
        self.cardsToLearn = cardsToLearn
        currentCardDidChange()
    }
    
    func answerCard(buttonIndex: Int) {
        let complexity: AnswerComplexity = cardsToLearn[currentIndex].correctAnswersChain > 0 ? fullButtonsChoice[buttonIndex] : binaryButtonsChoice[buttonIndex]
        try? cardManager.answerCard(cardsToLearn[currentIndex], withComplexity: complexity)
        let againButtonTapped = (buttonIndex == 0)
        nextCard(postponeCurrentCard: againButtonTapped)
    }
    
    private func nextCard(postponeCurrentCard: Bool) {
        if postponeCurrentCard {
            cardsToLearn.swapAt(currentIndex, Int.random(in: currentIndex..<cardsToLearn.count))
            currentCardDidChange()
        } else {
            currentIndex += 1
        }
    }
    
    private func currentCardDidChange() {
        guard currentIndex < cardsToLearn.count else {
            isFinished.value = true
            return
        }
        let cardsLeft = cardsToLearn.count - currentIndex
        progressText.value = (cardsLeft > 1) ? "\(cardsLeft) left" : "The last one"
        let multiplier = max(Int(cardsToLearn[currentIndex].correctAnswersChain), 1)
        if cardsToLearn[currentIndex].correctAnswersChain > 0 {
            answerButtons.value = fullButtonsChoice.map { $0.choice(multiplier: multiplier) }
        } else {
            answerButtons.value = binaryButtonsChoice.map { $0.choice(multiplier: multiplier) }
        }
        cardViewModel.setModel(cardsToLearn[currentIndex])
        answerWasShown.value = false
        isNextCardShown.value = true
    }
}
