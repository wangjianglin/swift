//
//  UserDefaults.swift
//  LinCore
//
//  Created by lin on 12/17/14.
//  Copyright (c) 2014 lin. All rights reserved.
//

import Foundation


open class UserDefaultsImpl{
    
    fileprivate var defaults:Foundation.UserDefaults;
    fileprivate init(){
        defaults = Foundation.UserDefaults.standard;
    }
    
    open subscript(key:String)->String?{
        get{
            //            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            //            [defaults setValue:[CDVAppPlugin getUUID] forKey:@"uuid_preference"];
            //            UserDefaultsArgs
            //var defaults:NSUserDefaults? = NSUserDefaults(suiteName:"");//.standardUserDefaults();
            //defaults?.addSuiteNamed(<#suiteName: String#>)
            
            return defaults.string(forKey: key);
        }
        set{
            defaults.set(newValue, forKey: key);
        }
    }
    
    open func objectForKey(_ defaultName: String) -> Any?{
        return self.defaults.object(forKey: defaultName);
    }
    open func setObject(_ value: AnyObject?, forKey defaultName: String){
        self.defaults.set(value, forKey: defaultName);
    }
    open func removeObjectForKey(_ defaultName: String){
        self.defaults.removeObject(forKey: defaultName);
    }
    
    open func stringForKey(_ defaultName: String) -> String?{
        return self.defaults.string(forKey: defaultName);
    }
    open func arrayForKey(_ defaultName: String) -> [Any]?{
        return self.defaults.array(forKey: defaultName);
    }
    open func dictionaryForKey(_ defaultName: String) -> [String : Any]?{
        return self.defaults.dictionary(forKey: defaultName);
    }
    open func dataForKey(_ defaultName: String) -> Data?{
        return self.defaults.data(forKey: defaultName);
    }
    open func stringArrayForKey(_ defaultName: String) -> [Any]?{
        return self.defaults.stringArray(forKey: defaultName);
    }
    open func integerForKey(_ defaultName: String) -> Int{
        return self.defaults.integer(forKey: defaultName);
    }
    open func floatForKey(_ defaultName: String) -> Float{
        return self.defaults.float(forKey: defaultName);
    }
    open func doubleForKey(_ defaultName: String) -> Double{
        return self.defaults.double(forKey: defaultName);
    }
    open func boolForKey(_ defaultName: String) -> Bool{
        return self.defaults.bool(forKey: defaultName);
    }
    @available(iOS, introduced: 4.0)
    open func URLForKey(_ defaultName: String) -> URL?{
        return self.defaults.url(forKey: defaultName);
    }
    
    open func setInteger(_ value: Int, forKey defaultName: String){
        self.defaults.set(value, forKey: defaultName);
    }
    open func setFloat(_ value: Float, forKey defaultName: String){
        self.defaults.set(value, forKey: defaultName);
    }
    open func setDouble(_ value: Double, forKey defaultName: String){
        self.defaults.set(value, forKey: defaultName);
    }
    open func setBool(_ value: Bool, forKey defaultName: String){
        self.defaults.set(value, forKey: defaultName);
    }
    @available(iOS, introduced: 4.0)
    open func setURL(_ url: URL, forKey defaultName: String){
        self.defaults.set(url, forKey: defaultName);
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
    
    open func synchronize() -> Bool{
        return self.defaults.synchronize();
    }
    
    open func objectIsForcedForKey(_ key: String) -> Bool{
        return self.defaults.objectIsForced(forKey: key);
    }
    open func objectIsForcedForKey(_ key: String, inDomain domain: String) -> Bool{
        return self.defaults.objectIsForced(forKey: key, inDomain: domain);
    }
    
}

open class UserDefaultsArgs{

    fileprivate init(){}
}

private struct YRSingleton{
    static var instance:UserDefaultsImpl? = nil
}

private var __once:() = {
    YRSingleton.instance = UserDefaultsImpl()
}();

public var UserDefaults:UserDefaultsImpl{
    
    _ = __once;
    return YRSingleton.instance!
}


