//
//  Utils.swift
//  LinServer
//
//  Created by lin on 5/15/16.
//  Copyright © 2016 lin. All rights reserved.
//

import Foundation


open class Utils{
    
//    public class func getIfAddress(){
//        var addresses = [String]()
//        
//        // Get list of all interfaces on the local machine:
//        var ifaddr : UnsafeMutablePointer<ifaddrs> = nil
//        if getifaddrs(&ifaddr) == 0 {
//            
//            // For each interface ...
//            var ptr = ifaddr
//            while ptr != nil {
//                defer { ptr = ptr.memory.ifa_next }
//                
//                let flags = Int32(ptr.memory.ifa_flags)
//                var addr = ptr.memory.ifa_addr.memory
//                
//                // Check for running IPv4, IPv6 interfaces. Skip the loopback interface.
//                if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
//                    if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
//                        
//                        // Convert interface address to a human readable string:
//                        var hostname = [CChar](count: Int(NI_MAXHOST), repeatedValue: 0)
//                        if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),
//                            nil, socklen_t(0), NI_NUMERICHOST) == 0) {
//                            if let address = String.fromCString(hostname) {
//                                addresses.append(address)
//                            }
//                        }
//                    }
//                }
//            }
//            freeifaddrs(ifaddr)
//        }
//        
//        print(addresses)
//    }
}
