//
//  TcpClientCommunicate.swift
//  LinClient
//
//  Created by lin on 1/21/16.
//  Copyright © 2016 lin. All rights reserved.
//

import LinUtil

public class TcpClientCommunicate:TcpAbstractCommunicate{
    
    private var socket:Socket;
    private var listener:TcpCommunicateListener;
    private var session:TcpSession;
    private var recv:TcpCommunicateRecv!;
    
    public init(host:String,port:Int,listener:TcpCommunicateListener){
        socket = Socket(host: host, port: port);
        
        self.listener = listener;
        session = TcpSession(socket: socket);
        
        super.init();
        
        recv = TcpCommunicateRecv(comm: self, session: self.session, listener: self.listener);
        session.recv = recv;
        
    }
    
    public override func start() -> Bool {
        if(socket.connect()){
            Queue.asynThread(recv.recvData);
            return true;
        }
        return false;
    }
    
    
    override public func send(pack: TcpRequestPackage)->TcpPackageResponse {
        return session.send(pack);
    }
}