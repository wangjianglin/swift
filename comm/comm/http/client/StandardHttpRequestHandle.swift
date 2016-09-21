//
//  StandardHttpRequestHandle.swift
//  LinClient
//
//  Created by lin on 12/3/14.
//  Copyright (c) 2014 lin. All rights reserved.
//

import Foundation


open class StandardHttpRequestHandle:HttpRequestHandle{
    open func getParams(_ request:HttpTask,package:HttpPackage)->Dictionary<String,AnyObject>?{
        
        request.requestSerializer.headers[HTTP_COMM_PROTOCOL] = "";
//        if isDebug {
            request.requestSerializer.headers[HTTP_COMM_PROTOCOL_DEBUG] = "";
//        }
        return package.json.toParams() as Dictionary<String, AnyObject>?;
    }
    
    open func response(_ package:HttpPackage,response:AnyObject!,result:((_ obj:AnyObject?,_ warning:[HttpError])->()),fault:((_ error:HttpError)->())){
        
    }
}
