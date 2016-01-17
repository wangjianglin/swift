//
//  HttpTestPackage.swift
//  LinClient
//
//  Created by lin on 12/3/14.
//  Copyright (c) 2014 lin. All rights reserved.
//

import Foundation

public class HttpTestPackage:HttpPackage{
    
    public init(){
        super.init(url:"/core/comm/test.action");
    }
    
//    override public func getParams()->Dictionary<String,AnyObject>?{
//        return ["data":self.data];
//    }
    
//    public var data:String!{
//        get{return self["data"].asString(def:"");}
//        set{self.setValue(newValue,forName:"data");}
//    }
}