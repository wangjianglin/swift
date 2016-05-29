//
//  HttpCommunicateResult.swift
//  LinClient
//
//  Created by lin on 12/1/14.
//  Copyright (c) 2014 lin. All rights reserved.
//

import Foundation
import LinUtil

public class HttpCommunicateResult {
    
    private var _r:AnyObject! = nil;
//    internal var set:AutoResetEvent?;
    private var _success = false;
    private var _set:AutoResetEvent;
    
    internal init(){
        self._set = AutoResetEvent();
    }
    
    internal var set:AutoResetEvent{
        return _set;
    }
    
    public func abort(){
    
    }
    
    public func waitForEnd(){
//        if let set = self.set{
            _set.waitOne();
//        }
    }
    
    
    public var success:Bool{
        self.waitForEnd();
        return self._success;
    }
    internal func setResult(result:AnyObject!,success:Bool){
        self._r = result;
        self._success = success;
    }
    
    public var result:AnyObject!{
        self.waitForEnd();
        return _r;
    }
    
    private var _error:HttpError!;
    
    public var error:HttpError!{
        self.waitForEnd();
        return _error;
    }
    
    internal func setError(error:HttpError?){
        self._error = error;
        self._success = false;
    }
}