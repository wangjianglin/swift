//
//  HttpRequest.swift
//  LinClient
//
//  Created by lin on 12/1/14.
//  Copyright (c) 2014 lin. All rights reserved.
//

import Foundation


public protocol HttpRequest {
    
    var version:String!{ get }
    
    var method:HttpMethod!{get}
    
    var url:NSURL!{get}
    
    var statusCode:Int{get}
    
    var headerFields:[NSObject : AnyObject]!{get}
    
    func header(headerField: String!) -> String!;
    
    var body:NSData!{get}
    
}