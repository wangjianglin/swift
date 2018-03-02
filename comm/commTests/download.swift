//
//  download.swift
//  LinComm
//
//  Created by lin on 17/10/2016.
//  Copyright © 2016 lin. All rights reserved.
//

import Foundation


//http://www.feicuibaba.com/data.zip

import XCTest
import CessComm

class Download : XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func down() {
        print("ok.");
        
        HttpCommunicate.download("http://www.feicuibaba.com/data2.zip").waitForEnd();
    }
}
