//
//  ViewController.swift
//  demo
//
//  Created by lin on 1/19/16.
//  Copyright © 2016 lin. All rights reserved.
//

import UIKit
import LinClient
import LinUtil

//public class TcpCommandDetectPackage2 : TcpCommandPackage{
//    
//    override public class var command:Int32{
//        return 0x1;
//    }
//    
////    public override var command:Int32{
////        return (Mirror(reflecting: self).subjectType as! TcpCommandPackage.Type).command;
////    }
//}


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        print(UInt64.max)
        
        //testServer();
        
        LinClient.testCommClient();
        testCommClient();
        
        
        //test(buffer,count: count);
        //let s = NSString(data: data, encoding: NSUTF8StringEncoding)
        //print("s:\(s)")
        //basePtr.dealloc(count);
//        let socket = SocketIP4();
        //socket.test();
    }
    
    func testCommClient(){
        let comm:TcpCommunicate = TcpClientCommunicate(host: "192.168.1.66", port: 7890) { (session, pack, response) -> () in
            print("pack:\(pack)");
        };
        
        //print((Mirror(reflecting: commandPack).subjectType as! TcpCommandDetectPackage.Type).command)
        //        print("\(LinClient.TcpCommandDetectPackage.command)");
        //        commandPack.test()
        comm.start();
        
        
        
        //    let commandPack = TcpCommandDetectPackage();
        //    print(commandPack.command)
        //    let response = comm.send(commandPack);
        //
        //    print("response:\(response.response)");
        
        let jsonPack = TcpJsonRequestPackage();
        
        jsonPack.addHeader("name", value: "value");
        
        let rpack = comm.send(jsonPack).response as! TcpJsonPackage;
        //            rpack.header("name", value:"value");
        print(rpack);
        //comm.send(pack);
    }
    
    func testServer(){
        let serverSocket = ServerSocket(port: 456,type: .BSD);
        
        
//        serverSocket.listener { (client) -> () in
//            var buffer = [UInt8](count: 1024, repeatedValue: 0);
//            let count = client.read(&buffer)
//            let s = String.fromBuffer(buffer, count: count);
//            print("s:\(s)")
//            print("ok.");
//            client.write("resp!");
//            
//            print(" ok.");
//        }
    }
    
    internal func test(){
        
        let socket = Socket(host: "192.168.1.66",port: 1337);
        var buffer = [UInt8](count: 1024, repeatedValue: 0);
        socket.connect();
        let count = socket.read(&buffer)
        
//        let arrayPtr = UnsafeMutableBufferPointer<UInt8>(start: &buffer, count: buffer.count)
//        //arrayPtr.
//        //let arrayPtr = UnsafeMutableBufferPointer<UInt8>(start: buffer, count: buffer.count)
//        //        var readBufferPtr  = UnsafeMutablePointer<CChar>.alloc(4096 + 2)
//        ////        return withUnsafeMutablePointer(&buffer) { (ptr) -> Int32 in
//        //        var readBufferPtr  = UnsafeMutablePointer<CChar>(arrayPtr)
//        let basePtr = arrayPtr.baseAddress as UnsafeMutablePointer<UInt8>
//        
//        let data = NSData(bytesNoCopy: basePtr, length: count,freeWhenDone:false);
//        let s = NSString(data: data, encoding: NSUTF8StringEncoding) as! String
        
        let s = String.fromBuffer(buffer, count: count);
        print("s:\(s)")
        socket.write("ok.");
        
        socket.close();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

