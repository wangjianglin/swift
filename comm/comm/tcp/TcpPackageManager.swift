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


open class TcpPackageManager<K : Hashable,QT ,RT,QV,RV>{
    
    fileprivate var toKey:((QT)->(K));
    
    public init(reg:((_ manager:TcpPackageManager<K,QT ,RT,QV,RV>)->()),toKey:@escaping ((QT)->(K))){
        self.toKey = toKey;
        
        reg(self);
    }
    
    fileprivate var requests:Dictionary<K,QT> = [:]
//
//    
    fileprivate var responses:Dictionary<K,RT> = [:];
    
    fileprivate var responseKeys:Dictionary<String,K> = [:];
//
////    public class var commands:Dictionary<Int32,TcpCommandRequestPackage.Type>{
////        return YRSingleton.instance
////    }
//    
    open func request(_ resp:RT)->K!{
        return responseKeys[NSStringFromClass((resp as! AnyClass))];
    }

    open func register(_ cls:QT){
        //YRSingleton.instance[command.command] = command;
        let k = toKey(cls);
        requests[k] = cls;
        let respType = (cls as! TcpRequestPackage.Type).resp;
        responses[k] = respType as? RT;
        responseKeys[NSStringFromClass(respType)] = k;
        
    }
    
    open func remove(_ cls:QT){
        //YRSingleton.instance.removeValueForKey(command.command);
        let k = toKey(cls);
        requests.removeValue(forKey: k)
        let respType = responses.removeValue(forKey: k)
        responseKeys.removeValue(forKey: NSStringFromClass(respType as! AnyClass));
    }
    
    open func remove(_ key:K){
        //YRSingleton.instance.removeValueForKey(command);
        if let v = self.requests[key] {
            self.requests.removeValue(forKey: key);
            self.responses.removeValue(forKey: key)
            self.responseKeys.removeValue(forKey: NSStringFromClass((v as! AnyClass)))
        }
    }
    
    open func newRequestInstance(_ key:K)->QV!{
        if let cls = requests[key] {
            return (cls as! TcpRequestPackage.Type).init() as! QV;
        }
        return nil;
    }
    
    open func newResponseInstance(_ key:K)->RV!{
        if let cls = responses[key] {
            return (cls as! TcpResponsePackage.Type).init() as! RV;
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



public let TcpCommandPackageManager = TcpPackageManager<Int32,TcpCommandRequestPackage.Type,TcpCommandResponsePackage.Type,TcpCommandRequestPackage,TcpCommandResponsePackage>(reg: { (manager) -> () in
        manager.register(TcpCommandDetectPackage.self);
    }) { (
        q) -> Int32 in
        return q.command;
}

public let TcpJsonPackageManager = TcpPackageManager<String,TcpJsonRequestPackage.Type,TcpJsonResponsePackage.Type,TcpJsonRequestPackage,TcpJsonResponsePackage>(reg: { (manager) -> () in
    //manager.register(TcpCommandDetectPackage.Type);
    }) { (
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
