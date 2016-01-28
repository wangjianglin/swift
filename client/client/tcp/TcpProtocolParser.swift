//
//  TcpProtocolParser.swift
//  LinClient
//
//  Created by lin on 1/21/16.
//  Copyright © 2016 lin. All rights reserved.
//

import Foundation

//255特殊处理，表示所有支持的类型

public protocol TcpProtocolParser{
    init();
    func parse()->TcpPackage!;
    
    func put(b:UInt8...);
    
    static var type:UInt8{get}//
    
    func clear();
    
    var state:TcpPackageState{get set};
}

public class ProtocolParsers{
    
    private struct YRSingleton{
        static var instance:Dictionary<UInt8,TcpProtocolParser.Type> = [
            TcpCommandProtocolParser_010.type:TcpCommandProtocolParser_010.self,
            TcpEmptyProtocolParser.type:TcpEmptyProtocolParser.self,
            TcpErrorPackageParser.type:TcpErrorPackageParser.self,
            TcpJsonProtocolParser.type:TcpJsonProtocolParser.self
        ]
    }
    
    public class var parsers:Dictionary<UInt8,TcpProtocolParser.Type>{
        return YRSingleton.instance
    }
    
    public class func get(type:UInt8)->TcpProtocolParser.Type!{
        return parsers[type];
    }
    
    public class func getInstance(type:UInt8)->TcpProtocolParser!{
        if let p = get(type) {
            return p.init();
        }
        return nil;
    }
    
    public class func register(type:TcpProtocolParser.Type){
        YRSingleton.instance[type.type] = type;
    }
    
    public class func remove(type:UInt8){
        YRSingleton.instance.removeValueForKey(type);
    }
    
    public class func remove(type:TcpProtocolParser.Type){
        YRSingleton.instance.removeValueForKey(type.type);
    }
}