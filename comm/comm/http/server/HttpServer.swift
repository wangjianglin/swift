//
//  Server.swift
//  LinClient
//
//  Created by lin on 6/3/15.
//  Copyright (c) 2015 lin. All rights reserved.
//

import Foundation

//static var httpServer:HTTPServer;
open class HttpServer{
    
    fileprivate var webPath:String;
    fileprivate var port:UInt16;
    
    fileprivate var httpServer = HTTPServer();
    
    public init(documentRoot webPath:String,port:UInt16 = 80){
        
        self.webPath = webPath;
        self.port = port;
        
        httpServer.type = "_http._tcp.";
        
        //        NSString *webPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Web"];
        //        let webPath = NSBundle.mainBundle().resourcePath!.stringByAppendingPathComponent("web");
//        let webPath = NSBundle.mainBundle().resourcePath!.stringByAppendingString("/web");
        //        DDLogInfo(@"Setting document root: %@", webPath);
        
        //        [httpServer setDocumentRoot:webPath];
        httpServer.documentRoot = webPath;
        httpServer.port = port;
        
        httpServer.connectionClass = LinHTTPConnection.self;
    }
    
    open func start()->Bool{
        do {
            //        isDir.initialize(NSError(false));
            try httpServer.start()
            return true;
        } catch _ {
        };
        return false;
    }
    
    open func stop(){
        httpServer.stop(true)
    }
    
    open func shutdown(){
        httpServer.stop(false);
    }
    
    open func registerForPost(_ path:String,action:@escaping (_ request:HttpRequest)->HttpResponse!){
        self.registerImpl(HttpMethod.POST, path: path, action: action);
    }
    open func registerForGet(_ path:String,action:@escaping (_ request:HttpRequest)->HttpResponse!){
        self.registerImpl(HttpMethod.GET, path: path, action: action);
    }
    
    open func register(_ path:String,action:@escaping (_ request:HttpRequest)->HttpResponse!){
        self.registerImpl(nil, path: path, action: action);
    }
    fileprivate func registerImpl(_ method:HttpMethod!,path:String,action:@escaping (_ request:HttpRequest)->HttpResponse!){
//        HTTPConnection.register(method, path: path) { (connection, method, path) -> (HttpResponse & NSObjectProtocol)? in
//            
//            let response = action(CocoaHttpServerRequest(message: connection.request));
//            if response == nil {
////                return HTTPDataResponse(data:"==".data(using: String.Encoding.utf8, allowLossyConversion: true));
//                let data = "==".data(using: String.Encoding.utf8, allowLossyConversion: true)
//                return HttpDataResponse(data:data);
//            }
//            return nil;
//        }
        
        HTTPConnection.register(method, path: path) { (connection, method, path) -> (ServerHttpResponse & NSObjectProtocol)? in
            let response = action(CocoaHttpServerRequest(message: connection.request));
            if response == nil {
//                return HTTPDataResponse(data:"==".data(using: String.Encoding.utf8, allowLossyConversion: true));
                let data = "==".data(using: String.Encoding.utf8, allowLossyConversion: true)
                return HttpDataResponse(data:data);
            }
            return nil;
        }
        
//        HTTPConnection.register(method,path:path,action:{(connection, method, path)->(HttpResponse & NSObjectProtocol)? in
//                let response = action(CocoaHttpServerRequest(message: connection.request));
//                if response == nil {
//    //                return HTTPDataResponse(data:"==".data(using: String.Encoding.utf8, allowLossyConversion: true));
//                    let data = "==".data(using: String.Encoding.utf8, allowLossyConversion: true)
//                    return HttpDataResponse(data:data);
//                }
//                return nil;
//        })
    }
//    public func test(){
////        httpServer = [[HTTPServer alloc] init];
//        
////        [httpServer setType:@"_http._tcp."];
//        httpServer.setType("_http._tcp.");
//        
////        NSString *webPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Web"];
////        let webPath = NSBundle.mainBundle().resourcePath!.stringByAppendingPathComponent("web");
//        let webPath = NSBundle.mainBundle().resourcePath!.stringByAppendingString("/web");
////        DDLogInfo(@"Setting document root: %@", webPath);
//        
////        [httpServer setDocumentRoot:webPath];
//        httpServer.setDocumentRoot(webPath);
//        httpServer.setPort(8099);
//        
//        httpServer.setConnectionClass(LinHTTPConnection);
//        
////        var error:CMutablePointer<NSError>;
////        var error = UnsafeMutablePointer<NSError>.alloc(1);
//        do {
//            //        isDir.initialize(NSError(false));
//            try httpServer.start()
//        } catch _ {
//        };
////        NSError *error;
////        if([httpServer start:&error])
////        {
////            DDLogInfo(@"Started HTTP Server on port %hu", [httpServer listeningPort]);
////        }
////        else
////        {
////            DDLogError(@"Error starting HTTP Server: %@", error);
////        }
//        
//        HTTPConnection.register("*", path: "/test.action") { (connection, method, path) -> protocol<NSObjectProtocol, HTTPResponse>! in
//            
//            return HTTPDataResponse(data:"ok.".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true));
////            return "ok.";
//        }
//    }
}
