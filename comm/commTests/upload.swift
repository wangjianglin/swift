//
//  upload.swift
//  LinClient
//
//  Created by lin on 1/6/15.
//  Copyright (c) 2015 lin. All rights reserved.
//

import XCTest

class Upload : XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
//    func testExample() {
//        
//        
//        HttpCommunicate.commUrl = "http://localhost:8080/test";
//        //HttpCommunicate.commUrl = "http://localhost:8080/fcbb_b2b2c/";
//        //"http://localhost:8080/test/upload.action"
//        var package = HttpPackage(url: "/date.action",method:HttpMethod.POST);
//        
//        package["name"] = "value";
//        package["user_id"] = "中文ok.";
//        package["filename"] = "test.png";
//        
//        package["date"] = NSDate();
//        
//        HttpCommunicate.request(package, result: { (obj, warning) -> () in
//            println("ok.");
//            }, fault: { (error) -> () in
//                println("error.")
//            }).waitForEnd();
//        println("---end---");
//        
//    }

//    func testExample() {
////    
////        
////        var task = HttpTask();
////        
////        
////        HttpCommunicate.commUrl = "http://localhost:8080/test";
//        
//        HttpCommunicate.commUrl = "http://localhost:8080/fcbb_b2b2c/";
////        //"http://localhost:8080/test/upload.action"
//        var uploadPackage = HttpUploadPackage(url: "/upload.action");
//
//        uploadPackage["name"] = Json("value");
//        uploadPackage["user_id"] = Json("中文ok.");
//        uploadPackage["filename"] = Json("test.png");
////        uploadPackage["upload"] = Json(HttpUpload(fileUrl: NSURL(fileURLWithPath: "/work/1.png")!));
//        uploadPackage.addFile("upload",file:"/work/1.png");
////        uploadPackage["date"] = NSDate();
////        
//        HttpCommunicate.upload(uploadPackage, result: { (obj, warning) -> () in
//            print("ok.");
//        }, fault: { (error) -> () in
//            print("error.")
//        }) { (send, total) -> Void in
//            print("\(send)/\(total)");
//            }.waitForEnd();
//        print("---end---");
////
//    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
//        self.measureBlock() {
//            // Put the code you want to measure the time of here.
//        }
    }

}
