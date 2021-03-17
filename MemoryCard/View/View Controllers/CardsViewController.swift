//
//  CardsViewController.swift
//  MemoryCard
//
//  Created by Zhanibek Sagintayev on 2021-01-29.
//

import UIKit

class CardsViewController: UIViewController {
    
    private let cardsViewModel: CardsViewModel
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var headerView: UIView = {
        let questionLabel = getLabel()
        let answerLabel = getLabel()
        let testDateLabel = getLabel()
        
        questionLabel.text = "Question"
        answerLabel.text = "Answer"
        testDateLabel.text = "Test Date"
        
        let stackView = UIStackView(arrangedSubviews: [questionLabel, answerLabel, testDateLabel])
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
    
    init(cardsViewModel: CardsViewModel) {
        self.cardsViewModel = cardsViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    private func getLabel() -> UILabel {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title2)
        label.numberOfLines = 0
        label.textAlignment = .center
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
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableHeaderView = headerView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CardsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cardsViewModel.cardViewModels?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CardTableViewCell.identifier, for: indexPath)
        if let cardViewModel = cardsViewModel.cardViewModels?[indexPath.row], let cell = cell as? CardTableViewCell {
            cell.setViewModel(cardViewModel)
        }
        return cell
    }
}

// MARK: - Table View Delegate
extension CardsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
