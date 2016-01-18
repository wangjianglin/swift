//
//  clientTests.swift
//  clientTests
//
//  Created by lin on 11/27/14.
//  Copyright (c) 2014 lin. All rights reserved.
//

import UIKit
import XCTest
import LinClient
import Foundation

//class clientTests: XCTestCase {
//    
//    override func setUp() {
//        super.setUp()
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//    }
//    
//    override func tearDown() {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//        super.tearDown()
//    }
//    
//    func testHttp(){
////        var request = HttpTask()
////        request.GET("http://www.baidu.com", parameters: nil, success: {(response: HttpResponse) in
////            if response.responseObject != nil {
////                let data = response.responseObject as NSData
////                let str = NSString(data: data, encoding: NSUTF8StringEncoding)
////                println("response: \(str)") //prints the HTML of the page
////            }
////            },failure: {(error: NSError?,response: HttpResponse?) in
////                println("error: \(error)")
////        })
//
////        var params = Dictionary<String,AnyObject>();
////        params["data"] = "测试中文！";
////        //params["data"] = "data";
////        request.POST("http://192.168.1.8:8080/lin.demo/core/comm/test.action", parameters: params, success: {(response: HttpResponse) in
////            if response.responseObject != nil {
////                let data = response.responseObject as NSData
////                let str = NSString(data: data, encoding: NSUTF8StringEncoding)
////                println("response: \(str)") //prints the HTML of the page
////            }
////            },failure: {(error: NSError?,response: HttpResponse?) in
////                println("error: \(error)")
////        })
//        
////        var pack = HttpTestPackage();
////        pack.data = "测试中文！";
////        HttpCommunicate.request(pack,result:{(obj:AnyObject,warning:[HttpError]) in
////            println("obj:\(obj)");
////            },fault:{(error:HttpError) in
////                println("error.");
////        }).waitForEnd();
//        
////        var spack = HttpSessionIdPackage();
////        for _ in 1...11{
////            HttpCommunicate.request(spack,result:{(obj:AnyObject,warning:[HttpError]) in
////                println("obj:\(obj)");
////                },fault:{(error:HttpError) in
////                    println("error.");
////            }).waitForEnd();
////        }
////        
////        HttpCommunicate.install["test"].request(spack,result:{(obj:AnyObject,warning:[HttpError]) in
////            println("obj:\(obj)");
////            },fault:{(error:HttpError) in
////                println("error.");
////        }).waitForEnd();
////        
////        var s = "3333333";
////        println(s)
////        println("---end---")
//        //NSThread.sleepForTimeInterval(NSTimeInterval(5));
//    }
//    
////    func testExample() {
////        // This is an example of a functional test case.
////        XCTAssert(true, "Pass")
////    }
////    
////    func testPerformanceExample() {
////        // This is an example of a performance test case.
////        self.measureBlock() {
////            // Put the code you want to measure the time of here.
////        }
////    }
//    
//}
