//
//  ServerSocket.swift
//  LinUtil
//
//  Created by lin on 1/19/16.
//  Copyright © 2016 lin. All rights reserved.
//

import Foundation

protocol AbstractServerSocketImpl{
    init(port:Int);
    
//    func listener();
    
    func listener()->Bool;
    
    
    func accept()->Socket!;
    
    func close();
}


public class ServerSocket{
    
    private var impl:AbstractServerSocketImpl
    
    public init(port:Int,type:SocketType = SocketType.CFNetwork){

//        switch(type){
//        case .BSD:
            impl = ServerSocketBSDImpl(port: port);
//        case .NSStream:
//            impl = ServerSocketNSStreamImpl(port: port);
//        default:
//            impl = ServerSocketCFNetworkImpl(port: port);
//        }
    }
    
//    public func listener(){
//        impl.listener();
//    }
    
    public func listener()->Bool{
        return impl.listener();
    }
    
    public func accept()->Socket!{
        return impl.accept();
    }
    
    public func close(){
        impl.close();
    }
}

