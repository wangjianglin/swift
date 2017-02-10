//
//  TcpTest.swift
//  LinClient
//
//  Created by lin on 1/27/16.
//  Copyright © 2016 lin. All rights reserved.
//

import XCTest

class TcpTest: XCTestCase {

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
    }

//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measureBlock {
//            // Put the code you want to measure the time of here.
//        }
//    }
    
//    func testComm(){
//        let comm:TcpCommunicate = TcpClientCommunicate(host: "192.168.1.66", port: 7890) { (session, pack, response) -> () in
//            print("pack:\(pack)");
//        };
//        
//        let commandPack = TcpCommandDetectPackage();
//        
//        print(commandPack.command)
//        //print((Mirror(reflecting: commandPack).subjectType as! TcpCommandDetectPackage.Type).command)
//        //        print("\(LinClient.TcpCommandDetectPackage.command)");
//        //        commandPack.test()
//        comm.start();
////        let jsonPack:TcpJsonPackage = TcpJsonPackage();
////        
////        print(jsonPack.path)
////        //        jsonPack.test();
////        
////        let rpack = comm.send(jsonPack).response as! TcpJsonPackage;
////        //        rpack.header("name", value:"value");
////        print(rpack);
//    }

}
