//
//  TcpPackage.swift
//  LinClient
//
//  Created by lin on 1/21/16.
//  Copyright © 2016 lin. All rights reserved.
//

public class TcpPackage{
    
    private static var gloalSequeue:UInt64 = 0;
    private static var lock:NSLock = NSLock();
    
    public init(){
        
        TcpPackage.lock.lock()
        
        if(TcpPackage.gloalSequeue == UInt64.max){
            TcpPackage.gloalSequeue = 0;
        }
        TcpPackage.gloalSequeue++;
        _sequeue = TcpPackage.gloalSequeue;
        
        TcpPackage.lock.unlock()
    }
    
    private var _sequeue:UInt64 = 0;
    public var sequeue:UInt64{
        return _sequeue;
    }
    
    func setSequeue(seq:UInt64){
        _sequeue = seq;
    }
    
    private var _state:TcpPackageState = TcpPackageState.NONE;
    public var state:TcpPackageState{
        return _state;
    }
    
    func setState(state:TcpPackageState){
        self._state = state;
    }

    public class var type:UInt8{
        return UInt8.max;
    }
    
    public var type:UInt8{
        return (Mirror(reflecting: self).subjectType as! TcpPackage.Type).type;
    }

    
    public func write()->[UInt8]{
        return [UInt8]();
    }
    
    public func write(inout buffer:[UInt8]){
        
    }
    
    //UInt32.max表示无法计算出包的大小
    public var length:UInt32{
        return UInt32.max;
    }
}