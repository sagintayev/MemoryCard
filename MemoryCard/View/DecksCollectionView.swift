//
//  DecksCollectionView.swift
//  MemoryCard
//
//  Created by Zhanibek on 10.03.2021.
//

import UIKit

class DecksCollectionView: UICollectionView {
    var didTapOnCell: ((DeckCollectionViewCell) -> Void)?
    
    var deckNames: [String]? {
        didSet { reloadData() }
    }
    var cardsCounts: [Int]? {
        didSet { reloadData() }
    }
    
    var cardCountColor: UIColor = .red
    
    private let layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumLineSpacing = 30
        layout.sectionInset.left = 10
        layout.sectionInset.right = 30
        return layout
    }()
    
    init() {
        super.init(frame: .zero, collectionViewLayout: layout)
        configureSelf()
        registerCell()
    }
    
    private func configureSelf() {
        dataSource = self
        delegate = self
        backgroundColor = .clear
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func registerCell() {
        register(DeckCollectionViewCell.self, forCellWithReuseIdentifier: DeckCollectionViewCell.identifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - CollectionView Data Source
extension DecksCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return deckNames?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DeckCollectionViewCell.identifier, for: indexPath)
        if let cell = cell as? DeckCollectionViewCell {
            cell.title = deckNames?[indexPath.item]
            cell.count = cardsCounts?[indexPath.item]
            cell.countColor = cardCountColor
        }
        return cell
    }
}

// MARK: Collection View Flow Layout Delegate
extension DecksCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = bounds.width / 2.4
        let height = width / 1.3
        return CGSize(width: width, height: height)
    }
}

// MARK: Collection View Delegate
extension DecksCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? DeckCollectionViewCell else { return }
        didTapOnCell?(cell)
    }
}
