//
//  Session.swift
//  LinClient
//
//  Created by lin on 1/21/16.
//  Copyright © 2016 lin. All rights reserved.
//

import LinUtil

open class TcpSession{
    
    
    fileprivate var _socket:Socket;
    var recv:TcpCommunicateRecv!;
    open var socket:Socket{
        return _socket;
    }
    
    init(socket:Socket){
        self._socket = socket;
    }
    
    open func send(_ pack:TcpRequestPackage)->TcpPackageResponse{

        let response = TcpPackageResponse();
        recv.addRequest(pack.sequeue, response: response)
        sendImpl(pack);
        return response;
    }
    
    func response(_ pack:TcpResponsePackage){
        sendImpl(pack);
    }
    
    fileprivate func sendImpl(_ pack:TcpPackage){

        let bs = pack.write();
        var tmpBs = [UInt8](repeating: 0, count: 2 * bs.count + 3 + 18);

//    //将包中的数据写入数组
        tmpBs[0] = 0xC0;
        tmpBs[1] = pack.type;
        if(pack is TcpRequestPackage){
            tmpBs[2] = 0;
        }else{
            tmpBs[2] = 1;
        }
        
        writeInt64(&tmpBs,value: asInt64(pack.sequeue),offset: 3);

        var pos = 11;
        
        for n in 0 ..< bs.count 
        {
            if(bs[n] == 0xC0){
                tmpBs[pos] = 0xDB;
                tmpBs[pos] = 0xDC;
                pos += 2;
                continue;
            }
            if(bs[n] == 0xDB){
                tmpBs[pos] = 0xDB;
                tmpBs[pos] = 0xDD;
                pos += 2;
                continue;
            }
            tmpBs[pos] = bs[n];
            pos += 1;
        }

        tmpBs[pos] = 0xC0;
        
        synchronized(self) { () -> () in
            self.socket.write(tmpBs, count: pos + 1);
        }

    }
}
