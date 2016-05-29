//
//  HttpServerRequest.swift
//  LinComm
//
//  Created by lin on 5/15/16.
//  Copyright © 2016 lin. All rights reserved.
//

import Foundation


public class CocoaHttpServerRequest : HttpRequest{
    
    private var message:HTTPMessage;
    init(message:HTTPMessage) {
        self.message = message;
    }
    
    public var isHeaderComplete:Bool{
        return message.isHeaderComplete;
    }
    
    public var version:String!{
        return message.version;
    }
    
    public var method:HttpMethod!{
        let methodString = message.method;
        if methodString == nil {
            return nil;
        }
        switch methodString!.lowercaseString {
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
    public var url:NSURL!{
        return message.url;
    }
    
    public var statusCode:Int{
        return message.statusCode;
    }
    
    public var headerFields:[NSObject : AnyObject]!{
        return message.allHeaderFields();
    }
    public func header(headerField: String!) -> String!{
        return message.headerField(headerField);
    }
    
    
//    public var messageData:NSData!{
//        return message.messageData();
//    }
    
    public var body:NSData!{
        return message.body;
    }
}