//
//  CardViewController.swift
//  MemoryCard
//
//  Created by Zhanibek on 12.02.2021.
//

import UIKit

class CardManagerViewController: UIViewController {
    private let cardManagerViewModel: CardManagerViewModel
    
    init(cardManagerViewModel: CardManagerViewModel) {
        self.cardManagerViewModel = cardManagerViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    private let deckLabel: UILabel = {
        let label = UILabel()
        label.text = "Deck"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let deckField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.cornerRadius = 10
        return textField
    }()
    
    private let decksPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        return pickerView
    }()
    
    private let questionLabel: UILabel = {
        let label = UILabel()
        label.text = "Question"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let answerLabel: UILabel = {
        let label = UILabel()
        label.text = "Answer"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let questionField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.cornerRadius = 10
        return textField
    }()
    
    private let answerField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.cornerRadius = 10
        return textField
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue
        button.tintColor = .white
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray5
        setupSubviews()
        setupObservers()
    }
    
    private func setupSubviews() {
        [deckLabel, deckField, questionLabel, answerLabel, questionField, answerField, saveButton].forEach { view.addSubview($0) }
        
        let constraints = [
            deckLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            deckLabel.leadingAnchor.constraint(equalTo: deckField.leadingAnchor),
            deckField.topAnchor.constraint(equalTo: deckLabel.bottomAnchor, constant: 15),
            deckField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            deckField.heightAnchor.constraint(equalTo: deckField.widthAnchor, multiplier: 0.1),
            deckField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            questionLabel.topAnchor.constraint(equalTo: deckField.bottomAnchor, constant: 50),
            questionLabel.leadingAnchor.constraint(equalTo: questionField.leadingAnchor),
            questionField.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 15),
            questionField.leadingAnchor.constraint(equalTo: deckField.leadingAnchor),
            questionField.trailingAnchor.constraint(equalTo: deckField.trailingAnchor),
            questionField.heightAnchor.constraint(equalTo: questionField.widthAnchor, multiplier: 0.1),
            answerLabel.topAnchor.constraint(equalTo: questionField.bottomAnchor, constant: 50),
            answerLabel.leadingAnchor.constraint(equalTo: answerField.leadingAnchor),
            answerField.topAnchor.constraint(equalTo: answerLabel.bottomAnchor, constant: 15),
            answerField.leadingAnchor.constraint(equalTo: questionField.leadingAnchor),
            answerField.trailingAnchor.constraint(equalTo: questionField.trailingAnchor),
            answerField.heightAnchor.constraint(equalTo: questionField.heightAnchor),
            saveButton.topAnchor.constraint(equalTo: answerField.bottomAnchor, constant: 50),
            saveButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            saveButton.widthAnchor.constraint(equalTo: deckField.widthAnchor, multiplier: 0.5),
            saveButton.heightAnchor.constraint(equalToConstant: 50)
        ]
        NSLayoutConstraint.activate(constraints)
        
        setupTextFields()
        setupDecksPickerView()
        setupSaveButton()
    }
    
    private func setupTextFields() {
        deckField.text = cardManagerViewModel.deck.value
        deckField.inputView = decksPickerView
        questionField.delegate = self
        questionField.returnKeyType = .continue
        answerField.delegate = self
        answerField.returnKeyType = .done
    }
    
    private func setupDecksPickerView() {
        decksPickerView.delegate = self
        decksPickerView.dataSource = self
    }
    
    private func setupSaveButton() {
        cardManagerViewModel.buttonText.observe { [weak self] (buttonText) in
            self?.saveButton.setTitle(buttonText, for: .normal)
        }
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    @objc
    private func saveButtonTapped() {
        guard let question = questionField.text, let answer = answerField.text, let deckName = deckField.text else { return }
        cardManagerViewModel.saveCard(question: question, answer: answer, deckName: deckName)
        [deckField, questionField, answerField].forEach { $0.resignFirstResponder() }
    }
    
    private func setupObservers() {
        cardManagerViewModel.deck.observe { [weak self] in self?.deckField.text = $0 }
        cardManagerViewModel.answer.observe { [weak self] in self?.answerField.text = $0 }
        cardManagerViewModel.question.observe { [weak self] in self?.questionField.text = $0 }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Picker View Data Source
extension CardManagerViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cardManagerViewModel.allDecks.value.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return cardManagerViewModel.allDecks.value[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        deckField.text = cardManagerViewModel.allDecks.value[row]
        questionField.becomeFirstResponder()
    }
}

// MARK: - Picker View Delegate
extension CardManagerViewController: UIPickerViewDelegate {
}

// MARK: - Text Field Delegate
extension CardManagerViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == questionField {
            answerField.becomeFirstResponder()
        }
        return true
    }
}
