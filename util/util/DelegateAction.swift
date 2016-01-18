//
//  DeleteAction.swift
//  LinCore
//
//  Created by lin on 1/21/15.
//  Copyright (c) 2015 lin. All rights reserved.
//

import Foundation


private var delegateActionItems:[DelegateAction] = [DelegateAction]();
private var lock = NSLock();

private var DelegateActionThreadPredicate:dispatch_once_t = 0;

@objc
public class DelegateAction :NSObject {
    
    private class func resetObj(){
        
        if delegateActionItems.count < 1 {
            return;
        }
        lock.lock()
        if delegateActionItems.count > 0 {
            var array = [Int]();
            for (index,item) in delegateActionItems.enumerate() {
                if item.withObjectSameLifecycle == nil {
                    array.append(index);
                }
            }
            for var index = array.count - 1 ; index >= 0 ;index-- {
                delegateActionItems.removeAtIndex(array[index]);
            }
        }
        lock.unlock();
    }
    
    private var isWithObjectSameLifecycle = false;
    
    public weak var withObjectSameLifecycle:AnyObject? {
        didSet{
        
            if withObjectSameLifecycle != nil {
                if isWithObjectSameLifecycle == false {
                    lock.lock()
                    delegateActionItems.append(self);
                    lock.unlock();
                }
                isWithObjectSameLifecycle = true;
            }else{
                if isWithObjectSameLifecycle {
                    DelegateAction.resetObj();
                }
                isWithObjectSameLifecycle = false;
            }
        }
    }
    
    private init(threadAction:((AnyObject)->())){
        //self.delegateAction = threadAction;
        super.init();
    }
    public override init(){
        super.init();
            
        dispatch_once(&DelegateActionThreadPredicate,{
            
            let threadAction = EventDelegateAction(threadAction: { (obj:AnyObject) -> () in
                while true {
                    DelegateAction.resetObj();
                
                    NSThread.sleepForTimeInterval(2);
                }
                
            });
            let thread = NSThread(target: threadAction, selector: "action:", object: nil);
            thread.name = "delegate action thread";
            thread.start();
        })
    }
    
    public func actionForObjectExist(action:(()->())){
        let tmp: AnyObject? = self.withObjectSameLifecycle;
        if isWithObjectSameLifecycle == false || tmp != nil {
            action();
        }
    }
}

public class EventDelegateAction : DelegateAction{
    
    private override init(threadAction:((AnyObject)->())){
        self.delegateAction = threadAction;
        super.init(threadAction:threadAction);
    }
    
    public init(action:((AnyObject)->())){
        self.delegateAction = action;
        super.init();
    }
    private var delegateAction:((AnyObject)->());
    
    public func action(send:AnyObject){
        let tmp: AnyObject? = self.withObjectSameLifecycle;
        if isWithObjectSameLifecycle == false || tmp != nil {
            delegateAction(send);
        }
    }
}