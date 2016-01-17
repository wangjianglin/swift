//
//  Queue.swift
//  LinCore
//
//  Created by lin on 1/27/15.
//  Copyright (c) 2015 lin. All rights reserved.
//

import Foundation


public class AsynOperation : NSOperation{
 
    private var action:(()->());
    private init(action:(()->())){
        self.action = action;
    }
    public override func main() {
        self.action();
    }
}
public class Queue{
    
    
    private class var asynQueue:NSOperationQueue{
        struct YRSingleton{
            static var predicate:dispatch_once_t = 0
            static var instance:NSOperationQueue? = nil
        }
        dispatch_once(&YRSingleton.predicate,{
            YRSingleton.instance = NSOperationQueue();
            YRSingleton.instance!.maxConcurrentOperationCount = 10;
        })
        return YRSingleton.instance!
    }
    
    
    public class func mainQueue(action:(()->())){
        dispatch_async(dispatch_get_main_queue(), {() in
            action();
        });
    }
    public class func asynQueue(action:(()->())){
        let operation = AsynOperation(action: action);
        Queue.asynQueue.addOperation(operation);
    }
    public class func asynThread(action:(()->())){
//        var operation = AsynOperation(action: action);
//        Queue.asynQueue.addOperation(operation);
//        init(target: AnyObject, selector: Selector, object argument: AnyObject?)
        let delegate = EventDelegateAction(action:{(_:AnyObject) in
            action();
        });
        let thread = NSThread(target:delegate,selector:"action:",object:nil);
//        thread.name = "upload log thread";
        thread.start();
    }
}