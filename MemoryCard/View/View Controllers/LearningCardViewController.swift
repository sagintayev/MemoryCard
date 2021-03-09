//
//  LearningCardViewController.swift
//  MemoryCard
//
//  Created by Zhanibek on 22.02.2021.
//

import UIKit

class LearningCardViewController: UIViewController {
    
    weak var coordinator: Coordinator?
    var learningCardViewModel: LearningCardViewModel
    
    init(viewModel: LearningCardViewModel) {
        learningCardViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    private let progressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let finishedLabel: UILabel = {
        let label = UILabel()
        label.text = "Congratulations! You finished!"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let finishedButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue
        button.setTitle("Go home", for: .normal)
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(finishedButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let cardView: CardView = {
        let cardView = CardView()
        cardView.backgroundColor = .systemGray2
        cardView.layer.cornerRadius = 15
        cardView.translatesAutoresizingMaskIntoConstraints = false
        return cardView
    }()
    
    private let showAnswerButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue
        button.setTitle("Show answer", for: .normal)
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(showAnswerButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let answerButton1: UIButton = {
        let button = UIButton()
        button.backgroundColor = .green
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.titleLabel?.textAlignment = .center
        button.layer.cornerRadius = 15
        button.tag = 0
        button.addTarget(self, action: #selector(answerButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let answerButton2: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.titleLabel?.textAlignment = .center
        button.layer.cornerRadius = 15
        button.tag = 1
        button.addTarget(self, action: #selector(answerButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let answerButton3: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.titleLabel?.textAlignment = .center
        button.layer.cornerRadius = 15
        button.tag = 2
        button.addTarget(self, action: #selector(answerButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let answerButton4: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.titleLabel?.textAlignment = .center
        button.layer.cornerRadius = 15
        button.tag = 3
        button.addTarget(self, action: #selector(answerButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let answerButtons: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray5
        setupSubviews()
        setupObservers()
    }

    private func setupSubviews() {
        cardView.didFlip = { [weak self] in
            self?.learningCardViewModel.answerWasShown.value = true
        }
        
        [answerButton1, answerButton2, answerButton3, answerButton4].forEach {
            answerButtons.addArrangedSubview($0)
        }
        
        [progressLabel, cardView, showAnswerButton, answerButtons, finishedLabel, finishedButton].forEach {
            view.addSubview($0)
        }
        
        let constraints = [
            progressLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            progressLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            cardView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            cardView.centerXAnchor.constraint(equalTo: view.centerXAnchor).withPriority(999),
            cardView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            cardView.heightAnchor.constraint(greaterThanOrEqualTo: view.heightAnchor, multiplier: 0.3),
            cardView.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor, multiplier: 0.8),
            
            showAnswerButton.topAnchor.constraint(greaterThanOrEqualTo: cardView.bottomAnchor, constant: 20),
            showAnswerButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            showAnswerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            showAnswerButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4),
            showAnswerButton.heightAnchor.constraint(equalTo: showAnswerButton.widthAnchor, multiplier: 0.5),
            
            answerButtons.topAnchor.constraint(equalTo: showAnswerButton.topAnchor),
            answerButtons.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            answerButtons.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.95),
            answerButtons.heightAnchor.constraint(equalTo: showAnswerButton.heightAnchor),
            
            finishedLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            finishedLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            finishedLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            finishedButton.topAnchor.constraint(equalTo: finishedLabel.bottomAnchor, constant: 30),
            finishedButton.widthAnchor.constraint(equalTo: showAnswerButton.widthAnchor),
            finishedButton.heightAnchor.constraint(equalTo: showAnswerButton.heightAnchor),
            finishedButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupObservers() {
        learningCardViewModel.progressText.observe { [weak self] (progressText) in
            guard let self = self else { return }
            self.progressLabel.text = progressText
        }
        learningCardViewModel.answerWasShown.observe { [weak self] (answerWasShown) in
            guard let self = self else { return }
            self.showAnswerButton.isHidden = answerWasShown
            self.answerButtons.isHidden = !answerWasShown
        }
        learningCardViewModel.answer.observe { [weak self] (answer) in
            guard let self = self else { return }
            self.cardView.backText = answer
        }
        learningCardViewModel.question.observe { [weak self] (question) in
            guard let self = self else { return }
            self.cardView.frontText = question
        }
        learningCardViewModel.answerButtons.observe { [weak self] (buttons) in
            guard let self = self else { return }
            let isFewButtons = (buttons.count == 2)
            self.answerButton3.isHidden = isFewButtons
            self.answerButton4.isHidden = isFewButtons
            self.answerButton1.setTitle(buttons[0], for: .normal)
            self.answerButton2.setTitle(buttons[1], for: .normal)
            if !isFewButtons {
                self.answerButton3.setTitle(buttons[2], for: .normal)
                self.answerButton4.setTitle(buttons[3], for: .normal)
            }
        }
        learningCardViewModel.isFinished.observe { [weak self] (finished) in
            guard let self = self else { return }
            self.progressLabel.isHidden = finished
            self.cardView.isHidden = finished
            self.showAnswerButton.isHidden = finished
            self.finishedLabel.isHidden = !finished
            self.finishedButton.isHidden = !finished
            if finished {
                self.answerButtons.isHidden = true
            }
        }
        learningCardViewModel.isNextCardShown.observe { [weak self] _ in
            self?.cardView.show(.front, animated: false)
        }
    }
    
    @objc
    private func showAnswerButtonTapped() {
        cardView.flip()
    }
    
    @objc
    private func answerButtonTapped(_ sender: UIButton) {
        learningCardViewModel.answerCard(buttonIndex: sender.tag)
    }
    
    @objc
    private func finishedButtonTapped() {
        coordinator?.backHome()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
