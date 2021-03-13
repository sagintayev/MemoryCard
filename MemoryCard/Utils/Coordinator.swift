//
//  Coordinator.swift
//  MemoryCard
//
//  Created by Zhanibek on 01.03.2021.
//

import UIKit

class Coordinator {
    private let tabBarController: UITabBarController
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
    
    init(tabBarController: UITabBarController, manager: CardManager&DeckManager, notificationCenter: NotificationCenter = .default) {
        self.tabBarController = tabBarController
        self.manager = manager
        self.notificationCenter = notificationCenter
    }
    
    func start() {
        let placeholderViewController1 = UIViewController()
        let placeholderViewController2 = UIViewController()
        tabBarController.viewControllers = [navigationController, placeholderViewController1, placeholderViewController2]
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
}
