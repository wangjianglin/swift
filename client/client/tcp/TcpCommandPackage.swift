//
//  TcpCommandPackage.swift
//  LinClient
//
//  Created by lin on 1/23/16.
//  Copyright © 2016 lin. All rights reserved.
//

import LinUtil


public class TcpCommandPackage:TcpPackage{
    
    public required override init() {
        
    }
    
    override public class var type:UInt8{
        return 1;
    }
    
    public class var command:Int32{
        return 0;
    }
    
    public var command:Int32{
        return (Mirror(reflecting: self).subjectType as! TcpCommandPackage.Type).command;
    }
    
    public func parse(bs:[UInt8],offset:Int){
    
    }
    
    override public func write() -> [UInt8] {
        var buffer = [UInt8](count: Int(self.length), repeatedValue: 0);
        write(&buffer);
        return buffer;
    }
    
    override public func write(inout buffer: [UInt8]) {

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
    
    public var bodyLength:UInt32{
        return 0;
    }
}