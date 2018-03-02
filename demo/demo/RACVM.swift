//
//  RACVM.swift
//  demo
//
//  Created by lin on 10/11/2016.
//  Copyright © 2016 lin. All rights reserved.
//

import Foundation
import ReactiveCocoa
import ReactiveSwift
import Result
import CessUtil
import CessComm
import CessRac

//1、数据双向绑定，text、lable、table
//2、button  执行命令，带进度条
//3、加载http数据，与httpcomm结合



public class RACVM :NSObject,ViewModel {
    
    public typealias ViewType = RACViewController2;
    
    public override init() {
        print("vm init..")
    }
    
    public func start() {
    }

    
    @objc public dynamic var text = "label text!";
    
//    @discardableResult
//    static func <~ <Source: SignalProtocol>(target: RACVM, signal: Source) -> Disposable?{
//        return nil;
//    }
    
    public func test(_ v:Int,_ complete:@escaping (Any?)->()){
        
        print("************\(v)");
        print(self.text)
        HttpCommunicate.mainThread = false;
        //        Queue.asynThread {
        //            Thread.sleep(forTimeInterval: 2);
        //            comple(nil);
        let pack = TestPackage();
        pack.data = "test,data";
        
        
        complete <~ HttpCommunicate.request(pack, result: { (obj, warning) in
//            self.text = "\(obj!)";
            print(obj)
        },fault: {error in
            print(error)
        })
        //        }
    }
    
    public func test(_ complete:@escaping (Any?)->()){
        
        print("************");
        print(self.text)
        HttpCommunicate.mainThread = false;
        //        Queue.asynThread {
        //            Thread.sleep(forTimeInterval: 2);
        //            comple(nil);
        let pack = TestPackage();
        pack.data = "test,data";
        complete <~ HttpCommunicate.request(pack, result: { (obj, warning) in
//            self.text = "\(obj!)";
//            print(self.text)
        })
        //        }
    }
    
    
    
    public func test2(){
        
        print(self.text)
    }
    
    public func test3(){
        
        print("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$");
        print(self.text)
    }
    
    deinit {
        print("deinit vm...");
    }
}
