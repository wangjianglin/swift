//
//  UserDefaults.swift
//  LinCore
//
//  Created by lin on 12/17/14.
//  Copyright (c) 2014 lin. All rights reserved.
//

import Foundation


public class UserDefaultsImpl{
    
    private var defaults:NSUserDefaults;
    private init(){
        defaults = NSUserDefaults.standardUserDefaults();
    }
    
    public subscript(key:String)->String?{
        get{
            //            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            //            [defaults setValue:[CDVAppPlugin getUUID] forKey:@"uuid_preference"];
            //            UserDefaultsArgs
            //var defaults:NSUserDefaults? = NSUserDefaults(suiteName:"");//.standardUserDefaults();
            //defaults?.addSuiteNamed(<#suiteName: String#>)
            
            return defaults.stringForKey(key);
        }
        set{
            defaults.setObject(newValue, forKey: key);
        }
    }
    
    public func objectForKey(defaultName: String) -> AnyObject?{
        return self.defaults.objectForKey(defaultName);
    }
    public func setObject(value: AnyObject?, forKey defaultName: String){
        self.defaults.setObject(value, forKey: defaultName);
    }
    public func removeObjectForKey(defaultName: String){
        self.defaults.removeObjectForKey(defaultName);
    }
    
    public func stringForKey(defaultName: String) -> String?{
        return self.defaults.stringForKey(defaultName);
    }
    public func arrayForKey(defaultName: String) -> [AnyObject]?{
        return self.defaults.arrayForKey(defaultName);
    }
    public func dictionaryForKey(defaultName: String) -> [NSObject : AnyObject]?{
        return self.defaults.dictionaryForKey(defaultName);
    }
    public func dataForKey(defaultName: String) -> NSData?{
        return self.defaults.dataForKey(defaultName);
    }
    public func stringArrayForKey(defaultName: String) -> [AnyObject]?{
        return self.defaults.stringArrayForKey(defaultName);
    }
    public func integerForKey(defaultName: String) -> Int{
        return self.defaults.integerForKey(defaultName);
    }
    public func floatForKey(defaultName: String) -> Float{
        return self.defaults.floatForKey(defaultName);
    }
    public func doubleForKey(defaultName: String) -> Double{
        return self.defaults.doubleForKey(defaultName);
    }
    public func boolForKey(defaultName: String) -> Bool{
        return self.defaults.boolForKey(defaultName);
    }
    @available(iOS, introduced=4.0)
    public func URLForKey(defaultName: String) -> NSURL?{
        return self.defaults.URLForKey(defaultName);
    }
    
    public func setInteger(value: Int, forKey defaultName: String){
        self.defaults.setObject(value, forKey: defaultName);
    }
    public func setFloat(value: Float, forKey defaultName: String){
        self.defaults.setFloat(value, forKey: defaultName);
    }
    public func setDouble(value: Double, forKey defaultName: String){
        self.defaults.setDouble(value, forKey: defaultName);
    }
    public func setBool(value: Bool, forKey defaultName: String){
        self.defaults.setBool(value, forKey: defaultName);
    }
    @available(iOS, introduced=4.0)
    public func setURL(url: NSURL, forKey defaultName: String){
        self.defaults.setURL(url, forKey: defaultName);
    }
    
//    func registerDefaults(registrationDictionary: [NSObject : AnyObject])
//    
//    func addSuiteNamed(suiteName: String)
//    func removeSuiteNamed(suiteName: String)
//    
//    func dictionaryRepresentation() -> [NSObject : AnyObject]
//    
//    var volatileDomainNames: [AnyObject] { get }
//    func volatileDomainForName(domainName: String) -> [NSObject : AnyObject]
//    func setVolatileDomain(domain: [NSObject : AnyObject], forName domainName: String)
//    func removeVolatileDomainForName(domainName: String)
//    
//    func persistentDomainForName(domainName: String) -> [NSObject : AnyObject]?
//    func setPersistentDomain(domain: [NSObject : AnyObject], forName domainName: String)
//    func removePersistentDomainForName(domainName: String)
    
    public func synchronize() -> Bool{
        return self.defaults.synchronize();
    }
    
    public func objectIsForcedForKey(key: String) -> Bool{
        return self.defaults.objectIsForcedForKey(key);
    }
    public func objectIsForcedForKey(key: String, inDomain domain: String) -> Bool{
        return self.defaults.objectIsForcedForKey(key, inDomain: domain);
    }
    
}

public class UserDefaultsArgs{

    private init(){}
}


public var UserDefaults:UserDefaultsImpl{
    struct YRSingleton{
        static var predicate:dispatch_once_t = 0
        static var instance:UserDefaultsImpl? = nil
    }
    dispatch_once(&YRSingleton.predicate,{
        YRSingleton.instance = UserDefaultsImpl()
    })
    return YRSingleton.instance!
}


