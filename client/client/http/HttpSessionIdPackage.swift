//
//  HttpSessionIdPackage.swift
//  LinClient
//
//  Created by lin on 12/4/14.
//  Copyright (c) 2014 lin. All rights reserved.
//

import Foundation


public class HttpSessionIdPackage:HttpPackage{
    
    public init(){
        super.init(url:"/core/comm/sessionId.action");
    }
}