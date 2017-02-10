//
//  HttpRequestHandle.swift
//  LinClient
//
//  Created by lin on 12/2/14.
//  Copyright (c) 2014 lin. All rights reserved.
//

import Foundation
import LinUtil

public class HttpRequestPreprocessResult {
    
    open var _headers = IndexProperty<String,String>();
    open var headers:IndexProperty<String,String>{
        return _headers;
    }
}

public protocol HttpRequestHandle{
    
    
    
    func preprocess(_ package:HttpPackage,params:HttpCommunicate.Params)->HttpRequestPreprocessResult!;
    
    func getParams(_ package:HttpPackage)->Dictionary<String,AnyObject>?;
    
    func response(_ package:HttpPackage,response:AnyObject!,result:((_ obj:AnyObject?,_ warning:[HttpError])->()),fault:((_ error:HttpError)->()) );
}

open class AbstractHttpRequestHandle : HttpRequestHandle{
    
    open func preprocess(_ package:HttpPackage,params:HttpCommunicate.Params)->HttpRequestPreprocessResult!{
        return nil;
    }
    
    open func getParams(_ package:HttpPackage)->Dictionary<String,AnyObject>?{
        return package.json.toParams() as Dictionary<String, AnyObject>?;
    }
    
    open func response(_ package:HttpPackage,response:AnyObject!,result:((_ obj:AnyObject?,_ warning:[HttpError])->()),fault:((_ error:HttpError)->()) ){
        
    }
}
