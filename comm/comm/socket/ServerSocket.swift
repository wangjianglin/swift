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


open class ServerSocket{
    
    fileprivate var impl:AbstractServerSocketImpl
    
    public init(port:Int,type:SocketType = SocketType.cfNetwork){

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
    
    open func listener()->Bool{
        return impl.listener();
    }
    
    open func accept()->Socket!{
        return impl.accept();
    }
    
    open func close(){
        impl.close();
    }
}

