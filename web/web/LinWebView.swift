//
//  LinWebView.swift
//  LinWeb
//
//  Created by lin on 6/11/16.
//  Copyright © 2016 lin. All rights reserved.
//

import Foundation
import WebKit
import LinUtil

public class LinWebView : WKWebView{
    
//    override public var UIDelegate: WKUIDelegate?;
//    weak public override var UIDelegate: WKUIDelegate?
    
    weak public override var UIDelegate: WKUIDelegate?
        {
//        get{
//            return nil;
//        }
//        set{
//            
//        }
        didSet{}
    }
    
    public override init(frame: CGRect, configuration: WKWebViewConfiguration) {
        super.init(frame:frame, configuration:configuration);
    }
    
    public func loadUrl(url:String!){
        if url == nil {
            self.loadHTMLString("error.", baseURL:nil);
            return;
        }
        var appReq:NSURLRequest! = nil;
        if url.lowercaseString.hasPrefix("http://") || url.lowercaseString.hasPrefix("https://") {
            if let nsurl = NSURL(string:url) {
                appReq = NSURLRequest(URL:nsurl, cachePolicy:NSURLRequestCachePolicy.UseProtocolCachePolicy, timeoutInterval:20.0);
            }
        }else{
            
            let startURL = NSURL(string:url);
            if let path = startURL?.path {
                
                if let startFilePath = pathFor(Documents.Bundle, path: path) {
                    
                    var appURL:NSURL? = NSURL(fileURLWithPath:startFilePath);
                    
                    let r = url.rangeOfCharacterFromSet(NSCharacterSet(charactersInString: "?#"));
                    if let r = r {
                        let queryAndOrFragment = url.substringFromIndex(r.startIndex);
                        
                        appURL = NSURL(string: queryAndOrFragment,relativeToURL: appURL);
                    }
                    
                    if let appURL = appURL{
                        appReq = NSURLRequest(URL: appURL, cachePolicy: NSURLRequestCachePolicy.UseProtocolCachePolicy, timeoutInterval: 15.0);
                    }
                }
            }
        }
        
        if let appReq = appReq{
            self.loadRequest(appReq);
        }else{
            self.loadHTMLString("url error.", baseURL:nil);
        }
        
    }
}
