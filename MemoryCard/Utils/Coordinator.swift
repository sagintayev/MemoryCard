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
        let homeViewController = HomeViewController(learningDecksViewModel: learningDecksViewModel)
        homeViewController.coordinator = self
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
    
    func learnDeck(withName name: String) {
        guard let deck = try? manager.getDeck(byName: name) else { return }
        guard let learningCardViewModel = LearningCardViewModel(deck: deck, manager: manager, notificationCenter: notificationCenter) else { return }
        let learningCardViewController = LearningCardViewController(viewModel: learningCardViewModel)
        learningCardViewController.coordinator = self
        navigationController.pushViewController(learningCardViewController, animated: true)
    }
}
