//
//  TcpJsonPackageManager.swift
//  LinClient
//
//  Created by lin on 1/26/16.
//  Copyright © 2016 lin. All rights reserved.
//


//public class TcpJsonPackageManager{
//    private struct YRSingleton{
//        static var instance:Dictionary<String,TcpJsonPackage.Type> = [:]
//    }
//    
//    public class var paths:Dictionary<String,TcpJsonPackage.Type>{
//        return YRSingleton.instance
//    }
//    
//    public class func register(path:TcpJsonPackage.Type){
//        YRSingleton.instance[path.path] = path;
//    }
//    
//    public class func remove(path:TcpJsonPackage.Type){
//        YRSingleton.instance.removeValueForKey(path.path);
//    }
//    
//    public class func remove(path:String){
//        YRSingleton.instance.removeValueForKey(path);
//    }
//    
////    public class func parse(buffer:[UInt8],offset:Int = 0)->TcpCommandPackage!{
////        let command = readInt32(buffer, offset: 3);
////        let cls = YRSingleton.instance[Int32(command)];
////        if cls == nil{
////            return nil;
////        }
////        let pack = cls!.init();
////        
////        pack.parse(buffer,offset: offset);
////        
////        return pack;
////    }
//}
