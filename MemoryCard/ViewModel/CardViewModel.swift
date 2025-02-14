//
//  CardViewModel.swift
//  MemoryCard
//
//  Created by Zhanibek Sagintayev on 2021-02-03.
//

import Foundation

final class CardViewModel {
    private var model: Card?
    private var cardManager: CardPersistenceManager
    private let notificationCenter: NotificationCenter
    
    var question = Observable("")
    var answer = Observable("")
    var deck = Observable("")
    var testDate = Observable("")
    
    init(cardManager: CardPersistenceManager, model: Card?, notificationCenter: NotificationCenter) {
        self.cardManager = cardManager
        self.notificationCenter = notificationCenter
        setModel(model)
        setObservers()
    }
    
    deinit {
        notificationCenter.removeObserver(self)
    }
    
    func setModel(_ model: Card? = nil) {
        self.model = model
        updateProperties()
    }
    
    func removeObservers() {
        [question, answer, deck, testDate].forEach {
            $0.removeObserver()
        }
    }
    
    private func updateProperties() {
        guard let model = model else {
            [question, answer, deck, testDate].forEach {
                $0.value = ""
            }
            return
        }
        question.value = model.question
        answer.value = model.answer
        deck.value = model.deck.name
        let testDateComponents = Calendar.current.dateComponents([.day, .month], from: model.testDate)
        testDate.value = "\(testDateComponents.day!)/\(testDateComponents.month!)"
    }
    
    private func setObservers() {
        notificationCenter.addObserver(self, selector: #selector(cardDidChange), name: .CardDidChange, object: nil)
    }
    
    @objc
    private func cardDidChange(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        guard let card = userInfo["card"] as? Card else { return }
        guard card === model else { return }
        guard let action = userInfo["action"] as? Action else { return }
        switch action {
        case .update:
            updateProperties()
        case .delete:
            setModel(nil)
            updateProperties()
        default:
            break
        }
    }
}

extension CardViewModel: Equatable {
    static func == (lhs: CardViewModel, rhs: CardViewModel) -> Bool {
        return lhs.model == rhs.model
    }
}
