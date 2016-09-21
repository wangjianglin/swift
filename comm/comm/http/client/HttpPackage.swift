//
//  Package.swift
//  LinClient
//
//  Created by lin on 11/27/14.
//  Copyright (c) 2014 lin. All rights reserved.
//

import Foundation
import LinUtil

//public class HttpPackageDataArgsBool{
//    private var package:HttpPackage!;
//    private init(package:HttpPackage){
//        self.package = package;
//    }
//    public subscript(name:String)->Bool? {
//        get{
//            var _value:AnyObject! = package[name];
//            switch _value {
//            case let o as Bool:
//                return o;
//            default: return nil
//            }
//        }
//        set{
//            if let value = newValue {
//                package[name] = value;
//            }
//        }
//    }
//}
//
//public class HttpPackageDataArgsString{
//    private var package:HttpPackage!;
//    private init(package:HttpPackage){
//        self.package = package;
//    }
//    public subscript(name:String)->String? {
//        get{
//            var _value:AnyObject! = package[name];
//            switch _value {
//            case let o as String:
//                return o;
//            default: return nil
//            }
//        }
//        set{
//            if let value = newValue {
//                package[name] = value;
//            }
//        }
//    }
//}
//
//public class HttpPackageDataArgsInt{
//    private var package:HttpPackage!;
//    private init(package:HttpPackage){
//        self.package = package;
//    }
//    public subscript(name:String)->Int? {
//        get{
//            var _value:AnyObject! = package[name];
//            switch _value {
//            case let o as Int:
//                return o;
//            default: return nil
//            }
//        }
//        set{
//            if let value = newValue {
//                package[name] = value;
//            }
//        }
//    }
//}
//
//public class HttpPackageDataArgsDate{
//    private var package:HttpPackage!;
//    private init(package:HttpPackage){
//        self.package = package;
//    }
//    public subscript(name:String)->NSDate! {
//        get{
//            var _value:AnyObject! = package[name];
//            switch _value {
//            case let o as NSDate:
//                return o;
//            default: return nil
//            }
//        }
//        set{
//            if let value = newValue {
//                package[name] = value;
//            }
//        }
//    }
//}
//
//public class HttpPackageDataArgsDouble{
//    private var package:HttpPackage!;
//    private init(package:HttpPackage){
//        self.package = package;
//    }
//    public subscript(name:String)->Double? {
//        get{
//            var _value:AnyObject! = package[name];
//            switch _value {
//            case let o as Double:
//                return o;
//            default: return nil
//            }
//        }
//        set{
//            if let value = newValue {
//                package[name] = value;
//            }
//        }
//    }
//}

open class HttpPackage :JsonModel{
    
//    private var _json:Json;
    
    open var handle:HttpRequestHandle;
    
//    internal var json:Json{ return _json; }
    
    fileprivate var _method:HttpMethod;
    open var method:HttpMethod{ return self._method;}
    
//    public init(){
//        self._json = JSON();
//        handle = HttpPackage.STANDARD_JSON_HANDLE;
//    }
    public init(url:String,method:HttpMethod = HttpMethod.POST){
        
//        self._json = Json();
        handle = HttpPackage.STANDARD_JSON_HANDLE;
        //handle = HttpPackage.STANDARD_HANDLE;
        //handle = HttpPackage.ENCRYPT_JSON_HANDLE;
        self._url = url;
        self._method = method;
        super.init();
        
//        self.asBoolArgs = HttpPackageDataArgs<Bool>();
//        self.asBoolArgs.package = self;
        
    }
    
//    public init(json: Json) {
//        fatalError("init(json:) has not been implemented")
//    }

    
//    private var _asBoolArgs:HttpPackageDataArgsBool?;
//    private var _asIntArgs:HttpPackageDataArgsInt?;
//    private var _asStringArgs:HttpPackageDataArgsString?;
//    private var _asDoubleArgs:HttpPackageDataArgsDouble?;
//    private var _asDateArgs:HttpPackageDataArgsDate?;
    //var v:NSCoder;
    
    //是否启用缓存，默认不启用
    open var enableCache:Bool = false;
    
    fileprivate var _url:String = "";
    open var url:String{return self._url;}
    
    //版本
    //var version:HTTPVersion;
    
    //获取请求参数
//    public func getParams()->Dictionary<String,AnyObject>?{
//        return nil;
//    }
    
    //得到返回结果
    open func getResult(_ json:Json)->AnyObject!{
        return json;
    }

}

//extension HttpPackage{
//    public subscript(name:String)->AnyObject! {
//        get{
//            return self.json[name].value;
//        }
//        set{
//            self.json[name] = Json(newValue);
//        }
//    }
//}

extension HttpPackage{
    
//    public func `as`<T:AnyObject>(name:String,def:T)->T{
//        if let v = self[name] as? T {
//            return v;
//        }
//        self[name] = def;
//        return def;
//    }
    
//    public var asBool:HttpPackageDataArgsBool {
//        if self._asBoolArgs == nil {
//            synchronized(self){
//                if self._asBoolArgs == nil {
//                    self._asBoolArgs = HttpPackageDataArgsBool(package: self);
//                }
//            }
//        }
//        return self._asBoolArgs!;
//    }
//    public func asBool(name:String,def:Bool = false)->Bool{
//        if let v = self.asBool[name] {
//            return v;
//        }
//        self[name] = def;
//        return def;
//    }
//    
//    public var asInt:HttpPackageDataArgsInt {
//        if self._asIntArgs == nil {
//            synchronized(self){
//                if self._asIntArgs == nil {
//                    self._asIntArgs = HttpPackageDataArgsInt(package: self);
//                }
//            }
//        }
//        return self._asIntArgs!;
//    }
//    public func asInt(name:String,def:Int = 0)->Int{
//        if let v = self.asInt[name] {
//            return v;
//        }
//        self[name] = def;
//        return def;
//    }
//    
//    public var asDouble:HttpPackageDataArgsDouble {
//        if self._asDoubleArgs == nil {
//            synchronized(self){
//                if self._asDoubleArgs == nil {
//                    self._asDoubleArgs = HttpPackageDataArgsDouble(package: self);
//                }
//            }
//        }
//        return self._asDoubleArgs!;
//    }
//    public func asDouble(name:String,def:Double = 0)->Double{
//        if let v = self.asDouble[name] {
//            return v;
//        }
//        self[name] = def;
//        return def;
//    }
//    
//    public var asNumber:HttpPackageDataArgsDouble { return asDouble; }
//    public func asNumber(name:String,def:Double = 0)->Double{
//        return self.asDouble(name, def: def);
//    }
//    
//    public var asString:HttpPackageDataArgsString {
//        if self._asStringArgs == nil {
//            synchronized(self){
//                if self._asStringArgs == nil {
//                    self._asStringArgs = HttpPackageDataArgsString(package: self);
//                }
//            }
//        }
//        return self._asStringArgs!;
//    }
//    public func asString(name:String,def:String = "")->String{
//        if let v = self.asString[name] {
//            return v;
//        }
//        self[name] = def;
//        return def;
//    }
//    
//    public var asDate:HttpPackageDataArgsDate {
//        if self._asStringArgs == nil {
//            synchronized(self){
//                if self._asDateArgs == nil {
//                    self._asDateArgs = HttpPackageDataArgsDate(package: self);
//                }
//            }
//        }
//        return self._asDateArgs!;
//    }
//    
//    public func asDate(name:String)->NSDate{
//        if let v = self.asDate[name] {
//            return v;
//        }
//        var def = NSDate();
//        self[name] = def;
//        return def;
//    }
    
//    public func asDef<T:AnyObject>(name:String,def:()->T)->T{
//        var _value:AnyObject! = self[name];
//        switch _value {
//        case let o as T:
//            return o;
//        default:
//            break;
//        }
//        var defValue:T?;
//        
//        synchronized(self){
//            _value = self[name];
//            switch _value {
//            case let o as T:
//                defValue = o;
//            default:
//                break;
//            }
//            
//            if defValue == nil {
//                defValue = def();
//            }
//        }
//        self[name] = defValue!
//        return defValue!;
//    }
}
extension HttpPackage{
    
    struct YRSingleton{
        static var NONE_HANDLE_INSTANCE:HttpRequestHandle! = nil
        static var STANDARD_HANDLE_INSTANCE:HttpRequestHandle! = nil
        static var STANDARD_JSON_HANDLE_INSTANCE:HttpRequestHandle! = nil
        static var ENCRYPT_JSON_HANDLE_INSTANCE:HttpRequestHandle! = nil
    }
  
    fileprivate static var __NONE_HANDLE: () = {
        YRSingleton.NONE_HANDLE_INSTANCE = NoneHttpRequestHandle()
        
    }()
  
    public class var NONE_HANDLE:HttpRequestHandle {
        _ = __NONE_HANDLE;
        return YRSingleton.NONE_HANDLE_INSTANCE;
    }
    
    fileprivate static var __STANDARD_HANDLE: () = {
        YRSingleton.NONE_HANDLE_INSTANCE = StandardHttpRequestHandle()
        
    }()
    public class var STANDARD_HANDLE:HttpRequestHandle {
        
        _ = __STANDARD_HANDLE;
        return YRSingleton.STANDARD_HANDLE_INSTANCE;
    }
    
    fileprivate static var __STANDARD_JSON_HANDLE: () = {
        YRSingleton.STANDARD_JSON_HANDLE_INSTANCE = StandardJsonHttpRequestHandle()
        
    }()
    public class var STANDARD_JSON_HANDLE:HttpRequestHandle {
        
        _ = __STANDARD_JSON_HANDLE;
        return YRSingleton.STANDARD_JSON_HANDLE_INSTANCE;
    }
    
    fileprivate static var __ENCRYPT_JSON_HANDLE: () = {
        YRSingleton.NONE_HANDLE_INSTANCE = EncryptJsonHttpRequestHandle()
        
    }()
    public class var ENCRYPT_JSON_HANDLE:HttpRequestHandle {
        _ = __ENCRYPT_JSON_HANDLE;
        return YRSingleton.ENCRYPT_JSON_HANDLE_INSTANCE;
    }
}
