//
//  CardsViewController.swift
//  MemoryCard
//
//  Created by Zhanibek Sagintayev on 2021-01-29.
//

import UIKit

class CardsViewController: UIViewController {
    var deck: Deck
    
    private lazy var tableViewDataSource = CardsFetchedResultsDataSource(tableView: tableView, deck: deck)
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemGray4
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var headerView: UIView = {
        let questionLabel = getLabel()
        let answerLabel = getLabel()
        questionLabel.text = "Question"
        answerLabel.text = "Answer"
        
        let stackView = UIStackView(arrangedSubviews: [questionLabel, answerLabel])
        stackView.alignment = .top
        stackView.spacing = .zero
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let size = stackView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        let headerView = UIView(frame: CGRect(origin: CGPoint(), size: size))
        stackView.embed(in: headerView)
        return headerView
    }()
    
    init(deck: Deck) {
        self.deck = deck
        super.init(nibName: nil, bundle: nil)
    }
    
    private func getLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
    }
    
    private func setupSubviews() {
        tableView.embed(in: view)
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.register(CardTableViewCell.self, forCellReuseIdentifier: CardTableViewCell.identifier)
        tableView.dataSource = tableViewDataSource
        tableView.delegate = self
        tableView.tableHeaderView = headerView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Table View Delegate
extension CardsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
