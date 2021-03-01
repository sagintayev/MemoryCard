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
    var frontText: String? {
        didSet {
            frontLabel.text = frontText
        }
    }
    var backText: String? {
        didSet {
            backLabel.text = backText
        }
    }
    
    var didFlip: (() -> Void)?
    
    private lazy var frontLabel: UILabel = getLabel()
    private lazy var backLabel: UILabel = getLabel()
    
    private var side: CardViewSide
    
    init() {
        side = .front
        super.init(frame: .zero)
        setupSubviews()
    }
    
    func show(_ side: CardViewSide, animated: Bool) {
        let (viewToShow, viewToHide) = (side == .front) ? (frontLabel, backLabel) : (backLabel, frontLabel)
        guard viewToShow.isHidden else { return }
        if animated {
            flip()
        } else {
            viewToShow.isHidden = false
            viewToHide.isHidden = true
        }
    }
    
    func flip(options: UIView.AnimationOptions = [.transitionFlipFromLeft, .showHideTransitionViews]) {
        let fromView = frontLabel.isHidden ? backLabel : frontLabel
        let toView = frontLabel.isHidden ? frontLabel : backLabel
        UIView.transition(from: fromView, to: toView, duration: 0.5, options: options, completion: { [weak self] _ in
            self?.didFlip?()
        })
    }
    
    private let leftView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let rightView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private func getLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func setupSubviews() {
        backLabel.isHidden = true
        leftView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTap)))
        rightView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTap)))
        
        [frontLabel, backLabel, leftView, rightView].forEach {
            addSubview($0)
        }
        
        [frontLabel, backLabel].forEach { label in
            addSubview(label)
            NSLayoutConstraint.activate([
                label.centerYAnchor.constraint(equalTo: centerYAnchor),
                label.centerXAnchor.constraint(equalTo: centerXAnchor),
                label.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
                label.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.9)
            ])
        }
        
        NSLayoutConstraint.activate([
            leftView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            leftView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            leftView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            leftView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.5),
            rightView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            rightView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            rightView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            rightView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.5)
        ])
    }
    
    @objc
    private func didTap(_ recognizer: UIGestureRecognizer) {
        let transitionSide: UIView.AnimationOptions = (recognizer.view === leftView) ? .transitionFlipFromRight : .transitionFlipFromLeft
        flip(options: [transitionSide, .showHideTransitionViews])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
