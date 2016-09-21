//
//  HttpCommunicateResult.swift
//  LinClient
//
//  Created by lin on 12/1/14.
//  Copyright (c) 2014 lin. All rights reserved.
//

import Foundation
import LinUtil

open class HttpCommunicateResult {
    
    fileprivate var _r:AnyObject! = nil;
//    internal var set:AutoResetEvent?;
    fileprivate var _success = false;
    fileprivate var _set:AutoResetEvent;
    
    internal init(){
        self._set = AutoResetEvent();
    }
    
    internal var set:AutoResetEvent{
        return _set;
    }
    
    open func abort(){
    
    }
    
    open func waitForEnd(){
//        if let set = self.set{
            _set.waitOne();
//        }
    }
    
    
    open var success:Bool{
        self.waitForEnd();
        return self._success;
    }
    internal func setResult(_ result:AnyObject!,success:Bool){
        self._r = result;
        self._success = success;
    }
    
    open var result:AnyObject!{
        self.waitForEnd();
        return _r;
    }
    
    fileprivate var _error:HttpError!;
    
    open var error:HttpError!{
        self.waitForEnd();
        return _error;
    }
    
    internal func setError(_ error:HttpError?){
        self._error = error;
        self._success = false;
    }
}
