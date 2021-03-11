//
//  LearningDecksTableViewCell.swift
//  MemoryCard
//
//  Created by Zhanibek Sagintayev on 2021-01-26.
//

import UIKit

class LearningDecksTableViewCell: UITableViewCell {
    static let identifier = "deck-collection-view-cell"
    
    var deckNames: [String]? {
        didSet { decksCollectionView.deckNames = deckNames }
    }
    var learningCardsCount: [Int]? {
        didSet { decksCollectionView.cardsCounts = learningCardsCount }
    }
    var didTapOnCell: ((DeckCollectionViewCell) -> Void)? {
        get { decksCollectionView.didTapOnCell }
        set { decksCollectionView.didTapOnCell = newValue }
    }
    private let decksCollectionView = DecksCollectionView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        decksCollectionView.embed(in: contentView)
        decksCollectionView.clipsToBounds = false
        (decksCollectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.scrollDirection = .horizontal
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
