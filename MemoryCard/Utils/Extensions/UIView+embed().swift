//
//  UIView+embedIn.swift
//  MemoryCard
//
//  Created by Zhanibek Sagintayev on 2021-01-29.
//

import UIKit

extension UIView {
    func embed(in view: UIView, useSafeArea: Bool = true, top: CGFloat? = nil, leading: CGFloat? = nil, trailing: CGFloat? = nil, bottom: CGFloat? = nil) {
        view.addSubview(self)
        
        setAxisAnchors(to: view, useSafeArea: useSafeArea, top: top, leading: leading, trailing: trailing, bottom: bottom)
    }
}
