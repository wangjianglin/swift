//
//  HttpConstants.swift
//  LinClient
//
//  Created by lin on 12/15/14.
//  Copyright (c) 2014 lin. All rights reserved.
//

import Foundation


open class HttpConstants{
    
    open class var HTTP_JSON_PARAM:String {
        return "__json_param__";
    }
    
    open class var HTTP_REQUEST_CODING:String {
        return "__request_coding__";
    }
    
    
    open class var HTTP_COMM_PROTOCOL:String{
        return "__http_comm_protocol__";
    }
    
    open class var HTTP_COMM_PROTOCOL_VERSION:String{
        return "/__http_comm_protocol__/__version__";
    }
    
    open class var HTTP_VERSION:String {
        return "0.1";
    }
    
    open class var HTTP_COMM_PROTOCOL_DEBUG:String {
        return "__http_comm_protocol_debug__"
    }
}
