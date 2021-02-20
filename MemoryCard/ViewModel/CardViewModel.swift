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
    private let notificationCenter: NotificationCenter
    var question = Observable("")
    var answer = Observable("")
    var deck = Observable("")
    
    init(manager: CardManager, model: Card? = nil, notificationCenter: NotificationCenter = .default) {
        self.manager = manager
        self.notificationCenter = notificationCenter
        setModel(model)
    }
    
    func setModel(_ model: Card? = nil) {
        self.model = model
        updateProperties()
        setObservers()
    }
    
    private func updateProperties() {
        question.value = model?.question ?? ""
        answer.value = model?.answer ?? ""
        deck.value = model?.deck?.name ?? ""
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
    
    deinit {
        notificationCenter.removeObserver(self)
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
