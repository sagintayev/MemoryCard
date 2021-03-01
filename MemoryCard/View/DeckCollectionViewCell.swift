//
//  DeckCollectionViewCell.swift
//  MemoryCard
//
//  Created by Zhanibek Sagintayev on 2021-01-26.
//

import UIKit

class DeckCollectionViewCell: UICollectionViewCell {
    static let identifier = "deck-collection-view-cell"
    
    var title: String? {
        didSet { titleLabel.text = title }
    }
    
    var count: Int? {
        didSet {
            guard let count = count else { return }
            countLabel.text = String(count)
            countLabel.layoutIfNeeded()
        }
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .title1)
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let bodyView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = .preferredFont(forTextStyle: .title1)
        label.layer.masksToBounds = true
        label.backgroundColor = UIColor.red
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .gray
        setupSubviews()
    }
    
    private func setupSubviews() {
        [titleLabel, bodyView, countLabel].forEach { contentView.addSubview($0) }
        
        let constraints = [
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bodyView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            bodyView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bodyView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bodyView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            countLabel.widthAnchor.constraint(greaterThanOrEqualTo: countLabel.heightAnchor),
            countLabel.centerXAnchor.constraint(equalTo: contentView.trailingAnchor),
            countLabel.centerYAnchor.constraint(equalTo: contentView.topAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.width / 15
        countLabel.layer.cornerRadius = countLabel.bounds.width / 2
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
