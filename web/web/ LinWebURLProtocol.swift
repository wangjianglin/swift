//
//   LinWebURLProtocol.swift
//  LinWeb
//
//  Created by lin on 9/20/16.
//  Copyright © 2016 lin. All rights reserved.
//

import Foundation


public class LinWebURLProtocol : URLProtocol{
    
    open override class func canInit(with request: URLRequest) -> Bool{
        
        let url = request.url;
        
        if let absStr = url?.absoluteString {
        
            if absStr.hasPrefix("web://") {
                return true;
            }
        }
        return false;
        
    }
    
    open override class func canonicalRequest(for request: URLRequest) -> URLRequest{
        return request;
    }
    
    open override class func requestIsCacheEquivalent(_ a: URLRequest, to b: URLRequest) -> Bool{
        return super.requestIsCacheEquivalent(a, to: b);
    }
    
    public override func startLoading() {
        print("ok..");
    }
    
    public override func stopLoading(){
        print("....................");
    }
    
    open override class func canInit(with task: URLSessionTask) -> Bool{
        
        if let absStr = task.currentRequest?.url?.absoluteString {
            
            if absStr.hasPrefix("web://") {
                return true;
            }
        }
        return false;
    }
}
