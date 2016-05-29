//
//  ServerSocketBSDImpl.swift
//  LinUtil
//
//  Created by lin on 1/19/16.
//  Copyright © 2016 lin. All rights reserved.
//

import Foundation


class ServerSocketBSDImpl: AbstractServerSocketImpl {
    private var fd:Int32;
    private var port:Int;
    required init(port:Int){
        print(AF_INET)
        fd = Darwin.socket(AF_INET, SOCK_STREAM, 0);
        self.port = port;
    }
    
//    func listener(){
//        Darwin.listen(fd, 0);
//    }
    
    func bind() -> Bool {
//        guard fd.isValid else { return false }
//        
//        guard !isBound else {
//            print("Socket is already bound!")
//            return false
//        }
        
        // Note: must be 'var' for ptr stuff, can't use let
        var addr = sockaddr_in(port: 567)
        
        let rc = withUnsafePointer(&addr) { ptr -> Int32 in
            let bptr = UnsafePointer<sockaddr>(ptr) // cast
            return Darwin.bind(fd, bptr, socklen_t(addr.len))
        }
        
//        if rc == 0 {
//            // Generics TBD: cannot check for isWildcardPort, always grab the name
//            //boundAddress = getsockname()
//            /* if it was a wildcard port bind, get the address */
//            // boundAddress = addr.isWildcardPort ? getsockname() : addr
//        }
        
        return rc == 0 ? true : false
    }
    
    func listener()->Bool{
        //_: Int32, _: UnsafeMutablePointer<sockaddr>, _: UnsafeMutablePointer<socklen_t>) -> Int32

//        let add = UnsafeMutablePointer<sockaddr>.alloc(1);
//        let socklen = UnsafeMutablePointer<socklen_t>.alloc(1);
//        var clientFd = Darwin.accept(fd, add, socklen);
        
        //Darwin.bind(Int32, UnsafePointer<sockaddr>, socklen_t)
        
        if !bind() {
            return false;
        }
        
        if Darwin.listen(fd, 30) != 0 {
            return false;
        }
        
        return true;
    }
    
    func accept()->Socket!{
        var baddr    = sockaddr_in()
        var baddrlen = socklen_t(baddr.len)
        
        let newFD = withUnsafeMutablePointer(&baddr) {
            ptr -> Int32 in
            let bptr = UnsafeMutablePointer<sockaddr>(ptr) // cast
            return Darwin.accept(fd, bptr, &baddrlen);// buflenptr)
        }
        
        print(baddr.address.asString)
        print(baddr.port)
        
        if newFD > 0 {
            let client = Socket(impl: SocketBSDImpl(fd: newFD, addr: baddr));
            return client;
        }
        return nil;
    }
    
    func close(){
        
    }
}