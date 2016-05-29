//
//  Server.swift
//  LinClient
//
//  Created by lin on 6/3/15.
//  Copyright (c) 2015 lin. All rights reserved.
//

import Foundation

//static var httpServer:HTTPServer;
public class HttpServer{
    
    private var webPath:String;
    private var port:UInt16;
    
    private var httpServer = HTTPServer();
    
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
    
    public func start()->Bool{
        do {
            //        isDir.initialize(NSError(false));
            try httpServer.start()
            return true;
        } catch _ {
        };
        return false;
    }
    
    public func stop(){
        httpServer.stop(true)
    }
    
    public func shutdown(){
        httpServer.stop(false);
    }
    
    public func registerForPost(path:String,action:(request:HttpRequest)->HttpResponse!){
        self.registerImpl(HttpMethod.POST, path: path, action: action);
    }
    public func registerForGet(path:String,action:(request:HttpRequest)->HttpResponse!){
        self.registerImpl(HttpMethod.GET, path: path, action: action);
    }
    
    public func register(path:String,action:(request:HttpRequest)->HttpResponse!){
        self.registerImpl(nil, path: path, action: action);
    }
    private func registerImpl(method:HttpMethod!,path:String,action:(request:HttpRequest)->HttpResponse!){
        HTTPConnection.register(method, path: path) { (connection, method, path) -> protocol<HTTPResponse, NSObjectProtocol>! in
            
            let response = action(request: CocoaHttpServerRequest(message: connection.request));
            if response == nil {
                return HTTPDataResponse(data:"==".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true));
            }
            return nil;
        }
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