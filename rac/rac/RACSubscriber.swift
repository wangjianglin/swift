//
//  RACSubscriber.swift
//  LinRac
//
//  Created by lin on 7/4/16.
//  Copyright © 2016 lin. All rights reserved.
//

import ReactiveCocoa

public extension RACSubscriber{
    
    public func sendError(_ error:String,code:Int = 0,userInfo info:[AnyHashable: Any]? = nil){
        self.sendError(NSError(domain: error, code: code, userInfo: info));
    }
}
