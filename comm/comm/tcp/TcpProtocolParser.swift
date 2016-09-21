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
    
    func put(_ b:UInt8...);
    
    static var type:UInt8{get}//
    
    func clear();
    
    var state:TcpPackageState{get set};
}

open class ProtocolParsers{
    
    fileprivate struct YRSingleton{
        static var instance:Dictionary<UInt8,TcpProtocolParser.Type> = [
            TcpCommandProtocolParser_010.type:TcpCommandProtocolParser_010.self,
            TcpEmptyProtocolParser.type:TcpEmptyProtocolParser.self,
            TcpErrorPackageParser.type:TcpErrorPackageParser.self,
            TcpJsonProtocolParser.type:TcpJsonProtocolParser.self
        ]
    }
    
    open class var parsers:Dictionary<UInt8,TcpProtocolParser.Type>{
        return YRSingleton.instance
    }
    
    open class func get(_ type:UInt8)->TcpProtocolParser.Type!{
        return parsers[type];
    }
    
    open class func getInstance(_ type:UInt8)->TcpProtocolParser!{
        if let p = get(type) {
            return p.init();
        }
        return nil;
    }
    
    open class func register(_ type:TcpProtocolParser.Type){
        YRSingleton.instance[type.type] = type;
    }
    
    open class func remove(_ type:UInt8){
        YRSingleton.instance.removeValue(forKey: type);
    }
    
    open class func remove(_ type:TcpProtocolParser.Type){
        YRSingleton.instance.removeValue(forKey: type.type);
    }
}
