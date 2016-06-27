//
//  LinWebView.swift
//  LinWeb
//
//  Created by lin on 6/10/16.
//  Copyright © 2016 lin. All rights reserved.
//

import WebKit
import LinUtil
import JavaScriptCore

public class LinWebViewController : UIViewController{
    
    //WKWebView
    private var _webView:WKWebView!;
    
    public override func viewDidLoad() {
        
    }
    
    public override func loadView() {
        _webView = WKWebView();
        self.view = _webView;
    }
    
    
    public func loadUrl(url:String!){
        if url == nil {
            _webView.loadHTMLString("error.", baseURL:nil);
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
            _webView.loadRequest(appReq);
        }else{
            _webView.loadHTMLString("url error.", baseURL:nil);
        }
        
    }
}