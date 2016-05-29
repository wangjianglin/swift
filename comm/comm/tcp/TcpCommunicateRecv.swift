//
//  TcpCommunicateRecv.swift
//  LinClient
//
//  Created by lin on 1/21/16.
//  Copyright © 2016 lin. All rights reserved.
//

import LinUtil

class TcpCommunicateRecv {
    
    private var comm:TcpCommunicate;
    private var session:TcpSession;
    private var listener:TcpCommunicateListener;
    
    init(comm:TcpCommunicate,session:TcpSession,listener:TcpCommunicateListener){
        self.comm = comm;
        self.session = session;
        self.listener = listener;
    }
    
    private static var bufferSize:Int = 2048;
    private var dataType:UInt8 = 0;
    
    private var isDB:Bool = false;
    
    private var isFirst:Bool = true;


    private var sequeueCount:Int = 0;
    private var sequeue:Int64 = 0;
    
    private var queue:Queue = Queue(count: 10);
    
    func recvData()
    {
    
        var ch = [UInt8](count: TcpCommunicateRecv.bufferSize, repeatedValue: 0);

        var sequeueBytes = [UInt8](count: 9, repeatedValue: 0);
    
    //数据产生异常

        var parser:TcpProtocolParser? = nil;
        
        let initStatue = {()->() in
            self.isDB = false;
            self.isFirst = true;
            self.sequeueCount = 0;
            if let parser = parser{
                parser.clear();
            }
            parser = nil;
        };
    
        let socket = session.socket;
        var num = 0;
        var n = 0;
        while (true)
        {
            num = socket.read(&ch);
    
            if (num <= 0)
            {//连接已经断开
                
                break;
            }
            
            for (n = 0; n < num; n++)
            {
                if (ch[n] == 0xC0)
                {//如果isCo0为true，表示数据结束
                
                    if var parser = parser {
                        
                        if(sequeueBytes[0] == 0){
                            parser.state = TcpPackageState.REQUEST;
                        }else{
                            parser.state = TcpPackageState.RESPONSE;
                        }
                        let p = parser.parse();
                        if let p = p{
                            
                            let seq = readInt64(sequeueBytes, offset: 1);
                            (p as! TcpAbstractPackage).setSequeue(asUInt64(seq));
//                            if(sequeueBytes[0] == 0){
//                                p.setState(TcpPackageState.REQUEST);
//                            }else{
//                                p.setState(TcpPackageState.RESPONSE);
//                            }
                            
                            communicateListener(p);//
                        }
                    }
                    initStatue();
                    continue;
                }
                
                if (ch[n] == 0xDB)
                {
                    if (isDB)
                    {
                    //异常
                    //initStatue.run();
                        initStatue();
                        continue;
                    }
                    isDB = true;
                    continue;
                }
                if (isDB == true)//如果前一个数据为0xDB，则需要进行数据转义
                {
                    isDB = false;
                    if (ch[n] == 0xDC)
                    {
                        ch[n] = 0xC0;
                    }
                    else if (ch[n] == 0xDD)
                    {
                        ch[n] = 0xDB;
                    }
                    else
                    {
                //异常，回到初始状态
                        initStatue();
                        continue;
                    }
                }
                if (isFirst)
                {
                    dataType = ch[n];
                    
                    parser = getProtocolParser(dataType);
                    isFirst = false;
                    continue;
                }
                if (sequeueCount < sequeueBytes.count)
                {
                    sequeueBytes[sequeueCount++] = ch[n];
                    continue;
                }
                
                if let parser = parser {
                    parser.put(ch[n]);
                }
            }
        }
    }
    
    private func communicateListener(pack:TcpPackage){
        
        queue.asynQueue { () -> () in
            self.communicateListenerImpl(pack);
        }
    }
    
    private func communicateListenerImpl(pack:TcpPackage){

        var isResponse:Bool = false;
        
        if pack.state == TcpPackageState.REQUEST {
            self.listener(session: self.session, pack: pack, response: {p in
                isResponse = true;
                p.setSequeue(pack.sequeue);
                self.session.response(p);
            });
        }else{
            self.listener(session: self.session, pack: pack, response: {p in
                
            });
        }
        
        if pack.state == TcpPackageState.RESPONSE {
            if let response = sequeues[pack.sequeue] {
                response.response(pack);
            }
        }
        
        if pack.state == TcpPackageState.REQUEST && !isResponse {
            let p = TcpEmptyPackage();
            p.setSequeue(pack.sequeue);
            session.response(p);
        }

    }
    
    private var sequeues:Dictionary<UInt64,TcpPackageResponse> = [:];
    
    func addRequest(sequeue:UInt64,response:TcpPackageResponse){
        sequeues[sequeue] = response;
    }
    
    
    private var parsers:Dictionary<UInt8,TcpProtocolParser> = [:];
    
    private func getProtocolParser(type:UInt8)->TcpProtocolParser!{
        
        if let r = parsers[type] {
            return r;
        }
        let cls = ProtocolParsers.get(type);
        if let cls = cls{
            parsers[type] = cls.init();
            return parsers[type];
        }
        return nil;
    }
}