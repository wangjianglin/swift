//
//  LinUIWebView.swift
//  LinWeb
//
//  Created by lin on 9/21/16.
//  Copyright © 2016 lin. All rights reserved.
//

import Foundation
import UIKit
import JavaScriptCore
import LinUtil

//
//  LinWebController.m
//  LinWeb
//
//  Created by lin on 3/13/15.
//  Copyright (c) 2015 lin. All rights reserved.
//

//#import "LinWebController.h"
//#import "LinUtil/util.h"
//#import <UIKit/UIKit.h>
//#import "LinWebPlugin.h"
//#import "LinConfigParser.h"
//#import <objc/message.h>
//#import "LinCore/core.h"
//#import "AsynResult.h"
//#import <JavaScriptCore/JavaScriptCore.h>

//#if DEBUG
//
//@interface WebCache : NSObject
//+(void)empty;
//+(void)setDisabled:(BOOL)arg1;
//@end
//
//#endif


//@interface LinWebController()<UIWebViewDelegate>{
//    @private
//    UIWebView * _webView;
//    NSURLRequestCachePolicy cachePolicy;//
//    NSMutableDictionary * pluginObjects;
//    dispatch_once_t _plugin_objects_once_t;// = 0;
//}
//-(NSString*)pluginAction:(NSString*)name action:(NSString*)action params:(NSString*)params;
//@end


///##################################################################################

//@interface LinWebURLProtocol : NSURLProtocol
//
//- (void)sendResponseText:(NSString*)result;
//
//@end
//
//
//@interface LinWebURLResponse : NSHTTPURLResponse
//@property NSInteger statusCode;
//@end
//
//
//
//
//@implementation LinWebURLResponse
//@synthesize statusCode;
//
//- (NSDictionary*)allHeaderFields
//{
//    return nil;
//}
//
//@end

open class __LinUIWebViewURLResponse : HTTPURLResponse{
    open override var statusCode:Int {
        return 200;
    };
}

open class __LinUIWebViewURLProtocol : URLProtocol{
//    private var webView:UIWebView;

    fileprivate struct YRInstance{
        static var webs:[LinUIWebView] = [LinUIWebView]();
        static var configParser:LinConfigParser = LinConfigParser();
    }

    
    fileprivate func webView(_ flag:Int)->LinUIWebView?{
        for web in YRInstance.webs {
            if web.webFlag == flag {
                return web;
            }
        }
        return nil;
    }


//+(LinWebController*)webView:(int)flag{
//    for (LinWebController * item in LinWebURLProtocol.webs) {
//        if (item != nil && item.view.tag == flag) {
//            return item;
//        }
//    }
//    return nil;
//    }
    
    fileprivate class func addWebView(_ web:LinUIWebView){
        YRInstance.webs.append(web);
    }
    
//    + (void)registerURLProtocol:(LinWebController*)webView
//{
//    __weak UIWebView * _webView = webView;
//    [LinWebURLProtocol.webs addObject:_webView];
//    }
    
//    + (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
//{
//    return request;
//    }

    open override class func canonicalRequest(for request: URLRequest) -> URLRequest{
        return request;
    }
//    + (BOOL)canInitWithRequest:(NSURLRequest*)theRequest
//{
//    NSURL* theUrl = [theRequest URL];
//    
//    NSString * absoluteString = [theUrl absoluteString];
//    
//    if([absoluteString rangeOfString:@":0000/"].length != 0){
//        return YES;
//    }
//    return NO;
//}
    open override class func canInit(with request: URLRequest) -> Bool{
        if let absStr = request.url?.absoluteString {
            if absStr.range(of: ":0000/") != nil {
                return true;
            }
        }
        return false;
    }

//-(void)startLoading{
    open override func startLoading(){
    
        let flag = (self.request.value(forHTTPHeaderField: "web-flag") as? NSString)?.intValue ?? 0;
        let name = self.request.value(forHTTPHeaderField: "plugin");
        let action = self.request.value(forHTTPHeaderField: "action");
        var params:String? = nil;
        
        if let data = self.request.httpBody {
            params = String(data: self.request.httpBody!, encoding: String.Encoding.utf8);
        }
        self.webView(Int(flag))?.pluginAction(name, action: action, params: params, completion: { (value) in
            self.sendResponseText(value ?? "{}");
        })
        //    [self sendResponseText:[web pluginAction:name action:action params:params]];
    }
//    int flag = [[self.request valueForHTTPHeaderField:@"web-flag"] intValue];
//    NSString * name = [self.request valueForHTTPHeaderField:@"plugin"];
//    NSString * action = [self.request valueForHTTPHeaderField:@"action"];
//    
//    NSString * params = [[NSString alloc] initWithData:self.request.HTTPBody encoding:NSUTF8StringEncoding];
//    
//    
//    LinWebController * web = [LinWebURLProtocol webView:flag];
//    
//    [self sendResponseText:[web pluginAction:name action:action params:params]];
//    }
    
    
//    - (void)sendResponseText:(NSString*)result
    fileprivate func sendResponseText(_ result:String)
    {
        let data = result.data(using: String.Encoding.utf8);
        let response = __LinUIWebViewURLResponse(url: self.request.url!, mimeType: "application/json", expectedContentLength: data?.count ?? 0, textEncodingName: "utf-8");
        
        self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: URLCache.StoragePolicy.notAllowed)
        self.client?.urlProtocol(self, didLoad: data!);
        self.client?.urlProtocolDidFinishLoading(self);
        
//    NSData * data = [result dataUsingEncoding:NSUTF8StringEncoding];
//    LinWebURLResponse * response = [[LinWebURLResponse alloc] initWithURL:[[self request] URL] MIMEType:@"application/json" expectedContentLength:[data length] textEncodingName:@"UTF-8"];
//    response.statusCode = 200;
//    
//    [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
//    [[self client] URLProtocol:self didLoadData:data];
//    [[self client] URLProtocolDidFinishLoading:self];
    }
    
    override open func stopLoading() {
        
    }
}





//@implementation LinWebController

//-(void)testAlert{
//    UIApplication * app =[UIApplication sharedApplication];
//    UIWindow * window = app.windows[0];
//    
//    //    UIScrollView * scrollView = [[UIScrollView alloc] init];
//    //    scrollView.backgroundColor = [[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:0.8];
//    ////    scrollView.frame = [UIScreen mainScreen].bounds;
//    //    scrollView.frame = CGRectMake(0, 0, 300, 300);
//    //    scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//    //    scrollView.maximumZoomScale = 8;
//    //    scrollView.scrollEnabled = TRUE;
//    ////    scrollView.delegate = self;
//    //    scrollView.backgroundColor = [UIColor blackColor];
//    //
//    //    UIImageView * imageView = [[UIImageView alloc] init];
//    //    imageView.frame = [UIScreen mainScreen].bounds;
//    ////    imageView.image = [self waterMark:[UIImage imageWithURLString:images[0]] text:sn];
//    //    [scrollView addSubview:imageView];
//    ////    _imageView = imageView;
//    //
//    //    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithAction:^(NSObject * obj) {
//    //        [scrollView removeFromSuperview];
//    //    }];
//    //    [tap setNumberOfTapsRequired:2];
//    //    [scrollView addGestureRecognizer:tap];
//    
//    UIView * view = [[UIView alloc] init];
//    view.frame = CGRectMake(0, 0, 300, 300);
//    view.backgroundColor = [UIColor blackColor];
//    [window addSubview:view];
//}

private class __LinUIWebView_UIWebViewDelegate : NSObject, UIWebViewDelegate{
    
    fileprivate var origin:UIWebViewDelegate?;

    
    open func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool{
        return origin?.webView?(webView, shouldStartLoadWith: request, navigationType: navigationType) ?? true;
    }
    
    open func webViewDidStartLoad(_ webView: UIWebView){
    
        let view = webView as! LinUIWebView;
        var js = "window.sessionStorage.setItem(\"__ios-web-flag\",\"\(view.webFlag)\");";
        
        webView.stringByEvaluatingJavaScript(from: js);
        
        js = "window.Object.defineProperty(window,'IOSWebFlag',{value:\(view.webFlag),writable:false,configurable:false,enumerable:false})";
        
        webView.stringByEvaluatingJavaScript(from: js);
        
        origin?.webViewDidStartLoad?(webView);
    
    }
    
    open func webViewDidFinishLoad(_ webView: UIWebView){
        origin?.webViewDidFinishLoad?(webView);
    }
    
    open func webView(_ webView: UIWebView, didFailLoadWithError error: Error){
        origin?.webView?(webView, didFailLoadWithError: error);
    }

}

open class LinUIWebView : UIWebView{
    
    
    fileprivate let bridge:LinJavaScriptBridge;
    
    fileprivate static var __once:() = {
        URLProtocol.registerClass(__LinUIWebViewURLProtocol.self);
    }()
    
    open override var delegate: UIWebViewDelegate?{
        didSet{
            self.handler.origin = self.delegate;
        }
    }
    
    lazy fileprivate var handler:__LinUIWebView_UIWebViewDelegate = __LinUIWebView_UIWebViewDelegate.init();
    
    fileprivate struct YSInstance{
        static var webFlag = 0;
        static var lock:NSLock = NSLock();
    }
    fileprivate var webFlag:Int = {
        var r = 0;
        YSInstance.lock.lock();
        YSInstance.webFlag += 1;
        r = YSInstance.webFlag;
        YSInstance.lock.unlock();
        return r;
    }()
    
    internal init(webView:LinWebView){
        self.bridge = LinJavaScriptBridge(webView:webView);
        _ = LinUIWebView.__once;
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0));
        
        super.delegate = handler;
        __LinUIWebViewURLProtocol.addWebView(self);
    }
    
    
//    public override init(frame: CGRect){
//        
//        _ = LinUIWebView.__once;
//        super.init(frame: frame);
//        super.delegate = handler;
//        __LinUIWebViewURLProtocol.addWebView(self);
//    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func pluginAction(_ plugin:String?,action:String?, params:String?,completion:@escaping (String?)->Void){
        
        let json = Json();
        
        json.setValue(plugin, forName: "plugin");
        json.setValue(action, forName: "action");
        
        if let params = params {
            json["params"] = Json.parse(params);
        }
        
        bridge.pluginAction(args: json,completion: completion);
        
    }
    
    open func load(_ url:String){
        
        
        var appReq:URLRequest?;
        
        if url.lowercased().hasPrefix("http://") || url.hasPrefix("https://") {
            if let url = URL.init(string: url) {
                appReq = URLRequest.init(url: url, cachePolicy: URLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: 20.0);
            }
        }else{
        
            let startUrl = URL(string: url);
            let startFilePath = pathFor(Documents.bundle, path: (startUrl?.path)!);
            
            var appUrl:URL? = URL.init(fileURLWithPath: startFilePath ?? "");
            
            let r = url.rangeOfCharacter(from: CharacterSet.init(charactersIn: "?#"));
//
            if let r = r {
                let queryAndOrFragment = url.substring(from: r.lowerBound);
                appUrl = URL.init(string: queryAndOrFragment, relativeTo: appUrl);
            }
            
            if let appUrl = appUrl {
                appReq = URLRequest.init(url: appUrl, cachePolicy: URLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: 20.0);
            }
        }
        
        if let appReq = appReq {
            self.loadRequest(appReq);
        }
    
    
    }
    
}



//@implementation LinWebPlugin
//
//- (instancetype)initWithWebView:(UIWebView *)webView{
//    self = [super init];
//    if(self){
//        self->_webView = webView;
//    }
//    return self;
//    }
//    
//    - (void)handleOpenURL:(NSNotification*)notification{
//        
//        }
//        - (void)onAppTerminate{
//            
//            }
//            - (void)onMemoryWarning{
//                
//                }
//                - (void)onReset{
//                    
//                    }
//                    - (void)dispose{
//                        
//                        }
//                        
//                        - (id)appDelegate{
//                            return [UIApplication sharedApplication];
//}
//
//
//@end




