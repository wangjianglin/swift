//
//  HttpDNS.swift
//  LinClient
//
//  Created by lin on 4/29/16.
//  Copyright © 2016 lin. All rights reserved.
//

import Foundation


public protocol HttpDNSDegradationDelegate :NSObjectProtocol{
    func shouldDegradeHTTPDNS(hostName:String) -> Bool;
}
//
//@protocol HttpDNSDegradationDelegate <NSObject>
//
//- (BOOL)shouldDegradeHTTPDNS:(NSString *)hostName;
//
//@end
//
//@protocol HttpDNS <NSObject>
//
///*
// *   超时域名是否还生效接口
// *
// */
public protocol HttpDNS{
    
    var expiredIpAvailable:Bool{get set}

/*
 * 获取一个IP
 */
    func getIpByHost(host:String)->String!;
//
//
///*
// * 获取多个IP的接口 NSArray
// * 里面都是NSString的类型IP地址
// */
//-(NSArray*)getIpsByHost:(NSString*)host;
    
    func setDelegateForDegradationFilter(action:((hostName:String)->Bool));
    
    func setPreResolveHosts(hosts:[String]);
}
