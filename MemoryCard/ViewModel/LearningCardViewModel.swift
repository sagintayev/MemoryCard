//
//  LearningCardViewModel.swift
//  MemoryCard
//
//  Created by Zhanibek on 23.02.2021.
//

import Foundation

class LearningCardViewModel {
    private let notificationCenter: NotificationCenter
    private let deckManager: DeckPersistenceManager
    private let cardManager: CardPersistenceManager
    private let cardViewModel: CardViewModel
    private let deck: Deck
    private var cardsToLearn: [Card]
    private var currentIndex = 0 {
        didSet {
            currentCardDidChange()
        }
    }
    let fullButtonsChoice: [AnswerComplexity] = [.impossible, .hard, .good, .easy]
    let binaryButtonsChoice: [AnswerComplexity] = [.impossible, .good]
    
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
        self.deck = deck
        self.deckManager = deckManager
        self.cardManager = cardManager
        self.notificationCenter = notificationCenter
        self.cardViewModel = CardViewModel(cardManager: cardManager, model: nil, notificationCenter: notificationCenter)
        self.cardsToLearn = cardsToLearn
        currentCardDidChange()
        setupObservers()
    }
    
    deinit {
        notificationCenter.removeObserver(self)
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
        updateProgressText()
        updateAnswerButtons()
        cardViewModel.setModel(cardsToLearn[currentIndex])
        answerWasShown.value = false
        isNextCardShown.value = true
    }
    
    private func updateProgressText() {
        let cardsLeft = cardsToLearn.count - currentIndex
        progressText.value = (cardsLeft > 1) ? "\(cardsLeft) left" : "The last one"
    }
    
    private func updateAnswerButtons() {
        let multiplier = max(Int(cardsToLearn[currentIndex].correctAnswersChain), 1)
        if cardsToLearn[currentIndex].correctAnswersChain > 0 {
            answerButtons.value = fullButtonsChoice.map { $0.choice(multiplier: multiplier) }
        } else {
            answerButtons.value = binaryButtonsChoice.map { $0.choice(multiplier: multiplier) }
        }
    }
    
    private func setupObservers() {
        notificationCenter.addObserver(self, selector: #selector(cardDidChange), name: .CardDidChange, object: nil)
    }
    
    @objc
    private func cardDidChange(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        guard let card = userInfo["card"] as? Card else { return }
        guard card.deck == deck else { return }
        if !cardsToLearn.contains(card) {
            cardsToLearn.append(card)
            updateProgressText()
        }
    }
}
