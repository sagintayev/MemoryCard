//
//  NSLayoutConstraint+withPriority().swift
//  MemoryCard
//
//  Created by Zhanibek on 22.02.2021.
//

import UIKit

extension NSLayoutConstraint {
    func withPriority(_ priority: Float) -> NSLayoutConstraint {
        self.priority = UILayoutPriority(priority)
        return self
    }
}
