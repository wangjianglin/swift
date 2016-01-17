//
//  utilTests.swift
//  utilTests
//
//  Created by lin on 11/27/14.
//  Copyright (c) 2014 lin. All rights reserved.
//

import UIKit
import XCTest
import LinUtil


infix operator => { associativity left precedence 95 }
func => <A,R> (lhs:A, rhs:A->R)->R {
    return rhs(lhs)
}

public class MyJSON2 : Json {
    //var v:Dictionary<String,AnyObject>;// = Dictionary<String,AnyObject>();
    
        override init(isArray:Bool = false){
    ////        self.v = Dictionary<String,AnyObject>();
    ////
            super.init(isArray:false)
        }
    //    override init(_ json:JSON)  { super.init(json) }
    
    public var test:String?{
        get{return self["test"].asString;}
        set{ self["test"] = Json(newValue!);}
    }
    //    var null  :NSNull? { return self["null"].asNull }
    //    var bool  :Bool?   { return self["bool"].asBool }
    //    var int   :Int?    { return self["int"].asInt }
    //    var double:Double? { return self["double"].asDouble }
    //    var string:String? { return self["string"].asString }
    //    var url:   String? { return self["url"].asString }
    //    var array :MyJSON  { return MyJSON(self["array"])  }
    //    var object:MyJSON  { return MyJSON(self["object"]) }
}

class utilTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testJson() {
        // This is an example of a functional test case.
        //XCTAssert(true, "Pass")
        
//        println("ok.")
//        
//        //jsontest();
//        
//        
//        class TestClass {
//            
//        }
//        
//        
//        
//        var v = Dictionary<String,AnyObject>();
        var json = MyJSON2();
        //json["a"] = JSON("a");
        //json.test = "test";
        
        var json2 = MyJSON2();
        json2["b"] = Json("b");
        
        json["j2"] = json2;
        
        var json3 = [MyJSON2]();
        json3.append(json2);
        json3.append(json2);
        
//        (json3 is NSArray) => println;
        print(json3.count) ;
        
        var t = Json(json3);
        json["j3"] = Json(t);
//        json["a"] => println;//.string{ return "a";};
//        
//        
//        
//        
        print(json.toString())
       
        print(json.toParams());

    }
    
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measureBlock() {
//            // Put the code you want to measure the time of here.
//            var set:JSON?;
//        }
//    }
    
}
