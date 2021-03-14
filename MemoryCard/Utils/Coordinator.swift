//
//  Coordinator.swift
//  MemoryCard
//
//  Created by Zhanibek on 01.03.2021.
//

import UIKit

class Coordinator {
    private var tabBarController: UITabBarController&Coordinatable
    private lazy var navigationController: UINavigationController = {
       let navigationController = UINavigationController(rootViewController: homeViewController)
        navigationController.tabBarItem = UITabBarItem(title: "Home", image: nil, selectedImage: nil)
        if let tabBarController = tabBarController as? UINavigationControllerDelegate {
            navigationController.delegate = tabBarController
        }
        return navigationController
    }()
    
    private let manager: CardManager&DeckManager
    private let notificationCenter: NotificationCenter
    
    private lazy var homeViewController: HomeViewController = {
        let learningDecksViewModel = DecksViewModel(manager: manager, decksType: .learning)
        let homeViewController = HomeViewController(learningDecksViewModel: learningDecksViewModel)
        homeViewController.coordinator = self
        return homeViewController
    }()
    
    init(tabBarController: UITabBarController&Coordinatable, manager: CardManager&DeckManager, notificationCenter: NotificationCenter = .default) {
        self.tabBarController = tabBarController
        self.manager = manager
        self.notificationCenter = notificationCenter
    }
    
    func start() {
        let placeholderViewController1 = UIViewController()
        let placeholderViewController2 = UIViewController()
        tabBarController.viewControllers = [navigationController, placeholderViewController1, placeholderViewController2]
        tabBarController.coordinator = self
    }
    
    func backHome() {
        navigationController.popToViewController(homeViewController, animated: true)
    }
    
    func browseAllDecks() {
        guard let decksViewModel = DecksViewModel(manager: manager, decksType: .all) else { return }
        let decksViewController = DecksViewController(decksViewModel: decksViewModel)
        navigationController.pushViewController(decksViewController, animated: true)
    }
    
    func learnDeck(withName name: String) {
        guard let deck = try? manager.getDeck(byName: name) else { return }
        guard let learningCardViewModel = LearningCardViewModel(deck: deck, manager: manager, notificationCenter: notificationCenter) else { return }
        let learningCardViewController = LearningCardViewController(viewModel: learningCardViewModel)
        learningCardViewController.coordinator = self
        learningCardViewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(learningCardViewController, animated: true)
    }
    
    func createCard() {
        let cardManagerViewModel = CardManagerViewModel(model: nil, manager: manager, notificationCenter: notificationCenter)
        let cardManagerViewController = CardManagerViewController(cardManagerViewModel: cardManagerViewModel)
        cardManagerViewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(cardManagerViewController, animated: true)
    }
    
    func createDeck() {
        let deckCreationAlertController = UIAlertController(title: "Enter Deck Name", message: nil, preferredStyle: .alert)
        deckCreationAlertController.addTextField { (textField) in
            textField.placeholder = "Deck Name"
        }
        deckCreationAlertController.addAction(UIAlertAction(title: "Create", style: .default, handler: { [weak self] (_) in
            guard let deckNameTextField = deckCreationAlertController.textFields?.first else { return }
            guard let deckName = deckNameTextField.text else { return }
            self?.manager.saveDeck(named: deckName)
            deckCreationAlertController.dismiss(animated: true)
        }))
        deckCreationAlertController.addAction(UIAlertAction(title: "Cancel", style: .destructive))
        
        navigationController.present(deckCreationAlertController, animated: true)
    }
}
