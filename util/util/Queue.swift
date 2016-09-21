//
//  Queue.swift
//  LinCore
//
//  Created by lin on 1/27/15.
//  Copyright (c) 2015 lin. All rights reserved.
//

import Foundation


open class AsynOperation : Operation{
 
    fileprivate var action:(()->());
    fileprivate init(action:@escaping (()->())){
        self.action = action;
    }
    open override func main() {
        self.action();
    }
}
open class Queue{
    
    struct YRSingleton{
        static var predicate:Int = 0
        static var instance:OperationQueue? = nil
    }
 
    fileprivate static var __once: () = {

            YRSingleton.instance = OperationQueue();

            YRSingleton.instance!.maxConcurrentOperationCount = 10;

        }()

    

    fileprivate var _queue:OperationQueue;
    public init(count:Int = 5){
        _queue = OperationQueue();
        _queue.maxConcurrentOperationCount = count;
    }
    
    open func asynQueue(_ action:@escaping (()->())){
        let operation = AsynOperation(action: action);
        _queue.addOperation(operation);
    }
    
    fileprivate class var asynQueue:OperationQueue{
        
        _ = Queue.__once
        //dispatch_once(&YRSingleton.predicate,{
        //    YRSingleton.instance = NSOperationQueue();
        //    YRSingleton.instance!.maxConcurrentOperationCount = 10;
        //})
        return YRSingleton.instance!
    }
    
    
    open class func mainQueue(_ action:@escaping (()->())){
        DispatchQueue.main.async(execute: {() in
            action();
        });
    }
    open class func asynQueue(_ action:@escaping (()->())){
        let operation = AsynOperation(action: action);
        Queue.asynQueue.addOperation(operation);
    }
    open class func asynThread(_ action:@escaping (()->())){
//        var operation = AsynOperation(action: action);
//        Queue.asynQueue.addOperation(operation);
//        init(target: AnyObject, selector: Selector, object argument: AnyObject?)
        let delegate = EventDelegateAction(action:{(_:AnyObject) in
            action();
        });
        let thread = Thread(target:delegate,selector:Selector("action:"),object:nil);
//        thread.name = "upload log thread";
        thread.start();
    }
}
