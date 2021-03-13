//
//  CurvedTabBarViewController.swift
//  MemoryCard
//
//  Created by Zhanibek on 13.03.2021.
//

import UIKit

class CurvedTabBarViewController: UITabBarController {
    static let storyBoardIdentifier = "CurvedTabBarViewController"
    
    private var isCenterTabBarButtonActive = false
    
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

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        setupCenterTabBarButton()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        centerTabBarButton.layer.cornerRadius = centerTabBarButton.frame.width / 2
        centerTabBarButton.layer.shadowPath = UIBezierPath(roundedRect: centerTabBarButton.bounds, cornerRadius: centerTabBarButton.layer.cornerRadius).cgPath
    }
    
    private func setupCenterTabBarButton() {
        view.addSubview(centerTabBarButton)
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
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc
    private func centerTabBarButtonTapped() {
        rotateCenterTabBarButton()
    }
    
    private func rotateCenterTabBarButton() {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 10, initialSpringVelocity: 10, options: .curveEaseIn, animations: {
            if self.isCenterTabBarButtonActive {
                self.centerTabBarButton.imageView?.transform = .identity
            } else {
                self.centerTabBarButton.imageView?.transform = CGAffineTransform(rotationAngle: .pi * 3/4)
            }
        }) { (completed) in
            guard completed else { return }
            self.isCenterTabBarButtonActive.toggle()
        }
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
    }
}
