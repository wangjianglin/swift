//
//  SocketBADImpl.swift
//  LinUtil
//
//  Created by lin on 1/19/16.
//  Copyright © 2016 lin. All rights reserved.
//

import Foundation

class SocketBSDImpl:AbstractSocketImpl{
    fileprivate var fd:Int32;
    fileprivate var addr:SocketAddress;
    
    init(fd:Int32,addr:SocketAddress){
        self.fd = fd;
        self.addr = addr;
    }
    required init(host:String,port:Int){
        self.addr = sockaddr_in(address: host, port: port);
        fd = socket(AF_INET, SOCK_STREAM, 0);
    }
    func connect() -> Bool {
        let rc = withUnsafePointer(to: &addr) { ptr -> Int32 in
//            let bptr = UnsafePointer<sockaddr>(ptr) // cast
//            return Darwin.connect(fd, bptr, socklen_t(addr.len)) //only returns block
            return ptr.withMemoryRebound(to: sockaddr.self, capacity: 1, { (bptr) -> Int32 in
                return Darwin.connect(fd, bptr, socklen_t(addr.len));
            })
        }
        if(rc == 0){
            return true;
        }
        return false;
    }
    func write(_ str:String){
        var buffer = str.cString(using: String.Encoding.utf8)!;
        let arrayPtr = UnsafeMutableBufferPointer<CChar>(start: &buffer, count: buffer.count)
        writeImpl(arrayPtr.baseAddress!,count: buffer.count);
    }
    func write(_ buffer:[UInt8],count:Int = 0){
        var buffer = buffer, count = count
        //Darwin.wri
        //dispatch_write
        let arrayPtr = UnsafeMutableBufferPointer<UInt8>(start: &buffer, count: buffer.count)
        //let basePtr = arrayPtr.baseAddress as UnsafeMutablePointer<UInt8>
        if(count <= 0 ){
            count = buffer.count;
        }
        writeImpl(arrayPtr.baseAddress!,count: count);
    }
    
    fileprivate func writeImpl(_ buffer:UnsafeRawPointer,count:Int){
        Darwin.send(fd, buffer, count, 0);
    }
    func read(_ buffer:inout [UInt8])->Int{
    

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
