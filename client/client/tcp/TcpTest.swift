//
//  TcpTest.swift
//  LinClient
//
//  Created by lin on 1/27/16.
//  Copyright © 2016 lin. All rights reserved.
//


public func testCommClient(){
    let comm:TcpCommunicate = TcpClientCommunicate(host: "192.168.1.66", port: 7890) { (session, pack, response) -> () in
        print("pack:\(pack)");
    };
    
    let commandPack = TcpCommandDetectPackage();
    print(commandPack.command)
    //print((Mirror(reflecting: commandPack).subjectType as! TcpCommandDetectPackage.Type).command)
    //        print("\(LinClient.TcpCommandDetectPackage.command)");
    //        commandPack.test()
    comm.start();
    let jsonPack = TcpJsonRequestPackage();
    
    jsonPack.addHeader("name", value: "value");
    
    let rpack = comm.send(jsonPack).response as! TcpJsonPackage;
//            rpack.header("name", value:"value");
    print(rpack);
    //comm.send(pack);
}