//
//  ViewController.swift
//  demo
//
//  Created by lin on 1/19/16.
//  Copyright © 2016 lin. All rights reserved.
//

import UIKit
import CessUtil
import CessComm

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

public var flag:Bool = false;
public var identifier1:String! = nil;
public var identifier2:String! = nil;

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        
//        for n in 0...100{
//            
//            print("*******\(n)")
//            Queue.asynQueue({ 
//                print("n:\(n)")
//            })
//            print("=====\(n)")
//        }
        
        //testServer();
        
//        LinClient.testCommClient();
//        testCommClient();
        
        
        //test(buffer,count: count);
        //let s = NSString(data: data, encoding: NSUTF8StringEncoding)
        //print("s:\(s)")
        //basePtr.dealloc(count);
//        let socket = SocketIP4();
        //socket.test();
    }
    
    @IBAction func show(){
    UIAlertView.show("flag:\(flag)\t identifier1:\(identifier1)\tidentifier2:\(identifier2)");
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
        let serverSocket = ServerSocket(port: 456,type: .bsd);
        
        
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
    
    fileprivate var server:HttpServer!;
    @IBAction func serverAction(){
        
        server = HttpServer(documentRoot: pathFor(Documents.bundle, path: "web")!,port:8099);
        
        server.register("/test.action") { (request) -> HttpResponse! in
            return nil;
        }
        print("\(server.start())");
    }
    
    
    func tcp(){
    
        let socket = Socket(host: "192.168.1.66",port: 1337);
        var buffer = [UInt8](repeating: 0, count: 1024);
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
        
        let s = StringExt.fromBuffer(buffer, count: count);
        print("s:\(s)")
        socket.write("ok.");
        
        socket.close();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func http(){
        CessComm.HttpCommunicate.commUrl = "http://s.feicuibaba.com";
        
        let pack = TestPackage();
        pack.data = "测试数据！";
        
        _ = HttpCommunicate.request(pack, result: { (obj, warning) in
            print("obj:\(obj)");
        }) { (error) in
            print("error:\(error)");
        };
    }
    
    
    @IBAction func down1(){
        
        //        HttpCommunicate.download(url: "http://www.feicuibaba.com/data2.zip").waitForEnd();
        let pack = HttpDownloadPackage(url: "http://www.feicuibaba.com/data3.zip");
        pack.identifier = "identifier1";
//        HttpCommunicate.download(url: "http://www.feicuibaba.com/data2.zip", result: { (fileInfo, erros) in
        _ = HttpCommunicate.download(package:pack, result: { (fileInfo, erros) in
            print(fileInfo?.location);
            print(fileInfo?.fileName);
            
            Queue.mainQueue {
                UIAlertView(title: "", message: "\(fileInfo?.location)", delegate: nil, cancelButtonTitle: "ok").show();
            }
            }, fault: { (error) in
                print(error)
        }) { (_ down: Int64, _ expected: Int64, _ bytes: Int64) in
            print("down:\(down)\texpected:\(expected)\tbytes:\(bytes)");
        }
        
    }
    
    @IBAction func down2(){
        
        let pack = HttpDownloadPackage(url: "http://www.feicuibaba.com/data2.zip");
        pack.identifier = "identifier2";
        //        HttpCommunicate.download(url: "http://www.feicuibaba.com/data2.zip", result: { (fileInfo, erros) in
        _ = HttpCommunicate.download(package:pack, result: { (fileInfo, erros) in
            print(fileInfo?.location ?? "");
            print(fileInfo?.fileName ?? "");
            
            Queue.mainQueue {
                UIAlertView(title: "", message: "\(fileInfo?.location)", delegate: nil, cancelButtonTitle: "ok").show();
            }
            }, fault: { (error) in
                print(error)
        }) { (_ down: Int64, _ expected: Int64, _ bytes: Int64) in
            print("down:\(down)\texpected:\(expected)\tbytes:\(bytes)");
        }
        
    }
    
    @IBAction func upload(){
        
        CessComm.HttpCommunicate.commUrl = "http://192.168.1.66:8080";
        
        let uploadPackage = HttpUploadPackage(url: "upload.action");
        uploadPackage.addFile("file", file: "data2.zip");
        
        HttpCommunicate.upload(uploadPackage, result: { (result, warning) in
            print(result ?? "")
            }, fault: { (error) in
                print(error)
            }) { (send, total,bytes) in
                print("send:\(send)\ttotal:\(total)\tbytes:\(bytes)");
        }
    }
}

class TestPackage: HttpPackage {
    
    init(){
//        super.init(url: "/core/comm/test.action", method: HttpMethod.POST);
        super.init(url: "http://127.0.0.1:5555/shorturl/", method: HttpMethod.POST);
    }
    
    var data:String{
        get{return self["data"].asString("");}
        set{self.setValue(newValue as AnyObject?, forName: "data");}
    }
}

