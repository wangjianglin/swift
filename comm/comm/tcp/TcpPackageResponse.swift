//
//  TcpPackageResponse.swift
//  LinClient
//
//  Created by lin on 1/24/16.
//  Copyright © 2016 lin. All rights reserved.
//

import LinUtil


open class TcpPackageResponse{

    fileprivate var _set:AutoResetEvent = AutoResetEvent();
    var set:AutoResetEvent{
        return _set;
    }
    init(){
        
    }
    
    fileprivate var _error:TcpErrorPackage!
    open var error:TcpErrorPackage!{
        return _error;
    }
    
    open func setError(_ error:TcpErrorPackage){
        _error = error;
        _set.set();
    }
    
    fileprivate var pack:TcpPackage!;

    func response(_ pack:TcpPackage){
        self.pack = pack;
        _set.set();
    }
    
    open var response:TcpPackage!{
        self.waitFofEnd();
        return self.pack;
    }

    open func waitFofEnd()->TcpPackageResponse{
        return self.waitForEnd(120000);
    }

    open func waitForEnd(_ timeout:Int)->TcpPackageResponse{
        _set.waitOne();
        return self;
    }
}
