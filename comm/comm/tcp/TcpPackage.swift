//
//  TcpPackage.swift
//  LinClient
//
//  Created by lin on 1/21/16.
//  Copyright © 2016 lin. All rights reserved.
//

import Foundation

//@objc
public protocol TcpPackage{
    

    var sequeue:UInt64{get}
    
    //internal func setSequeue(seq:UInt64)
    
    static var state:TcpPackageState{get}
    
    var state:TcpPackageState{get}
    
    static var type:UInt8{get}
    
    var type:UInt8{get}
    
    
    func write()->[UInt8];
    
    func write(_ buffer:inout [UInt8]);
    
    //UInt32.max表示无法计算出包的大小
    var length:UInt32{get}
}

open class TcpAbstractPackage : TcpPackage{
    
    fileprivate static var gloalSequeue:UInt64 = 0;
    fileprivate static var lock:NSLock = NSLock();
    
    public init(){
        
        TcpAbstractPackage.lock.lock()
        
        if(TcpAbstractPackage.gloalSequeue == UInt64.max){
            TcpAbstractPackage.gloalSequeue = 0;
        }
        TcpAbstractPackage.gloalSequeue += 1;
        _sequeue = TcpAbstractPackage.gloalSequeue;
        
        TcpAbstractPackage.lock.unlock()
    }
    
    fileprivate var _sequeue:UInt64 = 0;
    open var sequeue:UInt64{
        return _sequeue;
    }
    
    func setSequeue(_ seq:UInt64){
        _sequeue = seq;
    }
    
    open class var state:TcpPackageState{
        return TcpPackageState.request;
    }
    public final var state:TcpPackageState{
        return (Mirror(reflecting: self).subjectType as! TcpPackage.Type).state;
    }
    
    open class var type:UInt8{
        return UInt8.max;
    }
    
    public final var type:UInt8{
        return (Mirror(reflecting: self).subjectType as! TcpPackage.Type).type;
    }
    
    
    open func write()->[UInt8]{
        return [UInt8]();
    }
    
    open func write(_ buffer:inout [UInt8]){
        
    }
    
    //UInt32.max表示无法计算出包的大小
    open var length:UInt32{
        return UInt32.max;
    }
}
