//
//  SocketBADImpl.swift
//  LinUtil
//
//  Created by lin on 1/19/16.
//  Copyright © 2016 lin. All rights reserved.
//

import Foundation

class SocketBSDImpl:AbstractSocketImpl{
    private var fd:Int32;
    private var addr:SocketAddress;
    
    init(fd:Int32,addr:SocketAddress){
        self.fd = fd;
        self.addr = addr;
    }
    required init(host:String,port:Int){
        self.addr = sockaddr_in(address: host, port: port);
        fd = socket(AF_INET, SOCK_STREAM, 0);
    }
    func connect() -> Bool {
        let rc = withUnsafePointer(&addr) { ptr -> Int32 in
            let bptr = UnsafePointer<sockaddr>(ptr) // cast
            return Darwin.connect(fd, bptr, socklen_t(addr.len)) //only returns block
        }
        if(rc == 0){
            return true;
        }
        return false;
    }
    func write(str:String){
        var buffer = str.cStringUsingEncoding(NSUTF8StringEncoding)!;
        let arrayPtr = UnsafeMutableBufferPointer<CChar>(start: &buffer, count: buffer.count)
        writeImpl(arrayPtr.baseAddress,count: buffer.count);
    }
    func write(var buffer:[UInt8],var count:Int = 0){
        //Darwin.wri
        //dispatch_write
        let arrayPtr = UnsafeMutableBufferPointer<UInt8>(start: &buffer, count: buffer.count)
        //let basePtr = arrayPtr.baseAddress as UnsafeMutablePointer<UInt8>
        if(count <= 0 ){
            count = buffer.count;
        }
        writeImpl(arrayPtr.baseAddress,count: count);
    }
    
    private func writeImpl(buffer:UnsafePointer<Void>,count:Int){
        Darwin.send(fd, buffer, count, 0);
    }
    func read(inout buffer:[UInt8])->Int{
    

        let arrayPtr = UnsafeMutableBufferPointer<UInt8>(start: &buffer, count: buffer.count)
        //let basePtr = arrayPtr.baseAddress as UnsafeMutablePointer<UInt8>
        return Darwin.recv(fd,arrayPtr.baseAddress,buffer.count,0);

//        var readBufferPtr  = UnsafeMutablePointer<CChar>.alloc(4096 + 2)
    }
    
    func close(){
        Darwin.shutdown(fd, SHUT_RDWR);
    }
}


//et fd:Int32 = socket(AF_INET, SOCK_STREAM, 0);
//
//var addr = sockaddr_in(address: "localhost",port: 1337);
//
//let rc = withUnsafePointer(&addr) { ptr -> Int32 in
//    let bptr = UnsafePointer<sockaddr>(ptr) // cast
//    return Darwin.connect(fd, bptr, socklen_t(addr.len)) //only returns block
//}
//
//var readBufferPtr  = UnsafeMutablePointer<CChar>.alloc(4096 + 2)
//let bptr = UnsafePointer<CChar>(readBufferPtr)
//let c = Darwin.read(fd, readBufferPtr, 4096)
//print(c);
//print("r:\(String.fromCString(bptr))");