//
//  HttpDNS.swift
//  LinClient
//
//  Created by lin on 4/29/16.
//  Copyright © 2016 lin. All rights reserved.
//

import Foundation
import LinUtil

//public protocol HttpDNSDegradationDelegate :NSObjectProtocol{
//    func shouldDegradeHTTPDNS(hostName:String) -> Bool;
//}
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
    func getIpByHost(_ host:String)->String!;
//
//
///*
// * 获取多个IP的接口 NSArray
// * 里面都是NSString的类型IP地址
// */
//-(NSArray*)getIpsByHost:(NSString*)host;
    
    //action 返回 true 表示不使用 httpdns
    func setDelegateForDegradationFilter(_ action:@escaping((_ hostName:String)->Bool));
    
    func setPreResolveHosts(_ hosts:String ... );
    
}



open class AbstractHttpDNS:HttpDNS{
    
    public enum SessionMode{
        case Sticky
        case Random
    }
    public class HttpDNSOrigin{
        private var hostName:String;
        fileprivate var sessionMode:SessionMode = SessionMode.Sticky;
        
        private var ipIndex:Int = 0;
        
        public var host:String{
            return hostName;
        }
        
        public var ips:[String]!{
            didSet{
                if let ips = ips {
                    if ips.count > 1 {
                        ipIndex = Int(arc4random()) % ips.count;
                    }
                }
            }
        }
        
        fileprivate func status(_ origin:HttpDNSOrigin?){
            if sessionMode == SessionMode.Random {
                return;
            }
            if let o_ips = origin?.ips,let ips = self.ips,let ipIndex = origin?.ipIndex {
                if o_ips.count > 0 && ips.count > 1 {
                    for n in 0 ..< ips.count {
                        if ips[n] == o_ips[ipIndex] {
                            self.ipIndex = n;
                            break;
                        }
                    }
                }
            }
        }
        
        
        public var ttl:Int64 = 120;
        fileprivate var query:Int64 = 0;
        
//        fileprivate var expiredRequestTime:Int64 = 0;
        
        init(host:String){
            self.hostName = host;
        }
        
        fileprivate var expired:Bool{
            return query + ttl * 10000 < Int64(Date().timeIntervalSince1970 * 10000);
        }
        
//        fileprivate var request:Bool{
//            return expiredRequestTime + ttl * 10000 < Int64(Date().timeIntervalSince1970 * 10000);
//        }
        
        fileprivate func getIp() -> String! {
            if ips != nil && ips.count > 0 {
                if ips.count == 1 {
                    return ips[0];
                }
                if sessionMode == SessionMode.Random {
                    return ips[Int(arc4random()) % ips.count];
                }
                return ips[ipIndex];
            }
            return nil;
        }
    }
    
    public var sessionMode:SessionMode = SessionMode.Sticky;
    
    fileprivate var hostManager = Dictionary<String,HttpDNSOrigin>();
    fileprivate var queue = Queue(count: 1);
    fileprivate var filter:((_ hostName:String)->Bool)!;
    
    
    
    open var expiredIpAvailable:Bool = true;
    
    //需要同步操作
    open func fetch(host:String,timeout:TimeInterval)->HttpDNSOrigin!{
        return nil;
    }

    private func fetchInternal(host:String,timeout:TimeInterval)->HttpDNSOrigin{
        if let origin = self.fetch(host:host,timeout:timeout) {
            return origin;
        }
        if let origin = hostManager[host] {
            return origin;
        }
        let origin = HttpDNSOrigin(host:host);
        return origin;
    }
    
    fileprivate func setOrigin(host:String,timeout:TimeInterval){
        let origin = self.fetchInternal(host:host,timeout:timeout);
        objc_sync_enter(self)
        if origin.ttl < 3 {
            origin.ttl = 120;
        }
        origin.sessionMode = self.sessionMode;
        origin.status(hostManager[host]);
        origin.query = Int64(Date().timeIntervalSince1970*10000);
        hostManager[host] = origin;
        objc_sync_exit(self)
        
    }
    
    private func query(_ host:String,timeout:TimeInterval)->HttpDNSOrigin!{
        
        var origin:HttpDNSOrigin!;
        objc_sync_exit(self);
        origin = hostManager[host];
        objc_sync_exit(self);
        
        if origin == nil || (origin.expired && !expiredIpAvailable) {
            self.setOrigin(host:host,timeout: timeout);
            return hostManager[host];
        }
        
        if origin.expired {
            origin.query = Int64(Date().timeIntervalSince1970*10000);
            queue.asynQueue({[weak self] in
                self?.setOrigin(host:host,timeout:20.0);
            });
        }
        return origin;
    }
    
    
    fileprivate func configureProxies(_ host:String)->Bool
    {
        let proxySettings = CFNetworkCopySystemProxySettings()?.takeUnretainedValue();
        
        let url = URL(string: "http://\(host)");
        
        let proxies = CFNetworkCopyProxiesForURL(url! as CFURL, proxySettings!).takeUnretainedValue() as NSArray;
        
        let settins = proxies[0] as! NSDictionary;
        
        let host = settins[kCFProxyHostNameKey as String];
        
        let port = settins[kCFProxyPortNumberKey as String];
        
        //        preProxy = host != nil || port != nil
        //        preProxyTime = NSDate().timeIntervalSince1970;
        
        //        return preProxy;
        return host != nil || port != nil;
    }
    open func getIpByHost(_ host: String) -> String! {
        return getIpByHost(host, timeout: 3.0);
    }
    
    private func getIpByHost(_ host: String,timeout:TimeInterval) -> String! {
        
//        if host.lengthOfBytes(using: String.Encoding.utf8) <= 0
//            || configureProxies(host) {
//            return nil;
//        }
        if host.characters.count <= 0 {
            return nil;
        }
        
        if filter?(host) == true{
            return nil;
        }
        
        let origin = self.query(host,timeout: timeout);
        let ip = origin?.getIp();
        if ip == "" {
            return nil;
        }
        return ip;
    }
    
    public func setDelegateForDegradationFilter(_ filter: @escaping ((String)->Bool)){
        self.filter = filter;
    }
    
    open func setPreResolveHosts(_ hosts: String ...) {
        for host in hosts{
            queue.asynQueue {
                self.getIpByHost(host, timeout: 20.0);
            }
        }
    }
}
