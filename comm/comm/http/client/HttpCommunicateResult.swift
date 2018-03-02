//
//  HttpCommunicateResult.swift
//  LinClient
//
//  Created by lin on 12/1/14.
//  Copyright (c) 2014 lin. All rights reserved.
//

import Foundation
import CessUtil

open class HttpCommunicateResult {
    
    fileprivate var _r:AnyObject! = nil;
    fileprivate var _success = false;
    fileprivate var _set:AutoResetEvent;
    private var _identifier:String?;
    
    private var _successAction:((_ obj:AnyObject?)->())?;
    private var _faultAction:((HttpError?)->())?;
    private var _completeAction:(()->())?;
    private var isFireAction = false;
    
    public var identifier:String?{
        return _identifier;
    }
    internal func setIdentifier(_ identifier:String?){
        self._identifier = identifier;
    }
    internal init(){
        self._set = AutoResetEvent();
    }
    
    private func fireAction(){
        objc_sync_enter(self);
        if _success {
            _successAction?(_r);
        }else{
            _faultAction?(_error);
        }
        self._completeAction?();
        isFireAction = true;
        objc_sync_exit(self);
    }
    
    internal func set(mainThreadction:(()->())? = nil){
        
        if let mainThreadction = mainThreadction {
            self._set.set(mainThreadction: {
                mainThreadction();
                self.fireAction();
            })
        }else{
            self.fireAction();
            self._set.set();
        }
    }
    
    private var _pause = false;
    private var _abort = false;
    private var _task:URLSessionTask?;
    
    func setURLSessionTask(task:URLSessionTask) {
        objc_sync_enter(self);
        _task = task;
        if _pause == true {
            task.suspend();
        }
        
        if _abort == true {
            task.cancel();
        }
        objc_sync_exit(self);
    }
    
    public func pause(){
        objc_sync_enter(self);
        _pause = true;
        _task?.suspend();
        objc_sync_exit(self);
    }
    public func resume(){
        objc_sync_enter(self);
        _pause = false;
        _task?.resume();
        objc_sync_exit(self);
    }
    open func abort(){
        objc_sync_enter(self);
        _abort = true;
        if !_abort {
            _task?.cancel();
        }
        objc_sync_exit(self);
    }
    
    open func waitForEnd(){
        _set.waitOne();
    }
    
    
    open var success:Bool{
        self.waitForEnd();
        return self._success;
    }
    internal func setResult(_ result:AnyObject!){
        self._r = result;
        self._success = true;
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
    
    public func onSuccess(_ action:@escaping (AnyObject?)->()){
        objc_sync_enter(self);
        self._successAction = action;
        if isFireAction {
            action(_r);
        }
        objc_sync_exit(self);
    }
    
    public func onFault(_ action:@escaping (HttpError?)->()){
        objc_sync_enter(self);
        self._faultAction = action;
        if isFireAction {
            action(_error);
        }
        objc_sync_exit(self);
    }
    
    public func onComplete(_ action:@escaping ()->()){
        objc_sync_enter(self);
        self._completeAction = action;
        if isFireAction {
            action();
        }
        objc_sync_exit(self);
    }
    
}
