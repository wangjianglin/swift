//
//  NoneHttpRequestHandle.swift
//  LinClient
//
//  Created by lin on 12/2/14.
//  Copyright (c) 2014 lin. All rights reserved.
//

import Foundation


public class NoneHttpRequestHandle:HttpRequestHandle{
    
    public func getParams(request:HttpTask,package:HttpPackage)->Dictionary<String,AnyObject>?{
        return nil;
    }
    
    public func response(package:HttpPackage,response:AnyObject!,result:((obj:AnyObject!,warning:[HttpError])->()),fault:((error:HttpError)->())){
        
    }
}