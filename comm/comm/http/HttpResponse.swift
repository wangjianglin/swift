//
//  HttpResponse.swift
//  LinComm
//
//  Created by lin on 5/15/16.
//  Copyright © 2016 lin. All rights reserved.
//

import Foundation

public protocol HttpResponse {
    /// The header values in HTTP response.
    var headers: Dictionary<String,String>?{get}
    /// The mime type of the HTTP response.
    var mimeType: String?{get}
    /// The suggested filename for a downloaded file.
    var suggestedFilename: String?{get}
    /// The body or response data of the HTTP Response.
    var responseObject: AnyObject?{get}
    /// The status code of the HTTP Response.
    var statusCode: Int{get}
    
    var contentLength:UInt64{get}
    ///Returns the response as a string
//    public func text() -> String? {
//        if let d = self.responseObject as? NSData {
//            return  NSString(data: d, encoding: NSUTF8StringEncoding) as? String;
//        }
//        return nil
//    }
    /// The URL of the HTTP Response.
//    public var URL: NSURL?
}

//public class HttpResponse {
//    /// The header values in HTTP response.
//    public var headers: Dictionary<String,String>?
//    /// The mime type of the HTTP response.
//    public var mimeType: String?
//    /// The suggested filename for a downloaded file.
//    public var suggestedFilename: String?
//    /// The body or response data of the HTTP Response.
//    public var responseObject: AnyObject?
//    /// The status code of the HTTP Response.
//    public var statusCode: Int?
//    ///Returns the response as a string
//    public func text() -> String? {
//        if let d = self.responseObject as? NSData {
//            return  NSString(data: d, encoding: NSUTF8StringEncoding) as? String;
//        }
//        return nil
//    }
//    /// The URL of the HTTP Response.
//    public var URL: NSURL?
//}
