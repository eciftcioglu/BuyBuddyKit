//
//  BuyBuddyKit_iOS_Tests.swift
//  BuyBuddyKit iOS Tests
//
//  Created by Buğra Ekuklu on 25.02.2017.
//
//

import BuyBuddyKit
import XCTest

class SimpleTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        XCTAssert(BuyBuddyKit.fn(), true)
    }
}
