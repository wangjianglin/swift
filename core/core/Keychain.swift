//
//  Keychain.swift
//  LinCore
//
//  Created by lin on 12/17/14.
//  Copyright (c) 2014 lin. All rights reserved.
//

import Foundation


open class KeychainImpl{
    fileprivate init(service:String){
        
    }
    
    open subscript(service:String)->Any {
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
open class KeychainArgs{
    
    
    var insts:Dictionary<String,KeychainImpl>;
    fileprivate var lock:NSLock;
    
    fileprivate init(){
        self.insts = Dictionary<String,KeychainImpl>();
        self.lock = NSLock();
    }
    
    open subscript(service:String)->KeychainImpl {
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

private struct YRSingleton{
    static var instance:KeychainArgs? = nil
}

private var __once:() = {
    YRSingleton.instance = KeychainArgs()
}();

public var Keychain:KeychainArgs{
    _ = __once;
    return YRSingleton.instance!
}


