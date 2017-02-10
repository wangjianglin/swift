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
    
    
    class func url(_ impl:HttpCommunicateImpl,pack:HttpPackage)->String {
    
        var curl = pack.url;
        if !curl.hasPrefix("http://") && !curl.hasPrefix("https://") {
            curl = impl.commUrl;
            if pack.url.hasPrefix("/"){
                curl += pack.url.substring(from: pack.url.characters.index(pack.url.startIndex, offsetBy: 1))
            }else{
                curl += pack.url;
            }
        }
        
        if pack.enableCache{
            if curl.range(of: "?") != nil {
                curl += "&_time_stamp_\(Date().timeIntervalSince1970 * 100000)=\(arc4random())";
            }else{
                curl += "?_time_stamp_\(Date().timeIntervalSince1970 * 100000)=\(arc4random())";
            }
        }
        
        return curl;
    }
}
