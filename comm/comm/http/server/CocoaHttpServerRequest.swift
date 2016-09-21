//
//  HttpServerRequest.swift
//  LinComm
//
//  Created by lin on 5/15/16.
//  Copyright © 2016 lin. All rights reserved.
//

import Foundation


open class CocoaHttpServerRequest : HttpRequest{
    
    fileprivate var message:HTTPMessage;
    init(message:HTTPMessage) {
        self.message = message;
    }
    
    open var isHeaderComplete:Bool{
        return message.isHeaderComplete;
    }
    
    open var version:String!{
        return message.version;
    }
    
    open var method:HttpMethod!{
        let methodString = message.method;
        if methodString == nil {
            return nil;
        }
        switch methodString!.lowercased() {
            case "post":
                return HttpMethod.POST
            case "head":
                return HttpMethod.HEAD;
            case "put":
                return HttpMethod.PUT;
            default:
                return HttpMethod.GET;
        }
    }
    open var url:URL!{
        return message.url;
    }
    
    open var statusCode:Int{
        return message.statusCode;
    }
    
    open var headerFields:[AnyHashable: Any]!{
        return message.allHeaderFields();
    }
    open func header(_ headerField: String!) -> String!{
        return message.headerField(headerField);
    }
    
    
//    public var messageData:NSData!{
//        return message.messageData();
//    }
    
    open var body:Data!{
        return message.body;
    }
}
