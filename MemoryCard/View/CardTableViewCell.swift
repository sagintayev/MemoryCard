//
//  CardTableViewCell.swift
//  MemoryCard
//
//  Created by Zhanibek Sagintayev on 2021-01-29.
//

import UIKit

class CardTableViewCell: UITableViewCell {
    static let identifier = "card-table-view-cell"
    
    private var cardViewModel: CardViewModel! {
        didSet { setObservers() }
    }
    
    private lazy var questionLabel: UILabel = getLabel()
    private lazy var answerLabel: UILabel = getLabel()
    private lazy var testDateLabel: UILabel = getLabel()
    
    private lazy var labelsStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [questionLabel, answerLabel, testDateLabel])
        stackView.alignment = .top
        stackView.spacing = .zero
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
        backgroundColor = .clear
    }
    
    override func prepareForReuse() {
        cardViewModel.removeObservers()
    }
    
    func setViewModel(_ cardViewModel: CardViewModel) {
        self.cardViewModel = cardViewModel
    }
    
    private func setObservers() {
        cardViewModel.testDate.observe { [weak self] (testDate) in
            self?.testDateLabel.text = testDate
        }
        cardViewModel.answer.observe { [weak self] (answer) in
            self?.answerLabel.text = answer
        }
        cardViewModel.question.observe { [weak self] (question) in
            self?.questionLabel.text = question
        }
    }
    
    private func getLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.systemGray3.cgColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func setupSubviews() {
        labelsStack.embed(in: contentView)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
