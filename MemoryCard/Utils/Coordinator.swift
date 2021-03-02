//
//  Coordinator.swift
//  MemoryCard
//
//  Created by Zhanibek on 01.03.2021.
//

import UIKit

class Coordinator {
    private let manager: CardManager&DeckManager
    private let navigationController: UINavigationController
    private let notificationCenter: NotificationCenter
    
    private lazy var homeViewController: HomeViewController = {
        let learningDecksViewModel = LearningDecksViewModel(manager: manager, notificationCenter: notificationCenter)
        learningDecksViewModel?.deckWasChosen = learnDeck
        let homeViewController = HomeViewController(learningDecksViewModel: learningDecksViewModel)
        return homeViewController
    }()
    
    init(navigationController: UINavigationController, manager: CardManager&DeckManager, notificationCenter: NotificationCenter = .default) {
        self.manager = manager
        self.navigationController = navigationController
        self.notificationCenter = notificationCenter
    }
    
    func start() {
        navigationController.pushViewController(homeViewController, animated: false)
    }
    
    func backHome() {
        navigationController.popToViewController(homeViewController, animated: true)
    }
    
    func browseAllDecks() {
        
    }
    
    private func learnDeck(_ deck: Deck) {
        guard let learningCardViewModel = LearningCardViewModel(deck: deck, manager: manager, notificationCenter: notificationCenter) else { return }
        let learningCardViewController = LearningCardViewController(viewModel: learningCardViewModel)
        learningCardViewController.coordinator = self
        navigationController.pushViewController(learningCardViewController, animated: true)
    }
}
