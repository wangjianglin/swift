//
//  AutoResetEvent.swift
//  LinUtil
//
//  Created by lin on 12/2/14.
//  Copyright (c) 2014 lin. All rights reserved.
//

import Foundation


open class AutoResetEvent {
    
    fileprivate var lock:NSCondition;
    //var  timeToDoWork:Int = 0;
    fileprivate var isSet:Bool;
    private var mainThreadction:(()->())?;
    
    public init(isSet:Bool = false){
        self.isSet = isSet;
        self.lock = NSCondition();
    }
    
    open func set(mainThreadction:(()->())? = nil){
        
        if let mainThreadction = mainThreadction {
            if Thread.isMainThread {
                mainThreadction();
                setImpl();
            }else{
                if canEnterMainThread {
                    Queue.mainQueue {
                        mainThreadction();
                        self.setImpl();
                    }
                }else{
                    self.mainThreadction = mainThreadction;
                    setImpl();
                }
            }
        }else{
            setImpl();
        }
    }
    
    private func setImpl(){
        lock.lock();
        //timeToDoWork++;
        self.isSet = true;
        lock.signal();
        lock.unlock();
    }
    

    private var canEnterMainThread = false;
    
    open func waitOne(){
        
        
        lock.lock();
        
        canEnterMainThread = !Thread.isMainThread;
        while(!self.isSet){
            lock.wait();
        }
        if let mainThreadction = mainThreadction {
            mainThreadction();
            self.mainThreadction = nil;
        }
        lock.unlock();
    }
    
    open func reset(){
        lock.lock();
        isSet = false;
        lock.signal();
        lock.unlock();
    }
}
