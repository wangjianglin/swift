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

//public TcpCommandPackageManager

//static var instance:Dictionary<K,TcpCommandRequestPackage.Type> = [
//    TcpCommandDetectPackage.command:TcpCommandDetectPackage.self
//]
//static var instance:Dictionary<String,Int32> = [
//    NSStringFromClass(TcpCommandDetectPackage.resp):TcpCommandDetectPackage.command
//]

typealias QVType = TcpRequestPackage.Type;


public class TcpPackageManager<K : Hashable,QT ,RT,QV,RV>{
    
    private var toKey:((QT)->(K));
    
    public init(toKey:((QT)->(K))){
        self.toKey = toKey;
    }
    
    private var requests:Dictionary<K,QT> = [:]
//
//    
    private var responses:Dictionary<String,K> = [:];
//
////    public class var commands:Dictionary<Int32,TcpCommandRequestPackage.Type>{
////        return YRSingleton.instance
////    }
//    
    public func request(resp:RT)->K!{
        return responses[NSStringFromClass((resp as! AnyClass))];
    }

    public func register(cls:QT){
        //YRSingleton.instance[command.command] = command;
        let k = toKey(cls);
        requests[k] = cls;
        responses[NSStringFromClass((cls as! AnyClass))] = k;
    }
    
    public func remove(cls:QT){
        //YRSingleton.instance.removeValueForKey(command.command);
        let k = toKey(cls);
        requests.removeValueForKey(k)
        responses.removeValueForKey(NSStringFromClass((cls as! AnyClass)));
    }
    
    public func remove(key:K){
        //YRSingleton.instance.removeValueForKey(command);
        if let v = self.requests[key] {
            self.requests.removeValueForKey(key);
            self.responses.removeValueForKey(NSStringFromClass((v as! AnyClass)))
        }
    }
    
    public func newRequestInstance(key:K)->QV!{
        if let cls = requests[key] {
            return (cls as! TcpRequestPackage.Type).init() as! QV;
        }
        return nil;
    }
    
    public func newResponseInstance(key:K)->RV!{
        if let cls = requests[key] {
            return (responses[NSStringFromClass(cls as! AnyClass)] as! TcpRequestPackage.Type).init() as! RV;
        }
        return nil;
    }
    
//    class func requestParse(buffer:[UInt8],offset:Int = 0)->TcpCommandRequestPackage!{
//        let command = readInt32(buffer, offset: 3);
//        let cls = YRSingleton.instance[Int32(command)];
//        if cls == nil{
//            return nil;
//        }
//        let pack = cls!.init();
//        
//        pack.parse(buffer,offset: offset);
//        
//        return pack;
//    }
//    
//    class func responseParse(buffer:[UInt8],offset:Int = 0)->TcpResponsePackage!{
//        let command = readInt32(buffer, offset: 3);
//        let cls = YRSingleton.instance[Int32(command)]?.resp;
//        if cls == nil{
//            return nil;
//        }
//        let pack = cls!.init();
//        
//        if pack is TcpCommandResponsePackage {
//            (pack as! TcpCommandResponsePackage).parse(buffer,offset: offset);
//        }
//        
//        return pack;
//    }
}



public let TcpCommandPackageManager = TcpPackageManager<Int32,TcpCommandRequestPackage.Type,TcpCommandResponsePackage.Type,TcpCommandRequestPackage,TcpCommandResponsePackage>() { (
    q) -> Int32 in
    return q.command;
}

public let TcpJsonPackageManager = TcpPackageManager<String,TcpJsonRequestPackage.Type,TcpJsonResponsePackage.Type,TcpJsonRequestPackage,TcpJsonResponsePackage>() { (
    q) -> String in
    return q.path;
}

//public class TcpPackageManager<K,V>{
//    
//    
//    private struct YRSingleton{
//        static var instance:Dictionary<K,TcpCommandRequestPackage.Type> = [
//            TcpCommandDetectPackage.command:TcpCommandDetectPackage.self
//        ]
//    }
//    
//    private struct YRSingletonResp{
//        static var instance:Dictionary<String,Int32> = [
//            NSStringFromClass(TcpCommandDetectPackage.resp):TcpCommandDetectPackage.command
//        ]
//    }
//    
//    public class var commands:Dictionary<Int32,TcpCommandRequestPackage.Type>{
//        return YRSingleton.instance
//    }
//    
//    public class func request(resp:TcpCommandResponsePackage)
//    
//    public class func register(command:TcpCommandRequestPackage.Type){
//        YRSingleton.instance[command.command] = command;
//    }
//    
//    public class func remove(command:TcpCommandRequestPackage.Type){
//        YRSingleton.instance.removeValueForKey(command.command);
//    }
//    
//    public class func remove(command:Int32){
//        YRSingleton.instance.removeValueForKey(command);
//    }
//    
//    class func requestParse(buffer:[UInt8],offset:Int = 0)->TcpCommandRequestPackage!{
//        let command = readInt32(buffer, offset: 3);
//        let cls = YRSingleton.instance[Int32(command)];
//        if cls == nil{
//            return nil;
//        }
//        let pack = cls!.init();
//        
//        pack.parse(buffer,offset: offset);
//        
//        return pack;
//    }
//    
//    class func responseParse(buffer:[UInt8],offset:Int = 0)->TcpResponsePackage!{
//        let command = readInt32(buffer, offset: 3);
//        let cls = YRSingleton.instance[Int32(command)]?.resp;
//        if cls == nil{
//            return nil;
//        }
//        let pack = cls!.init();
//        
//        if pack is TcpCommandResponsePackage {
//            (pack as! TcpCommandResponsePackage).parse(buffer,offset: offset);
//        }
//        
//        return pack;
//    }
//}