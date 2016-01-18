//
//  HttpUtils.swift
//  LinClient
//
//  Created by lin on 12/2/14.
//  Copyright (c) 2014 lin. All rights reserved.
//

import Foundation


class HttpUtils {
    
    class var timestamp:UInt{
        return 0;
    }
    
    class var sequeue:UInt {
        get{
            return 0;
        }
    }
    
    
    class func url(impl:HttpCommunicateImpl,pack:HttpPackage)->String {
    
        var curl = impl.commUrl;
        //var commUriString = "";
        if pack.url.hasPrefix("/"){
            curl += pack.url.substringFromIndex(pack.url.startIndex.advancedBy(1))
        }else{
            curl += pack.url;
        }
        
        if !pack.enableCache{
            if curl.rangeOfString("?") != nil {
                curl += "&_time_stamp_\(NSDate().timeIntervalSince1970 * 100000)=1";
            }else{
                curl += "?_time_stamp_\(NSDate().timeIntervalSince1970 * 100000)=1";
            }
        }
        
        return curl;
    }
}