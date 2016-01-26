//
//  Socket.swift
//  LinUtil
//
//  Created by lin on 1/19/16.
//  Copyright © 2016 lin. All rights reserved.
//

import Foundation
import Darwin

//public typealias SocketIP4 = Socket<sockaddr_in>;


protocol AbstractSocketImpl{
    
    init(host:String,port:Int);
    func connect()->Bool;
    func write(buffer:[UInt8],count:Int);
    func write(str:String);
    
    func read(inout buffer:[UInt8])->Int;
    
    
    func close();
}

//public class Socket<T:SocketAddress>{
public class Socket{
    
//    private var host:String!;
//    private var port:Int32!;
//    private var type:SocketType!;
    
    private var impl:AbstractSocketImpl;
    
    init(impl:AbstractSocketImpl){
        self.impl = impl;
    }
    
    //public init(){}
    
    public init(host:String,port:Int,type:SocketType = SocketType.CFNetwork){
        
//        switch(type){
//        case .BSD:
            impl = SocketBSDImpl(host: host, port: port);
//        case .NSStream:
//            impl = SocketNSStreamImpl(host: host, port: port);
//        default:
//            impl = SocketCFNetworkImpl(host: host, port: port);
//        }
        
    }
    
    public func connect()->Bool{
        return impl.connect();
    }
    
//    public func connect(){
//        
//    }
//    
//    public func connect(host:String,port:Int32){
//        
//    }
    
    public func write(buffer:[UInt8],count:Int = 0){
        impl.write(buffer, count: count);
    }
    public func write(str:String){
        impl.write(str);
    }
    
    public func read(inout buffer:[UInt8])->Int{
        return impl.read(&buffer);
    }
    
    public func close(){
        impl.close();
    }
    
    
//    public func test(){
//        let fd:Int32 = socket(AF_INET, SOCK_STREAM, 0);
//        
//        var addr = sockaddr_in(address: "localhost",port: 1337);
//        
//        let rc = withUnsafePointer(&addr) { ptr -> Int32 in
//            let bptr = UnsafePointer<sockaddr>(ptr) // cast
//            return Darwin.connect(fd, bptr, socklen_t(addr.len)) //only returns block
//        }
//        
//        var readBufferPtr  = UnsafeMutablePointer<CChar>.alloc(4096 + 2)
//        let bptr = UnsafePointer<CChar>(readBufferPtr)
//        let c = Darwin.read(fd, readBufferPtr, 4096)
//        print(c);
//        print("r:\(String.fromCString(bptr))");
    
//        sockaddr_in
//        
//        Darwin.connect(fd, <#T##UnsafePointer<sockaddr>#>, <#T##socklen_t#>)
        
//        if (socketFileDescriptor == -1) {
//            if ([self.delegate respondsToSelector:@selector(networkingResultsDidFail:)]) {
//                [self.delegate networkingResultsDidFail:@"Unable to allocate networking resources."];
//            }
//            
//            return;
//        }
//        
//        
//        // convert the hostname to an IP address
//        struct hostent *remoteHostEnt = gethostbyname([[url host] UTF8String]);
//        
//        if (remoteHostEnt == NULL) {
//            if ([self.delegate respondsToSelector:@selector(networkingResultsDidFail:)]) {
//                [self.delegate networkingResultsDidFail:@"Unable to resolve the hostname of the warehouse server."];
//            }
//            
//            return;
//        }
//        
//        struct in_addr *remoteInAddr = (struct in_addr *)remoteHostEnt->h_addr_list[0];
//        
//        // set the socket parameters to open that IP address
//        struct sockaddr_in socketParameters;
//        socketParameters.sin_family = AF_INET;
//        socketParameters.sin_addr = *remoteInAddr;
//        socketParameters.sin_port = htons([[url port] intValue]);
//        
//        // connect the socket; a return code of -1 indicates an error
//        if (connect(socketFileDescriptor, (struct sockaddr *) &socketParameters, sizeof(socketParameters)) == -1) {
//            NSLog(@"Failed to connect to %@", url);
//            
//            if ([self.delegate respondsToSelector:@selector(networkingResultsDidFail:)]) {
//                [self.delegate networkingResultsDidFail:@"Unable to connect to the warehouse server."];
//            }
//            
//            return;
//        }
//        
//        NSLog(@"Successfully connected to %@", url);
//        
//        NSMutableData *data = [[NSMutableData alloc] init];
//        BOOL waitingForData = YES;
//        
//        // continually receive data until we reach the end of the data
//        while (waitingForData){
//            const char *buffer[1024];
//            int length = sizeof(buffer);
//            
//            // read a buffer's amount of data from the socket; the number of bytes read is returned
//            int result = recv(socketFileDescriptor, &buffer, length, 0);
//            
//            // if we got data, append it to the buffer and keep looping
//            if (result > 0){
//                [data appendBytes:buffer length:result];
//                break;
//                
//                // if we didn't get any data, stop the receive loop
//            } else {
//                waitingForData = NO;
//            }
//        }
//        
//        // close the stream since we're done reading
//        close(socketFileDescriptor);
//        
//        
//        NSString *resultsString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        NSLog(@"Received string: '%@'", resultsString);
//        
//        LLNNetworkingResult *result = [self parseResultString:resultsString];
//        
//        if (result != nil) {
//            if ([self.delegate respondsToSelector:@selector(networkingResultsDidLoad:)]) {
//                [self.delegate networkingResultsDidLoad:result];
//            }
//            
//        } else {
//            if ([self.delegate respondsToSelector:@selector(networkingResultsDidFail:)]) {
//                [self.delegate networkingResultsDidFail:@"Unable to parse the response from the warehouse server."];
//            }
//        }
//    }
}