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
        fileprivate var hostName:String;
        fileprivate var sessionMode:SessionMode = SessionMode.Sticky{
            didSet{
                if let ips = ips {
                    if ips.count > 1 {
                        ipIndex = Int(arc4random()) % ips.count;
                    }
                }
            }
        }
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
            if let o_ips = origin?.ips {
                if let ips = self.ips {
                    if o_ips.count > 0 && ips.count > 1 {
                        for n in 0 ..< ips.count {
                            if ips[n] == origin!.ips[origin!.ipIndex] {
                                self.ipIndex = n;
                                break;
                            }
                        }
                    }
                }
            }
        }
        
        
        var ttl:Int64 = 120;
        fileprivate var query:Int64 = 120;
        
        init(host:String){
            self.hostName = host;
        }
        
        var expired:Bool{
            return query + ttl * 10000 < Int64(Date().timeIntervalSince1970 * 10000);
        }
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
    
    var sessionMode:SessionMode = SessionMode.Sticky;
    
    fileprivate var hostManager = Dictionary<String,HttpDNSOrigin>();
    fileprivate var queue = Queue(count: 1);
    fileprivate var filter:((_ hostName:String)->Bool)!;
    
    
    
    open var expiredIpAvailable:Bool = true;
    
    //需要同步操作
    open func fetch(host:String)->HttpDNSOrigin!{
        return nil;
    }
//    fileprivate func fetch(_ host:String)->HttpDNSOrigin!{
//        
//        let resolveUrl = "http://\(StaticData.SERVER_IP)/\(self.account ?? "")/d?host=\(host)";
//        
//        let request = NSMutableURLRequest(url: URL(string:resolveUrl)!, cachePolicy: URLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 25.0);
//        
//        //兼容ios6.+
//        //        let responsePoint = AutoreleasingUnsafeMutablePointer<URLResponse?>(UnsafeMutablePointer<URLResponse?>(allocatingCapacity: 1));
//        //        let responsePoint:AutoreleasingUnsafeMutablePointer<NSURLResponse?> = nil;//(UnsafeMutablePointer<NSURLResponse?>.alloc(1));
//        let responsePoint:AutoreleasingUnsafeMutablePointer<URLResponse?> = AutoreleasingUnsafeMutablePointer<URLResponse?>.init(UnsafeMutablePointer<URLResponse?>.allocate(capacity: 1));
//        let data = try? NSURLConnection.sendSynchronousRequest(request as URLRequest, returning: responsePoint);
//        
//        var origin:HttpDNSOrigin!;
//        let r = responsePoint.pointee as? HTTPURLResponse;
//        if r != nil && r!.statusCode == 200 {
//            
//            let args = Json.parse(NSString(data: data!, encoding: String.Encoding.utf8.rawValue) as! String);
//            
//            if args.count > 0{
//                let host = args["host"].asString("");
//                let ttl = args["ttl"].asInt64(120);
//                let ips = args["ips"].asObjectArray(item: { (json) -> String in
//                    return json.asString("");
//                })
//                
//                if ips.count > 0{
//                    origin = HttpDNSOrigin(host: host);
//                    origin.ips = ips;
//                    if ttl <= 0 {
//                        origin.ttl = 120;
//                    }else{
//                        origin.ttl = ttl;
//                    }
//                    origin.query = Int64(Date().timeIntervalSince1970*10000);
//                    
//                }
//                
//            }
//        }
//        if origin != nil{
//            objc_sync_enter(self)
//            hostManager[host] = origin;
//            objc_sync_exit(self)
//        }
//        return origin;
//    }
    
    fileprivate func setOrigin(host:String){
        if let origin = self.fetch(host:host) {
            objc_sync_enter(self)
            origin.sessionMode = self.sessionMode;
            origin.status(hostManager[host]);
            origin.query = Int64(Date().timeIntervalSince1970*10000);
            hostManager[host] = origin;
            objc_sync_exit(self)
        }
        
    }
    fileprivate func query(_ host:String)->HttpDNSOrigin!{
        
        var origin:HttpDNSOrigin!;
        objc_sync_exit(self);
        origin = hostManager[host];
        objc_sync_exit(self);
        
        if origin == nil || (origin.expired && !expiredIpAvailable) {
            self.setOrigin(host:host);
            return hostManager[host];
        }
        
        if origin.expired {
            queue.asynQueue({[weak self] in
                self?.setOrigin(host:host);
            });
        }
        return origin;
    }
    
    //    private var preProxy:Bool = false;
    //    private var preProxyTime:Double = 0;
    
    fileprivate func configureProxies(_ host:String)->Bool
    {
        //        if preProxyTime + 60 > NSDate().timeIntervalSince1970 {
        //            return preProxy;
        //        }
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
        
        if host.lengthOfBytes(using: String.Encoding.utf8) <= 0
            || configureProxies(host) {
            return nil;
        }
        
        if let filter = filter{
            if filter(host)
            {
                return nil;
            }
        }
        
        let origin = self.query(host);
        return origin?.getIp();
    }
    
    //    open func setDelegateForDegradationFilter(_ action: ((String) -> Bool)) {
    //
    //    }
    //    public func setDelegateForDegradationFilter(_ action: ((String) -> Bool)) {
    //        <#code#>
    //    }
    
    
    public func setDelegateForDegradationFilter(_ filter: @escaping ((String)->Bool)){
        self.filter = filter;
    }
    
    open func setPreResolveHosts(_ hosts: String ...) {
        for host in hosts{
            queue.asynQueue {
                self.getIpByHost(host);
            }
        }
    }
}
