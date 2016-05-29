//
//  Session.swift
//  LinClient
//
//  Created by lin on 1/21/16.
//  Copyright © 2016 lin. All rights reserved.
//

import LinUtil

public class TcpSession{
    
    
    private var _socket:Socket;
    var recv:TcpCommunicateRecv!;
    public var socket:Socket{
        return _socket;
    }
    
    init(socket:Socket){
        self._socket = socket;
    }
    
    public func send(pack:TcpRequestPackage)->TcpPackageResponse{

        let response = TcpPackageResponse();
        recv.addRequest(pack.sequeue, response: response)
        sendImpl(pack);
        return response;
    }
    
    func response(pack:TcpResponsePackage){
        sendImpl(pack);
    }
    
    private func sendImpl(pack:TcpPackage){

        let bs = pack.write();
        var tmpBs = [UInt8](count: 2 * bs.count + 3 + 18, repeatedValue: 0);

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
        
        for(var n = 0;n<bs.count;n++)
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
            pos++;
        }

        tmpBs[pos] = 0xC0;
        
        synchronized(self) { () -> () in
            self.socket.write(tmpBs, count: pos + 1);
        }

    }
}