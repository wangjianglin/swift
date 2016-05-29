//
//  TcpPackageResponse.swift
//  LinClient
//
//  Created by lin on 1/24/16.
//  Copyright © 2016 lin. All rights reserved.
//

import LinUtil


public class TcpPackageResponse{

    private var _set:AutoResetEvent = AutoResetEvent();
    var set:AutoResetEvent{
        return _set;
    }
    init(){
        
    }
    
    private var _error:TcpErrorPackage!
    public var error:TcpErrorPackage!{
        return _error;
    }
    
    public func setError(error:TcpErrorPackage){
        _error = error;
        _set.set();
    }
    
    private var pack:TcpPackage!;

    func response(pack:TcpPackage){
        self.pack = pack;
        _set.set();
    }
    
    public var response:TcpPackage!{
        self.waitFofEnd();
        return self.pack;
    }

    public func waitFofEnd()->TcpPackageResponse{
        return self.waitForEnd(120000);
    }

    public func waitForEnd(timeout:Int)->TcpPackageResponse{
        _set.waitOne();
        return self;
    }
}