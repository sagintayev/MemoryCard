//
//  CardView.swift
//  MemoryCard
//
//  Created by Zhanibek Sagintayev on 2021-02-03.
//

import UIKit

enum CardViewSide {
    case front
    case back
}

class CardView: UIView {
    private lazy var frontLabel: UILabel = getLabel()
    private lazy var backLabel: UILabel = getLabel()
    
    private var side: CardViewSide = .front
    
    init() {
        super.init(frame: .zero)
        turnOn(.front)
        setupSubviews()
    }
    
    func turnOn(_ side: CardViewSide) {
        self.side = side
        sideDidChange()
    }
    
    private func getLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func setupSubviews() {
        [frontLabel, backLabel].forEach { addSubview($0) }
        
        let constraints = [
            frontLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            frontLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            frontLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
            backLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            backLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            backLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    private func sideDidChange() {
        switch side {
        case .front:
            frontLabel.isHidden = false
            backLabel.isHidden = true
        case .back:
            frontLabel.isHidden = true
            backLabel.isHidden = false
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
