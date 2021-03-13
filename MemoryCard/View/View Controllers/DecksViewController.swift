//
//  DecksViewController.swift
//  MemoryCard
//
//  Created by Zhanibek on 10.03.2021.
//

import UIKit

class DecksViewController: UIViewController {
    private let decksViewModel: DecksViewModel
    private let decksCollectionView = DecksCollectionView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray5
        setupCollectionView()
        setObservers()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        decksViewModel.removeObservers()
    }
    
    init(decksViewModel: DecksViewModel) {
        self.decksViewModel = decksViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    private func setupCollectionView() {
        decksCollectionView.embed(in: view, useSafeArea: false)
        decksCollectionView.contentInset.top = 50
        decksCollectionView.cardCountColor = .lightGray
    }
    
    private func setObservers() {
        decksViewModel.decksCardsCounts.observe { [weak decksCollectionView] (counts) in
            decksCollectionView?.cardsCounts = counts
        }
        decksViewModel.decksNames.observe { [weak decksCollectionView] (names) in
            decksCollectionView?.deckNames = names
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
