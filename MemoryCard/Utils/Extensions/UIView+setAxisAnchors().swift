//
//  UIView+setAxisAnchors().swift
//  MemoryCard
//
//  Created by Zhanibek on 14.03.2021.
//

import UIKit

extension UIView {
    func setAxisAnchors(to view: UIView, useSafeArea: Bool = true, top: CGFloat? = nil, leading: CGFloat? = nil, trailing: CGFloat? = nil, bottom: CGFloat? = nil) {
        
        
        let superTopAnchor, superBottomAnchor: NSLayoutYAxisAnchor
        let superLeadingAnchor, superTrailingAnchor: NSLayoutXAxisAnchor
        
        if useSafeArea {
            superTopAnchor = view.safeAreaLayoutGuide.topAnchor
            superLeadingAnchor = view.safeAreaLayoutGuide.leadingAnchor
            superTrailingAnchor = view.safeAreaLayoutGuide.trailingAnchor
            superBottomAnchor = view.safeAreaLayoutGuide.bottomAnchor
        } else {
            superTopAnchor = view.topAnchor
            superLeadingAnchor = view.leadingAnchor
            superTrailingAnchor = view.trailingAnchor
            superBottomAnchor = view.bottomAnchor
        }
        
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superTopAnchor, constant: top ?? 0),
            leadingAnchor.constraint(equalTo: superLeadingAnchor, constant: leading ?? 0),
            trailingAnchor.constraint(equalTo: superTrailingAnchor, constant: trailing ?? 0),
            bottomAnchor.constraint(equalTo: superBottomAnchor, constant: bottom ?? 0)
        ])
    }
}
