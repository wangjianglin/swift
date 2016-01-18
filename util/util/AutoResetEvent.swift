//
//  AutoResetEvent.swift
//  LinUtil
//
//  Created by lin on 12/2/14.
//  Copyright (c) 2014 lin. All rights reserved.
//

import Foundation


public class AutoResetEvent {
    
    private var lock:NSCondition;
    //var  timeToDoWork:Int = 0;
    private var isSet:Bool;
    
    public init(isSet:Bool = false){
        self.isSet = isSet;
        self.lock = NSCondition();
    }
    
    public func set(){
        lock.lock();
        //timeToDoWork++;
        self.isSet = true;
        lock.signal();
        lock.unlock();
    }
    
    private var canMainThread:Int = 1;
    
    public func canEnterMainThread()->Bool{
        var can = false;
        lock.lock();
        if canMainThread == 1 {
            can = true;
            canMainThread = 2;
        }
        lock.unlock();
        return can;
    }
    
    public func waitOne(){
        
        
        lock.lock();
        
        if NSThread.isMainThread() {
            if canMainThread == 2  {
                lock.unlock();
                return;
            }
            
            canMainThread = 0;
        }
        while(!self.isSet){
            lock.wait();
        }
        lock.unlock();
    }
    
    public func reset(){
        lock.lock();
        isSet = false;
        lock.signal();
        lock.unlock();
    }
}