//
//  HttpRequestHandle.swift
//  LinClient
//
//  Created by lin on 12/2/14.
//  Copyright (c) 2014 lin. All rights reserved.
//

import Foundation


public protocol HttpRequestHandle{
    
    func getParams(_ request:HttpTask,package:HttpPackage)->Dictionary<String,AnyObject>?;
    
    func response(_ package:HttpPackage,response:AnyObject!,result:((_ obj:AnyObject?,_ warning:[HttpError])->()),fault:((_ error:HttpError)->()) );
}

open class AbstractHttpRequestHandle : HttpRequestHandle{
    open func getParams(_ request:HttpTask,package:HttpPackage)->Dictionary<String,AnyObject>?{
        return nil;
    }
    
    open func response(_ package:HttpPackage,response:AnyObject!,result:((_ obj:AnyObject?,_ warning:[HttpError])->()),fault:((_ error:HttpError)->()) ){
        
    }
}
