//
//  Observable.swift
//  MemoryCard
//
//  Created by Zhanibek Sagintayev on 2021-02-03.
//

import Foundation

final class Observable<T> {
    var value: T {
        didSet { valueDidChange?(value) }
    }
    
    var valueDidChange: ((T) -> Void)?
    
    init(_ value: T) {
        self.value = value
    }
}
