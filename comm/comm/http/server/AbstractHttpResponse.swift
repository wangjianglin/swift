//
//  AbstractHttpResponse.swift
//  LinComm
//
//  Created by lin on 5/16/16.
//  Copyright © 2016 lin. All rights reserved.
//

import Foundation


open class AbstractHttpResponse :NSObject, HttpResponse{
    /// The header values in HTTP response.
    open var headers: Dictionary<String,String>?
    /// The mime type of the HTTP response.
    open var mimeType: String?
    /// The suggested filename for a downloaded file.
    open var suggestedFilename: String?
    /// The body or response data of the HTTP Response.
    open var responseObject: AnyObject?
    /// The status code of the HTTP Response.
    open var statusCode: Int = 0
    open var contentLength: UInt64 = 0;
    ///Returns the response as a string
//    public func text() -> String? {
//        if let d = self.responseObject as? NSData {
//            return  NSString(data: d, encoding: NSUTF8StringEncoding) as? String;
//        }
//        return nil
//    }
    /// The URL of the HTTP Response.
    open var URL: Foundation.URL?
}
