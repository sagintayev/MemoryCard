//
//  CardTableViewCell.swift
//  MemoryCard
//
//  Created by Zhanibek Sagintayev on 2021-01-29.
//

import UIKit

class CardTableViewCell: UITableViewCell {
    static let identifier = "card-table-view-cell"
    
    private var cardViewModel: CardViewModel!
    
    private lazy var questionLabel: UILabel = getLabel()
    private lazy var answerLabel: UILabel = getLabel()
    private lazy var labelsStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [questionLabel, answerLabel])
        stackView.alignment = .top
        stackView.spacing = .zero
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    func setViewModel(_ cardViewModel: CardViewModel) {
        self.cardViewModel = cardViewModel
        self.answerLabel.text = cardViewModel.answer.value
        self.questionLabel.text = cardViewModel.question.value
        cardViewModel.answer.valueDidChange = { value in
            self.answerLabel.text = value
        }
        cardViewModel.question.valueDidChange = { value in
            self.questionLabel.text = value
        }
    }
    
    override func prepareForReuse() {
        cardViewModel.answer.valueDidChange = nil
        cardViewModel.question.valueDidChange = nil
    }
    
    private func getLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }
    
    private func setupSubviews() {
        labelsStack.embed(in: contentView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
