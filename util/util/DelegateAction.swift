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

private var DelegateActionThreadPredicate:Int = 0;

@objc
open class DelegateAction :NSObject {
    
    fileprivate static var __once: () = {

            let threadAction = EventDelegateAction(threadAction: { (obj:AnyObject) -> () in

                while true {

                    DelegateAction.resetObj();
                    Thread.sleep(forTimeInterval: 2);

                }
            });

            let thread = Thread(target: threadAction, selector: #selector(EventDelegateAction.action(_:)), object: nil);

            thread.name = "delegate action thread";

            thread.start();

        }()

    

    fileprivate class func resetObj(){
        
        if delegateActionItems.count < 1 {
            return;
        }
        lock.lock()
        if delegateActionItems.count > 0 {
            var array = [Int]();
            for (index,item) in delegateActionItems.enumerated() {
                if item.withObjectSameLifecycle == nil {
                    array.append(index);
                }
            }
            //for var index = array.count - 1 ; index >= 0 ;index -= 1 {
            for index in array.count-1 ... 0 {
                delegateActionItems.remove(at: array[index]);
            }
        }
        lock.unlock();
    }
    
    fileprivate var isWithObjectSameLifecycle = false;
    
    open weak var withObjectSameLifecycle:AnyObject? {
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
    
    fileprivate init(threadAction:@escaping((AnyObject)->())){
        //self.delegateAction = threadAction;
        super.init();
    }
    public override init(){
        super.init();
            
        _ = DelegateAction.__once
    }
    
    open func actionForObjectExist(_ action:(()->())){
        if isWithObjectSameLifecycle == false {
            action();
        }
        
        let tmp = self.withObjectSameLifecycle;
        if let tmp = tmp {
            action();
        }
    }
}

open class EventDelegateAction : DelegateAction{
    
    fileprivate override init(threadAction: @escaping ((AnyObject)->())){
        self.delegateAction = threadAction;
        super.init(threadAction:threadAction);
    }
    
    public init(action:@escaping ((AnyObject)->())){
        self.delegateAction = action;
        super.init();
    }
    fileprivate var delegateAction:((AnyObject)->());
    
    open func action(_ send:AnyObject){
        let tmp: AnyObject? = self.withObjectSameLifecycle;
        if isWithObjectSameLifecycle == false || tmp != nil {
            delegateAction(send);
        }
    }
}
