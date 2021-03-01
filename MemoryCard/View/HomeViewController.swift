//
//  HomeViewController.swift
//  MemoryCard
//
//  Created by Zhanibek Sagintayev on 2021-01-26.
//

import UIKit

final class HomeViewController: UIViewController {
    
    private let learningDecksViewModel: LearningDecksViewModel?
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .blue
        tableView.separatorStyle = .none
        tableView.contentInset.top = 50
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    init(manager: DeckManager&CardManager) {
        learningDecksViewModel = LearningDecksViewModel(manager: manager)
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
    }
    
    private func setupSubviews() {
        view.addSubview(tableView)
        
        let constraints = [
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.register(DecksTableViewCell.self, forCellReuseIdentifier: DecksTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Table View Data Source
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DecksTableViewCell.identifier, for: indexPath)
        if let cell = cell as? DecksTableViewCell {
            learningDecksViewModel?.decksTitles.observe { titles in
                cell.titles = titles
            }
            learningDecksViewModel?.decksCardsCounts.observe { counts in
                cell.counts = counts
            }
        }
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
