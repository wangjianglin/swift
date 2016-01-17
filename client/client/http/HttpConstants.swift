//
//  HttpConstants.swift
//  LinClient
//
//  Created by lin on 12/15/14.
//  Copyright (c) 2014 lin. All rights reserved.
//

import Foundation


public class HttpConstants{
    
    public class var HTTP_JSON_PARAM:String {
        return "__json_param__";
    }
    
    public class var HTTP_REQUEST_CODING:String {
        return "__request_coding__";
    }
    
    
    public class var HTTP_COMM_PROTOCOL:String{
        return "__http_comm_protocol__";
    }
    
    public class var HTTP_COMM_PROTOCOL_VERSION:String{
        return "/__http_comm_protocol__/__version__";
    }
    
    public class var HTTP_VERSION:String {
        return "0.1";
    }
}
