//
//  Network.swift
//  LinCore
//
//  Created by lin on 9/30/15.
//  Copyright © 2015 lin. All rights reserved.
//

import Foundation
import SystemConfiguration


public class Network{
    
    private class func connectedToNetwork()->Bool{
        
//    + (BOOL) connectedToNetwork
//    // ----------------------------------------------------------------------------------------------------------
//    {
//        sockaddr_in 
//        var zeroAddress:sockaddr_in;
        let zeroAddressPrt:UnsafeMutablePointer<sockaddr_in> = UnsafeMutablePointer<sockaddr_in>.alloc(1);
        
//        bzero(<#T##UnsafeMutablePointer<Void>#>, <#T##Int#>)
        bzero(zeroAddressPrt, sizeof(sockaddr_in));
//    struct sockaddr_in zeroAddress;
//    bzero(&zeroAddress, sizeof(zeroAddress));
//    zeroAddress.sin_len = sizeof(zeroAddress);
        var zeroAddress:sockaddr_in = zeroAddressPrt.move();
        zeroAddress.sin_len = __uint8_t(sizeof(sockaddr_in));
        
//    zeroAddress.sin_family = AF_INET;
        zeroAddress.sin_family = __uint8_t(AF_INET);
//    // 以下objc相关函数、类型需要添加System Configuration 框架
//    // 用0.0.0.0来判断本机网络状态
//    SCNetworkReachabilityRef defaultRouteReachability =
//    SCNetworkReachabilityCreateWithAddress(NULL, (struct
//    sockaddr*)&zeroAddress);
        var defaultRouteReachability:SCNetworkReachabilityRef = SCNetworkReachabilityCreateWithAddress(nil,UnsafePointer(zeroAddressPrt))!;
//    SCNetworkReachabilityFlags flags;
//    BOOL didRetrieveFlags
//    = SCNetworkReachabilityGetFlags(defaultRouteReachability,&flags);
//    CFRelease(defaultRouteReachability);
//    if (!didRetrieveFlags)
//    {
//    return -1;
//    }
//    BOOL isReachable = flags & kSCNetworkFlagsReachable;
//    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
//    return (isReachable && !needsConnection) ? true : false;
//    }
        return false;
    }
//
//    +(id)fetchSSIDInfo
//    {
//    NSArray *ifs = (id)CNCopySupportedInterfaces();
//    //NSLog(@"%s: Supported interfaces: %@", __func__, ifs);
//    id info = nil;
//    for (NSString *ifnam in ifs) {
//    info = (id)CNCopyCurrentNetworkInfo((CFStringRef)ifnam);
//    //NSLog(@"%s: %@ => %@", __func__, ifnam, info);
//    if (info && [info count]) {
//    break;
//    }
//    [info release];
//    }
//    [ifs release];
//    return [info autorelease];
//    }
//    
//    
//    //获取网络连接类型，0：无网络连接 1：WIFI  2：手机网络
//    +(int)getConnectionType
//    {
//    if (![NetworkController connectedToNetwork])
//    {
//    return 0;
//    }
//    if ([NetworkController fetchSSIDInfo])
//    {
//    return 1;
//    }
//    return 2;
//    }

}