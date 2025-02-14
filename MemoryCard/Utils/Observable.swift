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
    
    var isObserved: Bool {
        valueDidChange != nil
    }
    
    private var valueDidChange: ((T) -> Void)?
    
    init(_ value: T) {
        self.value = value
    }
    
    func observe(_ observeHandler: @escaping (T) -> Void) {
        valueDidChange = observeHandler
        valueDidChange?(value)
    }
    
    func removeObserver() {
        valueDidChange = nil
    }
}
