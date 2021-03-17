//
//  ObservableTestCase.swift
//  MemoryCardTests
//
//  Created by Zhanibek on 17.03.2021.
//

import XCTest
@testable import MemoryCard

class ObservableTestCase: XCTestCase {
    var sut: Observable<String>!

    override func setUp() {
        sut = Observable("")
    }

    override func tearDown() {
        sut = nil
    }
    
    func testInitialState() {
        XCTAssertFalse(sut.isObserved)
    }
    
    func testObserve() {
        var observer = ""
        sut.observe { value in
            observer = value
        }
        
        let newValue = "newValue"
        sut.value = newValue
        
        XCTAssertTrue(sut.isObserved)
        XCTAssertEqual(observer, newValue)
    }
    
    func testRemoveObserver() {
        var observer = ""
        sut.observe { value in
            observer = value
        }
        
        sut.removeObserver()
        sut.value = "New value"
        
        XCTAssertFalse(sut.isObserved)
        XCTAssertEqual(observer, "")
    }
}
