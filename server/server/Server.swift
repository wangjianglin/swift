//
//  Server.swift
//  LinClient
//
//  Created by lin on 6/3/15.
//  Copyright (c) 2015 lin. All rights reserved.
//

import Foundation

//static var httpServer:HTTPServer;
public class Server{
    
    public init(){}
    var httpServer = HTTPServer();
    public func test(){
//        httpServer = [[HTTPServer alloc] init];
        
//        [httpServer setType:@"_http._tcp."];
        httpServer.setType("_http._tcp.");
        
//        NSString *webPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Web"];
//        let webPath = NSBundle.mainBundle().resourcePath!.stringByAppendingPathComponent("web");
        let webPath = NSBundle.mainBundle().resourcePath!.stringByAppendingString("/web");
//        DDLogInfo(@"Setting document root: %@", webPath);
        
//        [httpServer setDocumentRoot:webPath];
        httpServer.setDocumentRoot(webPath);
        httpServer.setPort(8099);
        
        httpServer.setConnectionClass(LinHTTPConnection);
        
//        var error:CMutablePointer<NSError>;
//        var error = UnsafeMutablePointer<NSError>.alloc(1);
        do {
            //        isDir.initialize(NSError(false));
            try httpServer.start()
        } catch _ {
        };
//        NSError *error;
//        if([httpServer start:&error])
//        {
//            DDLogInfo(@"Started HTTP Server on port %hu", [httpServer listeningPort]);
//        }
//        else
//        {
//            DDLogError(@"Error starting HTTP Server: %@", error);
//        }
        
        HTTPConnection.register("*", path: "/test.action") { (connection, method, path) -> protocol<NSObjectProtocol, HTTPResponse>! in
            
            return HTTPDataResponse(data:"ok.".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true));
//            return "ok.";
        }
    }
}