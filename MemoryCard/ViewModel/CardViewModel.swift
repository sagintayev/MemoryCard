//
//  CardViewModel.swift
//  MemoryCard
//
//  Created by Zhanibek Sagintayev on 2021-02-03.
//

import Foundation

final class CardViewModel {
    private var model: Card?
    private var manager: CardManager
    var question = Observable("")
    var answer = Observable("")
    var deck = Observable("")
    
    init(manager: CardManager, model: Card? = nil) {
        self.manager = manager
        setModel(model)
    }
    
    func setModel(_ model: Card? = nil) {
        self.model = model
        updateProperties()
    }
    
    private func updateProperties() {
        question.value = model?.question ?? ""
        answer.value = model?.answer ?? ""
        deck.value = model?.deck?.name ?? ""
    }
}

extension CardViewModel: CardObserver {
    func cardManager(_ cardManager: CardManager, didInsertCard card: Card) {
        guard card == model else { return }
        updateProperties()
    }
    
    func cardManager(_ cardManager: CardManager, didUpdateCard card: Card) {
        guard card == model else { return }
        updateProperties()
    }
    
    func cardManager(_ cardManager: CardManager, didDeleteCard card: Card) {
        guard card == model else { return }
        updateProperties()
    }
}
