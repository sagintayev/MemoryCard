//
//  HomeViewController.swift
//  MemoryCard
//
//  Created by Zhanibek Sagintayev on 2021-01-26.
//

import UIKit

final class HomeViewController: UIViewController {
    weak var coordinator: Coordinator?
    
    private let learningDecksViewModel: DecksViewModel?
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.contentInset.top = 50
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    init(learningDecksViewModel: DecksViewModel?) {
        self.learningDecksViewModel = learningDecksViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray5
        setupSubviews()
        setupNavItem()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        learningDecksViewModel?.refresh()
        tableView.reloadSections([0], with: .none)
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
        tableView.register(LearningDecksTableViewCell.self, forCellReuseIdentifier: LearningDecksTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setupNavItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searcBarButtonTapped))
    }
    
    @objc
    private func searcBarButtonTapped() {
        coordinator?.browseAllDecks()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Table View Data Source
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return ((learningDecksViewModel?.decksNames.value.count ?? 0) > 0) ? 1 : 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LearningDecksTableViewCell.identifier, for: indexPath)
        if let cell = cell as? LearningDecksTableViewCell {
            learningDecksViewModel?.decksNames.observe { titles in
                cell.deckNames = titles
            }
            learningDecksViewModel?.decksCardsCounts.observe { counts in
                cell.learningCardsCount = counts
            }
            cell.didTapOnCell = { [ weak coordinator ] cell in
                guard let deckName = cell.title else { return }
                coordinator?.learnDeck(withName: deckName)
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
