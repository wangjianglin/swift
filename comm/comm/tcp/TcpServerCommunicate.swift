//
//  TcpServerCommunicate.swift
//  LinClient
//
//  Created by lin on 1/21/16.
//  Copyright © 2016 lin. All rights reserved.
//

import CessUtil


open class TcpServerCommunicate : TcpAbstractCommunicate{
    
    fileprivate var set:AutoResetEvent = AutoResetEvent(isSet: false);
    fileprivate var serverSocket:ServerSocket;
    fileprivate var isClose:Bool = false;
    fileprivate var listener:TcpCommunicateListener;
    
    fileprivate var queue:Queue = Queue(count: 20);
    
    public init(port:Int,listener:@escaping TcpCommunicateListener){
        
        serverSocket = ServerSocket(port: port, type: SocketType.bsd);
        self.listener = listener;
    }
    
    open override func start() -> Bool {
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
    
    fileprivate func listener(_ client:Socket){
        
        
        let session = TcpSession(socket: client);

        let recv = TcpCommunicateRecv(comm: self, session: session, listener: self.listener);
        session.recv = recv;

        recv.recvData();
    }
    
    
    open override func close() {
        isClose = true;
        serverSocket.close();
    }
}
