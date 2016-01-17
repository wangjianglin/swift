//
//  Cont.swift
//  LinClient
//
//  Created by lin on 1/23/15.
//  Copyright (c) 2015 lin. All rights reserved.
//

import Foundation

    /**
    * json数据的参数名
    */
public let HTTP_JSON_PARAM:String = "__json_param__";
    /**
    * 响应数据的类型，默认为html，支持html、json、xml
    */
    //private static final String RESULT = "__result__";
    /**
    * 数据通信协议版本的参数，无此参数，则表示不采用此种通信协议进行通信
    */
    //private static final String VERSION = "__version__";
    /**
    * 客户端请求数据的编码参数方式
    */
public let HTTP_REQUEST_CODING:String = "__request_coding__";
    /**
    * 客户端要求响应数据的编码方式，默认为utf-8
    */
public let HTTP_COMM_PROTOCOL:String = "__http_comm_protocol__";
public let HTTP_COMM_PROTOCOL_DEBUG:String = "__http_comm_protocol_debug__"
public let HTTP_COMM_PROTOCOL_VERSION:String = "/__http_comm_protocol__/__version__";
public let HTTP_VERSION:String = "0.1";
