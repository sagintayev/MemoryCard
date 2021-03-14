//
//  CurvedTabBarViewController.swift
//  MemoryCard
//
//  Created by Zhanibek on 13.03.2021.
//

import UIKit

class CurvedTabBarViewController: UITabBarController, Coordinatable {
    static let storyBoardIdentifier = "CurvedTabBarViewController"
    
    weak var coordinator: Coordinator?
    
    private var isCenterTabBarButtonPressed = false
    
    private let centerTabBarButton: UIButton = {
        let button = UIButton()
        button.setImage(.add, for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .largeTitle)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.4
        button.layer.shadowOffset = CGSize(width: 10, height: 10)
        button.layer.shadowRadius = 10
        button.addTarget(self, action: #selector(centerTabBarButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let leftAdditionalButton: UIButton = {
        let button = UIButton()
        button.setTitle("Card", for: .normal)
        button.backgroundColor = .blue
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.4
        button.layer.shadowOffset = CGSize(width: 10, height: 10)
        button.layer.shadowRadius = 10
        button.alpha = 0
        button.addTarget(self, action: #selector(leftAdditionalButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let rightAdditionalButton: UIButton = {
        let button = UIButton()
        button.setTitle("Deck", for: .normal)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.4
        button.layer.shadowOffset = CGSize(width: 10, height: 10)
        button.layer.shadowRadius = 10
        button.backgroundColor = .blue
        button.alpha = 0
        button.addTarget(self, action: #selector(rightAdditionalButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var constraintsToShowAdditionalButtons: [NSLayoutConstraint] = {
        let verticalDistanceFromCentralButton: CGFloat = 120
        let horizontalDistanceFromCentralButton: CGFloat = 70
        return [
            leftAdditionalButton.topAnchor.constraint(equalTo: centerTabBarButton.topAnchor, constant: -verticalDistanceFromCentralButton),
            leftAdditionalButton.leadingAnchor.constraint(equalTo: centerTabBarButton.leadingAnchor, constant: -horizontalDistanceFromCentralButton),
            rightAdditionalButton.topAnchor.constraint(equalTo: centerTabBarButton.topAnchor, constant: -verticalDistanceFromCentralButton),
            rightAdditionalButton.trailingAnchor.constraint(equalTo: centerTabBarButton.trailingAnchor, constant: horizontalDistanceFromCentralButton)
        ]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        setupSubviews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        [centerTabBarButton, leftAdditionalButton, rightAdditionalButton].forEach {
            $0.layer.cornerRadius = $0.frame.width / 2
            $0.layer.shadowPath = UIBezierPath(roundedRect: centerTabBarButton.bounds, cornerRadius: $0.layer.cornerRadius).cgPath
        }
    }
    
    private func setupSubviews() {
        [centerTabBarButton, leftAdditionalButton, rightAdditionalButton].forEach {
            view.addSubview($0)
        }

        var constraints = [
            centerTabBarButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            centerTabBarButton.centerYAnchor.constraint(equalTo: view.bottomAnchor, constant: -2*tabBar.frame.height),
            centerTabBarButton.widthAnchor.constraint(equalToConstant: 80),
            centerTabBarButton.widthAnchor.constraint(greaterThanOrEqualTo: centerTabBarButton.heightAnchor),
            centerTabBarButton.heightAnchor.constraint(greaterThanOrEqualTo: centerTabBarButton.widthAnchor)
        ]
        if let centerTabBarButtonImageView = centerTabBarButton.imageView {
            centerTabBarButtonImageView.translatesAutoresizingMaskIntoConstraints = false
            constraints.append(contentsOf: [
                centerTabBarButtonImageView.heightAnchor.constraint(equalTo: centerTabBarButton.heightAnchor),
                centerTabBarButtonImageView.widthAnchor.constraint(equalTo: centerTabBarButton.widthAnchor)
            ])
        }
        [leftAdditionalButton, rightAdditionalButton].forEach {
            constraints.append(contentsOf: [
                $0.topAnchor.constraint(equalTo: centerTabBarButton.topAnchor).withPriority(999),
                $0.leadingAnchor.constraint(equalTo: centerTabBarButton.leadingAnchor).withPriority(999),
                $0.widthAnchor.constraint(equalTo: centerTabBarButton.widthAnchor),
                $0.heightAnchor.constraint(equalTo: centerTabBarButton.heightAnchor)
            ])
        }
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc
    private func centerTabBarButtonTapped() {
        rotateCenterTabBarButton { (completed) in
            guard completed else { return }
            self.isCenterTabBarButtonPressed.toggle()
            self.toggleAdditionalButtons()
        }
    }
    
    private func rotateCenterTabBarButton(completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 10, options: .curveEaseIn, animations: {
            let rotationAngle: CGFloat = self.isCenterTabBarButtonPressed ? 0 : .pi * 3/4
            self.centerTabBarButton.imageView?.transform = CGAffineTransform(rotationAngle:  rotationAngle)
        }) { (completed) in
            completion?(completed)
        }
    }
    
    private func toggleAdditionalButtons() {
        let alphaForButtons: CGFloat = isCenterTabBarButtonPressed ? 1 : 0
        
        if isCenterTabBarButtonPressed {
            NSLayoutConstraint.activate(constraintsToShowAdditionalButtons)
        } else {
            NSLayoutConstraint.deactivate(constraintsToShowAdditionalButtons)
        }
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 5, options: [.curveEaseIn]) {
            [self.leftAdditionalButton, self.rightAdditionalButton].forEach { $0.alpha = alphaForButtons }
            self.view.layoutIfNeeded()
        }
    }
    
    @objc
    private func leftAdditionalButtonTapped() {
        coordinator?.createCard()
    }
    
    @objc
    private func rightAdditionalButtonTapped() {
        
    }
}

extension CurvedTabBarViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let viewControllers = tabBarController.viewControllers else { return false }
        // prevent from selecting central tab, which is in the tab bar for spacing
        if viewControllers.firstIndex(of: viewController) == viewControllers.count / 2 {
            return false
        } else {
            return true
        }
    }
}

extension CurvedTabBarViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        centerTabBarButton.isHidden = viewController.hidesBottomBarWhenPushed
        if isCenterTabBarButtonPressed {
            leftAdditionalButton.alpha = 0
            rightAdditionalButton.alpha = 0
            centerTabBarButtonTapped()
        }
    }
}
