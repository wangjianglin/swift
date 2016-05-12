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
    private var hostName:String;
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
        return query + ttl * 10000 < Int64(NSDate().timeIntervalSince1970 * 10000);
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
public class AliHttpDNS:HttpDNS{

    
    private struct StaticData{
        static var SERVER_IP = "203.107.1.1"
    }
    
    public class var serverIp:String{
        get{
            return StaticData.SERVER_IP;
        }set{
            StaticData.SERVER_IP = newValue;
        }
    }
    private var account:String!;
    private var hostManager = Dictionary<String,HttpDNSOrigin>();
    private var queue = Queue(count: 1);
    private var filter:((hostName:String)->Bool)!;
    
    public init(account:String){
        self.account = account;
    }
    
    
    public var expiredIpAvailable:Bool = true;
    
    //需要同步操作
    private func fetch(host:String)->HttpDNSOrigin!{
        
        var resolveUrl = "http://\(StaticData.SERVER_IP)/\(self.account)/d?host=\(host)";

        var request = NSMutableURLRequest(URL: NSURL(string:resolveUrl)!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 25.0);

        //兼容ios6.+
        var responsePoint = AutoreleasingUnsafeMutablePointer<NSURLResponse?>(UnsafeMutablePointer<NSURLResponse?>.alloc(1));
        
        var data = try! NSURLConnection.sendSynchronousRequest(request, returningResponse: responsePoint);
        
        var origin:HttpDNSOrigin!;
        var r = responsePoint.memory! as! NSHTTPURLResponse;
        if r.statusCode == 200 {
            
            var args = Json.parse(NSString(data: data, encoding: NSUTF8StringEncoding) as! String);
            
            if args.count > 0{
                var host = args["host"].asString("");
                var ttl = args["ttl"].asInt64(120);
                var ips = args["ips"].asObjectArray(item: { (json) -> String in
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
                    origin.query = Int64(NSDate().timeIntervalSince1970*10000);
                    
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

    private func query(host:String)->HttpDNSOrigin!{
        
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
    
    private var preProxy:Bool = false;
    private var preProxyTime:Double = 0;
    
    private func configureProxies(host:String)->Bool
    {
        if preProxyTime + 60 > NSDate().timeIntervalSince1970 {
            return preProxy;
        }
        var proxySettings = CFNetworkCopySystemProxySettings()?.takeUnretainedValue();
        
        var url = NSURL(string: "http://\(host)");
        
        var proxies = CFNetworkCopyProxiesForURL(url!, proxySettings!).takeUnretainedValue() as NSArray;
        
        var settins = proxies[0] as! NSDictionary;
        
        var host = settins[kCFProxyHostNameKey as String];
        
        var port = settins[kCFProxyPortNumberKey as String];
    
        preProxy = host != nil || port != nil
        preProxyTime = NSDate().timeIntervalSince1970;
        
        return preProxy;
    }
    public func getIpByHost(host: String) -> String! {
       
        if host.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) <= 0
            || configureProxies(host) {
            return nil;
        }
        
        if let filter = filter{
            if filter(hostName: host)
            {
                return nil;
            }
        }
        
        var origin = self.query(host);
        return origin.getIp();
    }
    
    public func setDelegateForDegradationFilter(filter:((hostName:String)->Bool)){
        self.filter = filter;
    }
    
    public func setPreResolveHosts(hosts: [String]) {
        for host in hosts{
            queue.asynQueue {
                self.getIpByHost(host);
            }
        }
    }
}