//
//  TcpCommandPackageManager.swift
//  LinClient
//
//  Created by lin on 1/24/16.
//  Copyright © 2016 lin. All rights reserved.
//

import LinUtil


/////
//
// Command Package 管理器
//
public class TcpCommandPackageManager{
    
    
    private struct YRSingleton{
        static var instance:Dictionary<Int32,TcpCommandPackage.Type> = [
            TcpCommandDetectPackage.command:TcpCommandDetectPackage.self,
            TcpCommandDetectRespPackage.command:TcpCommandDetectRespPackage.self
        ]
    }
    
    public class var commands:Dictionary<Int32,TcpCommandPackage.Type>{
        return YRSingleton.instance
    }
    
    public class func register(command:TcpCommandPackage.Type){
        YRSingleton.instance[command.command] = command;
    }
    
    public class func remove(command:TcpCommandPackage.Type){
        YRSingleton.instance.removeValueForKey(command.command);
    }
    
    public class func remove(command:Int32){
        YRSingleton.instance.removeValueForKey(command);
    }
    
    public class func parse(buffer:[UInt8],offset:Int = 0)->TcpCommandPackage!{
        let command = readInt32(buffer, offset: 3);
        let cls = YRSingleton.instance[Int32(command)];
        if cls == nil{
            return nil;
        }
        let pack = cls!.init();
        
        pack.parse(buffer,offset: offset);
        
        return pack;
    }
}