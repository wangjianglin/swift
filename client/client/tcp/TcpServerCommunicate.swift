//
//  TcpServerCommunicate.swift
//  LinClient
//
//  Created by lin on 1/21/16.
//  Copyright © 2016 lin. All rights reserved.
//

import LinUtil


public class TcpServerCommunicate : TcpAbstractCommunicate{
    
    private var set:AutoResetEvent = AutoResetEvent(isSet: false);
    private var serverSocket:ServerSocket;
    private var isClose:Bool = false;
    private var listener:TcpCommunicateListener;
    
    private var queue:Queue = Queue(count: 20);
    
    public init(port:Int,listener:TcpCommunicateListener){
        
        serverSocket = ServerSocket(port: port, type: SocketType.BSD);
        self.listener = listener;
    }
    
    public override func start() -> Bool {
        if serverSocket.listener() {
            
            
            queue.asynQueue({ () -> () in
                
                while !self.isClose {
                    if let client = self.serverSocket.accept() {
                        self.queue.asynQueue({ () -> () in
                            self.listener(client);
                        })
                    }
                }
            });
            
            return true;
        }
        
        return false;
    }
    
    private func listener(client:Socket){
        
        
        let session = TcpSession(socket: client);

        let recv = TcpCommunicateRecv(comm: self, session: session, listener: self.listener);
        session.recv = recv;

        recv.recvData();
    }
    
    
    public override func close() {
        isClose = true;
        serverSocket.close();
    }
}
