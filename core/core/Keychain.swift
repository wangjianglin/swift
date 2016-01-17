//
//  Keychain.swift
//  LinCore
//
//  Created by lin on 12/17/14.
//  Copyright (c) 2014 lin. All rights reserved.
//

import Foundation


public class KeychainImpl{
    private init(service:String){
        
    }
    
    public subscript(service:String)->AnyObject {
        get{
            return ""
        }
                    set{
        
                    }
    }
}

//
//
//
//
public class KeychainArgs{
    
    
    var insts:Dictionary<String,KeychainImpl>;
    private var lock:NSLock;
    
    private init(){
        self.insts = Dictionary<String,KeychainImpl>();
        self.lock = NSLock();
    }
    
    public subscript(service:String)->KeychainImpl {
        get{
            //线程同步
            //@synchronized(self){
            var impl = insts[service];
            if let i = impl{
                return i;
            }
            lock.lock();
            impl = insts[service];
            if impl == nil{
                impl = KeychainImpl(service:service);
                insts[service] = impl;
            }
            lock.unlock();
            return impl!;
            //   return HttpCommunicate(name:name);
            //}
        }
        //            set{
        //
        //            }
    }
    
//    - (NSMutableDictionary *)getKeychainQuery {
//    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
//    (__bridge_transfer id)kSecClassGenericPassword,(__bridge_transfer id)kSecClass,
//    self.service, (__bridge_transfer id)kSecAttrService,
//    self.service, (__bridge_transfer id)kSecAttrAccount,
//    (__bridge_transfer id)kSecAttrAccessibleAfterFirstUnlock,(__bridge_transfer id)kSecAttrAccessible,
//    nil];
//    }
}


public var Keychain:KeychainArgs{
    struct YRSingleton{
        static var predicate:dispatch_once_t = 0
        static var instance:KeychainArgs? = nil
    }
    dispatch_once(&YRSingleton.predicate,{
        YRSingleton.instance = KeychainArgs()
    })
    return YRSingleton.instance!
}


