//
//  NetWorkTool.swift
//  LinComm
//
//  Created by lin on 27/03/2017.
//  Copyright © 2017 lin. All rights reserved.
//

import Foundation

public class NetWorkTool{
////    + (BOOL)isEnableWIFI {
////    return ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] != NotReachable);
////    }
    public class func isEnableWIFI()->Bool{
        return Reachability()?.currentReachabilityStatus == NetworkStatus.reachableViaWiFi;
    }
////
////    // 是否3G
////    + (BOOL)isEnable3G {
////    return ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable);
////    }
    public class func isEnable3G()->Bool{
        return Reachability()?.currentReachabilityStatus == NetworkStatus.reachableViaWWAN;
    }
}

//public enum NetworkStatus : NSInteger{
//    case NotReachable = 0
//    case ReachableViaWiFi = 1
//    case ReachableViaWWAN = 2
//}
//
////typedef enum : NSInteger  = {
////    NotReachable = 0,
////    ReachableViaWiFi,
////    ReachableViaWWAN
////} NetworkStatus;
//
//private class Readchability{
//    
//}









