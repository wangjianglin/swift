//
//  LinHttpDNSPlugin.swift
//  LinWeb
//
//  Created by lin on 9/19/16.
//  Copyright © 2016 lin. All rights reserved.
//

import Foundation

open class LinHttpDNSPlugin : LinAbstractWebPlugin{
//@implementation
//
//-(Json *)proxy{
//    NSDictionary *proxySettings = CFBridgingRelease(CFNetworkCopySystemProxySettings());
//    
//    NSArray *proxies = nil;
//    
//    NSURL *url = [[NSURL alloc] initWithString:@"http://api.m.taobao.com"];
//    
//    proxies = CFBridgingRelease(CFNetworkCopyProxiesForURL((__bridge CFURLRef)url,
//    (__bridge CFDictionaryRef)proxySettings));
//    
//    Boolean isProxy = NO;
//    if (proxies > 0)
//    {
//        NSDictionary *settings = [proxies objectAtIndex:0];
//        NSString* host = [settings objectForKey:(NSString *)kCFProxyHostNameKey];
//        NSString* port = [settings objectForKey:(NSString *)kCFProxyPortNumberKey];
//        
//        if (host || port)
//        {
//            isProxy = YES;
//        }
//    }
//    return [[Json alloc] initWithObject:[[NSNumber alloc] initWithBool:isProxy]];
}


////
////  HttpDNSPlugin.m
////  buyers
////
////  Created by lin on 16/11/2016.
////  Copyright © 2016 lin. All rights reserved.
////
//
//#import "HttpDNSPlugin.h"
//#import "LinClient/client.h"
//#import "LinUtil/util.h"
//
//@class HttpStandardJsonHttpRequestHandle;
//@interface HttpStandardJsonHttpRequestHandle : NSObject<HttpRequestHandle>
//
//@end
////    private class HttpRequestPackage extends HttpPackage {
////        private Map<String, Object> params;
////        private Map<String, String> headers;
////
////        HttpRequestPackage(String url, HttpMethod method) {
////            super(url, method);
////            this.setRequestHandle(HttpPackage.NORMAL);
////        }
////
////        public Map<String, Object> getParams() {
////            return this.params;
////        }
////
////        public Map<String, String> getHeaders() {
////            return this.headers;
////        }
////    }
//@interface HttpRequestPackage : HttpPackage{
//    @package
//    NSDictionary * params;
//    NSDictionary * headers;
//    
//    
//}
//
//-(id)init:(NSString*)url method:(HttpMethod)method;
//
//@end
//
//
//@implementation HttpRequestPackage
//
//-(id)init:(NSString *)url method:(HttpMethod)method{
//    self = [super initWithUrl:url method:method];
//    if(self){
//        
//    }
//    return self;
//}
//
//
//-(NSDictionary*)toParams{
//    return params;
//}
//
//@end
//
//@interface HttpDNSPlugin (){
//    HttpStandardJsonHttpRequestHandle * handle;
//    HttpCommunicateImpl * impl;
//}
//
//@end
//
//@implementation HttpDNSPlugin
//
//-(id)initWithWebView:(UIWebView *)webView{
//    self = [super initWithWebView:webView];
//    if(self){
//        //        [HttpCommunicate set
//        handle = [[HttpStandardJsonHttpRequestHandle alloc] init];
//        impl = [[HttpCommunicateImpl alloc] initWithName:@"web http dns"];
//    }
//    return self;
//}
//
//
////
////public class HttpDNSPlugin extends LinWebPlugin {
////    private HttpCommunicateImpl impl;
////
////    public HttpDNSPlugin(Context context) {
////        super(context);
////        HttpCommunicate.init(context);
////        this.impl = HttpCommunicate.get("web http");
////        this.impl.setTimeout(20000);
////        this.impl.addHeader("__http_comm_protocol__", "");
////        this.impl.addHeader("__http_comm_protocol_debug__", "");
////    }
////
//-(NSObject*)http:(Json*)args{
//    
//    Json * config = args[@"config"];
//    Json * headers = config[@"headers"];
//    Json * params = config[@"params"];
//    NSString * methodStr = [config[@"method"] asString];
//    //[[HttpMethod alloc] init
//    HttpMethod method;
//    //GET,POST,PUT,HEAD,DELETE
//    if([@"GET" isEqualToString:methodStr]){
//        method = GET;
//    }else if([@"PUT" isEqualToString:methodStr]){
//        method = PUT;
//    }else if([@"HEAD" isEqualToString:methodStr]){
//        method = HEAD;
//    }else if([@"DELETE" isEqualToString:methodStr]){
//        method = DELETE;
//    }else{
//        method = POST;
//    }
//    
//    NSString * url = [config[@"url"] asString];
//    
//    NSString * host = [args[@"host"] asString];
//    NSString * destIp = [args[@"destIp"] asString];
//    
//    NSDictionary * headersParam = [headers toParams];
//    if (destIp != nil && ![@"" isEqualToString:destIp]) {
//        [headersParam setValue:host forKey:@"Host"];
//        url = [url stringByReplacingOccurrencesOfString:host withString:destIp];
//    }
//    
//    HttpRequestPackage * pack = [[HttpRequestPackage alloc] init:url method:method];
//    
//    pack->headers = headersParam;
//    pack->params = [params toParams];
//    
//    pack.handle = handle;
//    
//    
//    //    HttpCommunicateResult * r = [impl request:pack result:^(NSObject *obj, NSArray *warning) {
//    //        NSLog(@"%@",obj);
//    //    } fault:^(HttpError *error) {
//    //        NSLog(@"%@",error);
//    //    }];
//    HttpCommunicateResult * r = [HttpCommunicate request:pack result:nil fault:nil];
//    [r waitForEnd];
//    if(r.isSuccess){
//        
//        Json * json1 = [[Json alloc] init];
//        [json1 setIntValue:0 forName:@"code"];
//        json1[@"result"] = (Json*)[r getResult];
//        return json1;
//    }
//    HttpError * error = (HttpError*)[r getResult];
//    
//    Json * json2 = [[Json alloc] init];
//    [json2 setIntValue:error.code forName:@"code"];
//    [json2 setValue:error.message forName:@"message"];
//    [json2 setValue:error.cause forName:@"cause"];
//    [json2 setValue:error.stackTrace forName:@"stackTrace"];
//    return json2;
//}
////    public Object http(Map<String, Object> args) {
////        Map config = (Map)args.get("config");
////        Object headers = (Map)config.get("headers");
////        Object methodStr = config.get("method");
////        Map params = (Map)config.get("params");
////        String url = (String)config.get("url");
////        String host = (String)args.get("host");
////        String destIp = (String)args.get("destIp");
////        if(headers == null) {
////            headers = new HashMap();
////        }
////
////        if(destIp != null && !"".equals(destIp) && !Utils.detectIfProxyExist(this.getContext())) {
////            ((Map)headers).put("Host", host);
////            url = url.replaceFirst(host, destIp);
////        }
////
////        HttpMethod method = HttpMethod.POST;
////        if("get".equals(methodStr)) {
////            method = HttpMethod.GET;
////        }
////
////        HttpDNSPlugin.HttpRequestPackage pack = new HttpDNSPlugin.HttpRequestPackage(url, method);
////        pack.params = params;
////        pack.headers = (Map)headers;
////        HttpCommunicateResult result = this.impl.request(pack);
////        result.waitForEnd();
////        return result.isSuccess()?result.getResult():result.getError();
////    }
////
////    private class HttpRequestPackage extends HttpPackage {
////        private Map<String, Object> params;
////        private Map<String, String> headers;
////
////        HttpRequestPackage(String url, HttpMethod method) {
////            super(url, method);
////            this.setRequestHandle(HttpPackage.NORMAL);
////        }
////
////        public Map<String, Object> getParams() {
////            return this.params;
////        }
////
////        public Map<String, String> getHeaders() {
////            return this.headers;
////        }
////    }
////}
//@end
//
//
//
//
//@implementation HttpStandardJsonHttpRequestHandle
//
//-(NSDictionary*)getParams:(HttpTask *)request package:(HttpPackage *)package{
//    //[request ]
//    if([package isKindOfClass:[HttpRequestPackage class]]){
//        HttpRequestPackage * p = (HttpRequestPackage*)package;
//        request.requestSerializer.headers = p->headers;
//    }
//    
//    return [package toParams];
//}
//
//-(void)response:(HttpPackage *)package response:(NSObject *)response result:(void (^)(NSObject *, NSArray *))result fault:(void (^)(HttpError *))fault{
//    
//    NSString * resp;
//    if (response != nil) {
//        NSData * data = (NSData*)response;
//        resp = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    }
//    if (resp == nil) {
//        
//        HttpError * e = [[HttpError alloc] initWithCode:-1];
//        fault(e);
//        return;
//    }
//    
//    Json * json = [[Json alloc] initWithString:resp];
//    if (json.isError) {
//        HttpError * e = [[HttpError alloc] initWithCode:-0x11];
//        fault(e);
//        return;
//    }
//    int code = [json[@"code"] asInt:-0x12];
//    if (code < 0) {
//        HttpError * e =[[HttpError alloc] initWithCode:code];
//        e.message = json[@"message"].asString;
//        e.stackTrace = json[@"stackTrace"].asString;
//        e.cause = json[@"cause"].asString;
//        fault(e);
//        return;
//    }
//    result([package getResult:json[@"result"]],nil);
//}
//
//@end
