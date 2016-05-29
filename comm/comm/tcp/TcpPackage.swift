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
    
    func write(inout buffer:[UInt8]);
    
    //UInt32.max表示无法计算出包的大小
    var length:UInt32{get}
}

public class TcpAbstractPackage : TcpPackage{
    
    private static var gloalSequeue:UInt64 = 0;
    private static var lock:NSLock = NSLock();
    
    public init(){
        
        TcpAbstractPackage.lock.lock()
        
        if(TcpAbstractPackage.gloalSequeue == UInt64.max){
            TcpAbstractPackage.gloalSequeue = 0;
        }
        TcpAbstractPackage.gloalSequeue++;
        _sequeue = TcpAbstractPackage.gloalSequeue;
        
        TcpAbstractPackage.lock.unlock()
    }
    
    private var _sequeue:UInt64 = 0;
    public var sequeue:UInt64{
        return _sequeue;
    }
    
    func setSequeue(seq:UInt64){
        _sequeue = seq;
    }
    
    public class var state:TcpPackageState{
        return TcpPackageState.REQUEST;
    }
    public final var state:TcpPackageState{
        return (Mirror(reflecting: self).subjectType as! TcpPackage.Type).state;
    }
    
    public class var type:UInt8{
        return UInt8.max;
    }
    
    public final var type:UInt8{
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