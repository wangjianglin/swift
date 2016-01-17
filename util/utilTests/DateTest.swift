//
//  DateTest.swift
//  LinUtil
//
//  Created by lin on 1/12/15.
//  Copyright (c) 2015 lin. All rights reserved.
//

//import Cocoa
import XCTest

class DateTest: XCTestCase {

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
        XCTAssert(true, "Pass")
        let dateFormatter = NSDateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // superset of OP's format
        let str = dateFormatter.stringFromDate(NSDate())
        print("date:\(str)");
        print("date:\(NSDate())");
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }

}
