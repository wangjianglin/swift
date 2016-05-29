//
//  StandardHttpRequestHandle.swift
//  LinClient
//
//  Created by lin on 12/3/14.
//  Copyright (c) 2014 lin. All rights reserved.
//

import Foundation


public class StandardHttpRequestHandle:HttpRequestHandle{
    public func getParams(request:HttpTask,package:HttpPackage)->Dictionary<String,String>?{
        return package.json.toParams();
    }
    
    public func response(package:HttpPackage,response:AnyObject!,result:((obj:AnyObject!,warning:[HttpError])->()),fault:((error:HttpError)->())){
        
    }
}