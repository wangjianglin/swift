//
//  TcpCommandPackage.swift
//  LinClient
//
//  Created by lin on 1/23/16.
//  Copyright © 2016 lin. All rights reserved.
//

import LinUtil


public protocol TcpCommandPackage : TcpPackage{
    
//    static var command:Int32{get};
    
    var command:Int32{get};
    
    func parse(_ bs:[UInt8],offset:Int);
    
    func write() -> [UInt8];
    
    func write(_ buffer: inout [UInt8]);
    
    var bodyLength:UInt32{get};
    
}
//@objc
open class TcpCommandRequestPackage:TcpRequestPackage,TcpCommandPackage{
    
    public required init() {
        
    }
    
    override final public class var type:UInt8{
        return 1;
    }
    
    open override class var resp:TcpResponsePackage.Type{
        return TcpEmptyPackage.self;
    }
    
    open class var command:Int32{
        return 0;
    }
    
    public final var command:Int32{
        return (Mirror(reflecting: self).subjectType as! TcpCommandRequestPackage.Type).command;
    }
    
    open func parse(_ bs:[UInt8],offset:Int){
        
    }
    
    override open func write() -> [UInt8] {
        var buffer = [UInt8](repeating: 0, count: Int(self.length));
        write(&buffer);
        return buffer;
    }
    
    override open func write(_ buffer: inout [UInt8]) {
        
        writeInt8(&buffer,value: 0,offset: 0);
        writeInt8(&buffer,value: 1,offset: 1);
        writeInt8(&buffer,value: 0,offset: 2);
        writeInt32(&buffer,value: self.command,offset: 3);
        writeInt32(&buffer,value: Int32(buffer.count),offset: 7);
        writeInt32(&buffer,value: 0,offset: 11);
        
    }
    
    override final public var length:UInt32{
        return 19 + bodyLength;
    }
    
    open var bodyLength:UInt32{
        return 0;
    }
}

open class TcpCommandResponsePackage:TcpResponsePackage,TcpCommandPackage{
    
    fileprivate var _command:Int32!;
    public required init() {
        super.init();
        
        if let command = TcpCommandPackageManager.request(Mirror(reflecting: self).subjectType as! TcpCommandResponsePackage.Type) {
            self._command = command;
        }else{
            self._command = 0
        }
    }
    
    override final public class var type:UInt8{
        return 1;
    }
    
    
    public final var command:Int32{
        return _command;//(Mirror(reflecting: self).subjectType as! TcpCommandRequestPackage.Type).command;
    }
    
    open func parse(_ bs:[UInt8],offset:Int){
        
    }
    
    override open func write() -> [UInt8] {
        var buffer = [UInt8](repeating: 0, count: Int(self.length));
        write(&buffer);
        return buffer;
    }
    
    override open func write(_ buffer: inout [UInt8]) {
        
        writeInt8(&buffer,value: 0,offset: 0);
        writeInt8(&buffer,value: 1,offset: 1);
        writeInt8(&buffer,value: 0,offset: 2);
        writeInt32(&buffer,value: self.command,offset: 3);
        writeInt32(&buffer,value: Int32(buffer.count),offset: 7);
        writeInt32(&buffer,value: 0,offset: 11);
        
    }
    
    override final public var length:UInt32{
        return 19 + bodyLength;
    }
    
    open var bodyLength:UInt32{
        return 0;
    }
}
