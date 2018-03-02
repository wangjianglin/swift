//
//  TcpClientCommunicate.swift
//  LinClient
//
//  Created by lin on 1/21/16.
//  Copyright © 2016 lin. All rights reserved.
//

import CessUtil

open class TcpClientCommunicate:TcpAbstractCommunicate{
    
    fileprivate var socket:Socket;
    fileprivate var listener:TcpCommunicateListener;
    fileprivate var session:TcpSession;
    fileprivate var recv:TcpCommunicateRecv!;
    
    public init(host:String,port:Int,listener:@escaping TcpCommunicateListener){
        socket = Socket(host: host, port: port);
        
        self.listener = listener;
        session = TcpSession(socket: socket);
        
        super.init();
        
        recv = TcpCommunicateRecv(comm: self, session: self.session, listener: self.listener);
        session.recv = recv;
        
    }
    
    open override func start() -> Bool {
        if(socket.connect()){
            Queue.asynThread(recv.recvData);
            return true;
        }
        return false;
    }
    
    
    override open func send(_ pack: TcpRequestPackage)->TcpPackageResponse {
        return session.send(pack);
    }
}
