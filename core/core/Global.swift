//
//  Global.swift
//  LinCore
//
//  Created by lin on 1/11/15.
//  Copyright (c) 2015 lin. All rights reserved.
//

import Foundation


open class GlobalArgs{
    
    fileprivate var datas:Dictionary<String,AnyObject?>;
    fileprivate init(){
        self.datas = Dictionary<String,AnyObject!>();
    }
    
    open subscript(name:String)->AnyObject?{
        get{ return datas[name]!;}
        set{ self.datas[name] = newValue;}
    }
}

//public class Global{
//    
//    public class var items:GlobalArgs{
//        struct YRSingleton{
//            static var predicate:dispatch_once_t = 0
//            static var instance:GlobalArgs? = nil
//        }
//        dispatch_once(&YRSingleton.predicate,{
//            YRSingleton.instance = GlobalArgs()
//        })
//        return YRSingleton.instance!
//    }
//}

public let Global = GlobalArgs();
