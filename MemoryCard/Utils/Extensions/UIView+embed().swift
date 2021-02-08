//
//  UIView+embedIn.swift
//  MemoryCard
//
//  Created by Zhanibek Sagintayev on 2021-01-29.
//

import UIKit

extension UIView {
    func embed(in superView: UIView, useSafeArea: Bool = true, top: CGFloat? = nil, leading: CGFloat? = nil, trailing: CGFloat? = nil, bottom: CGFloat? = nil) {
        superView.addSubview(self)
        
        let superTopAnchor, superBottomAnchor: NSLayoutYAxisAnchor
        let superLeadingAnchor, superTrailingAnchor: NSLayoutXAxisAnchor
        
        if useSafeArea {
            superTopAnchor = superView.safeAreaLayoutGuide.topAnchor
            superLeadingAnchor = superView.safeAreaLayoutGuide.leadingAnchor
            superTrailingAnchor = superView.safeAreaLayoutGuide.trailingAnchor
            superBottomAnchor = superView.safeAreaLayoutGuide.bottomAnchor
        } else {
            superTopAnchor = superView.topAnchor
            superLeadingAnchor = superView.leadingAnchor
            superTrailingAnchor = superView.trailingAnchor
            superBottomAnchor = superView.bottomAnchor
        }
        
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superTopAnchor, constant: top ?? 0),
            leadingAnchor.constraint(equalTo: superLeadingAnchor, constant: leading ?? 0),
            trailingAnchor.constraint(equalTo: superTrailingAnchor, constant: trailing ?? 0),
            bottomAnchor.constraint(equalTo: superBottomAnchor, constant: bottom ?? 0)
        ])
    }
}
