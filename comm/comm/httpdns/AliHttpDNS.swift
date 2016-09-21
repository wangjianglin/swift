//
//  AliHttpDNS.swift
//  LinClient
//
//  Created by lin on 4/29/16.
//  Copyright © 2016 lin. All rights reserved.
//

import Foundation
import LinUtil



//@interface HttpDNSOrigin : NSObject
//@property(nonatomic, copy, readonly) NSString* host;
//@property(nonatomic, strong) NSArray* ips;
//@property(nonatomic,assign) long ttl;
//@property(nonatomic,assign) long query;
//
//-(id)initWithHost:(NSString*)host;
//
//-(BOOL)isExpired;
//
//-(NSString*)getIp;
//
//-(NSArray*)getIps;
//
//@end
class HttpDNSOrigin{
    fileprivate var hostName:String;
    var host:String{
        return hostName;
    }
    
    var ips:[String]!;
    
    var ttl:Int64 = 120;
    var query:Int64 = 120;
    
    init(host:String){
        self.hostName = host;
    }
    
    var expired:Bool{
        return query + ttl * 10000 < Int64(Date().timeIntervalSince1970 * 10000);
    }
    func getIp() -> String {
        if ips != nil && ips.count > 0 {
            return ips[0];
        }
        return "";
    }
}
//-(BOOL)isExpired
//    {
//        return _query + _ttl < [[NSDate date] timeIntervalSince1970];
//}
//
//-(NSString*)getIp
//    {
//        return _ips ? [_ips objectAtIndex:0] : nil;
//}
//
//
//-(NSArray*)getIps
//    {
//        return _ips;
//}


//static BOOL isExpiredIpAvailable = YES;
//static NSString* defaultServerIP = @"203.107.1.1";
////static NSString* defaultAccountID = @"100000";
//static int defaultHostTTL = 30;
//
//
//@implementation AliHttpDNS
//@objc
open class AliHttpDNS:HttpDNS{
   
    
    
    fileprivate struct StaticData{
        static var SERVER_IP = "203.107.1.1"
    }
    
    open class var serverIp:String{
        get{
            return StaticData.SERVER_IP;
        }set{
            StaticData.SERVER_IP = newValue;
        }
    }
    fileprivate var account:String!;
    fileprivate var hostManager = Dictionary<String,HttpDNSOrigin>();
    fileprivate var queue = Queue(count: 1);
    fileprivate var filter:((_ hostName:String)->Bool)!;
    
    public init(account:String){
        self.account = account;
    }
    
    
    open var expiredIpAvailable:Bool = true;
    
    //需要同步操作
    fileprivate func fetch(_ host:String)->HttpDNSOrigin!{
        
        let resolveUrl = "http://\(StaticData.SERVER_IP)/\(self.account ?? "")/d?host=\(host)";

        let request = NSMutableURLRequest(url: URL(string:resolveUrl)!, cachePolicy: URLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 25.0);

        //兼容ios6.+
//        let responsePoint = AutoreleasingUnsafeMutablePointer<URLResponse?>(UnsafeMutablePointer<URLResponse?>(allocatingCapacity: 1));
//        let responsePoint:AutoreleasingUnsafeMutablePointer<NSURLResponse?> = nil;//(UnsafeMutablePointer<NSURLResponse?>.alloc(1));
        let responsePoint:AutoreleasingUnsafeMutablePointer<URLResponse?> = AutoreleasingUnsafeMutablePointer<URLResponse?>.init(UnsafeMutablePointer<URLResponse?>.allocate(capacity: 1));
        let data = try? NSURLConnection.sendSynchronousRequest(request as URLRequest, returning: responsePoint);
        
        var origin:HttpDNSOrigin!;
        let r = responsePoint.pointee as? HTTPURLResponse;
        if r != nil && r!.statusCode == 200 {
            
            let args = Json.parse(NSString(data: data!, encoding: String.Encoding.utf8.rawValue) as! String);
            
            if args.count > 0{
                let host = args["host"].asString("");
                let ttl = args["ttl"].asInt64(120);
                let ips = args["ips"].asObjectArray(item: { (json) -> String in
                    return json.asString("");
                })
                
                if ips.count > 0{
                    origin = HttpDNSOrigin(host: host);
                    origin.ips = ips;
                    if ttl <= 0 {
                        origin.ttl = 120;
                    }else{
                        origin.ttl = ttl;
                    }
                    origin.query = Int64(Date().timeIntervalSince1970*10000);
                    
                }
                
            }
        }
        if origin != nil{
            objc_sync_enter(self)
            hostManager[host] = origin;
            objc_sync_exit(self)
        }
        return origin;
    }

    fileprivate func query(_ host:String)->HttpDNSOrigin!{
        
        var origin:HttpDNSOrigin!;
        objc_sync_exit(self);
        origin = hostManager[host];
        objc_sync_exit(self);
        
        if origin == nil || (origin.expired && !expiredIpAvailable) {
                
            return self.fetch(host);
        }
        
        if origin.expired {
            queue.asynQueue({
                self.fetch(host);
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
    
    open func setPreResolveHosts(_ hosts: [String]) {
        for host in hosts{
            queue.asynQueue {
                self.getIpByHost(host);
            }
        }
    }
}
