//
//  TcpJsonPackage.swift
//  LinClient
//
//  Created by lin on 1/25/16.
//  Copyright © 2016 lin. All rights reserved.
//

import LinUtil


public protocol TcpJsonPackage : TcpPackage{
    
    var json:Json{get};
    
//    static var path:String{get};
    
    var path:String{get};
    
    
    func addHeader(header:String,value:String);
    
    func remove(header:String);
    
    subscript(idx:Int) -> Json {get set}


    subscript(key:String)->Json {get set}

    func setValue(value:AnyObject?,forName name:String);
    
    func getValue(name:String)->AnyObject?;

}

private class TcpJsonPackageImpl{
    
    private var _path:String!;
    private var _json:Json!;
    
    var json:Json!{
        if _json == nil{
            _json = Json();
        }
        return _json;
    }
    
    private var headers:Dictionary<String,String>;// = [:];
    
    func setHeaders(headers:Dictionary<String,String>){
        for (key,value) in headers {
            self.headers[key] = value;
        }
        
    }
    
    init(path:String!,json:Json!,headers:Dictionary<String,String>){
        self._path = path;
        self._json = json;
        self.headers = headers;
    }
    
 
    
    
    func addHeader(header:String,value:String){
        self.headers[header] = value;
    }
    
    func remove(header:String){
        headers.removeValueForKey(header);
    }
    
    func write() -> [UInt8] {
        let stringBuffer = NSMutableString();
        
        stringBuffer.appendString("path:");
        stringBuffer.appendString(self._path);
        stringBuffer.appendString("\r\n");
        
        stringBuffer.appendString("encoding:utf-8\r\n");
        
        for (key,value) in headers{
            stringBuffer.appendString(key);
            stringBuffer.appendString(":");
            stringBuffer.appendString(value);
            stringBuffer.appendString("\r\n");
        }
        
        stringBuffer.appendString("\r\n");
        
        stringBuffer.appendString(json.toString());
        
        let len = stringBuffer.lengthOfBytesUsingEncoding(NSUTF8StringEncoding);
        let ptr:UnsafePointer<Int8> = stringBuffer.cStringUsingEncoding(NSUTF8StringEncoding);
        
        var r = [UInt8](count: len, repeatedValue: 0);
        for(var n=0;n<len;n++){
            r[n] = asUInt8(ptr[n]);
        }
        return r;
    }
    
    func write(inout buffer: [UInt8]) {
        
    }
    
    private subscript(idx:Int) -> Json {
        get{
            return json[idx];
        }
        set{
            json[idx] = newValue;
        }
    }


    private subscript(key:String)->Json {
        get{
            return json[key];
        }
        set{
            json[key] = newValue;
        }
    }

    private func setValue(value:AnyObject?,forName name:String){
        self.json.setValue(value, forName: name);
    }
    private func getValue(name:String)->AnyObject?{
        return self.json.getValue(name);
    }
}

public class TcpJsonRequestPackage : TcpRequestPackage,TcpJsonPackage{
    
    override final public class var type:UInt8{
        return 6;
    }
    
    private var impl:TcpJsonPackageImpl;
    
    public var json:Json{
        return impl.json;
    }

    public class var path:String{
        return "/";
    }
    
    public final var path:String{
        return impl._path;
    }
    
    func setPath(path:String){
        impl._path = path;
    }
    
    func setJson(json:Json){
        impl._json = json;
    }
    
    func setHeaders(headers:Dictionary<String,String>){
        impl.setHeaders(headers);
    }

    
    public required init() {
        
        impl = TcpJsonPackageImpl(path: nil, json: Json(), headers: [:]);
        
        super.init();
        impl._path = (Mirror(reflecting: self).subjectType as! TcpJsonRequestPackage.Type).path;
        //        _path = "aa";
    }
    
    public init(path:String) {
        impl = TcpJsonPackageImpl(path: path, json: nil, headers: [:]);
    }
    
    init(path:String,json:Json,headers:Dictionary<String,String>) {
        impl = TcpJsonPackageImpl(path: path, json: json, headers: headers);
    }
    
    public func addHeader(header:String,value:String){
        impl.addHeader(header, value: value);
    }
    
    public func remove(header:String){
        impl.remove(header);
    }
    
    public override func write() -> [UInt8] {
        return impl.write();
    }
    
    public override func write(inout buffer: [UInt8]) {
        impl.write(&buffer);
    }
    
    public subscript(idx:Int) -> Json {
        get{
            return impl[idx];
        }
        set{
            impl[idx] = newValue;
        }
    }


    public subscript(key:String)->Json {
        get{
            return impl[key];
        }
        set{
            impl[key] = newValue;
        }
    }

    public func setValue(value:AnyObject?,forName name:String){
        impl.setValue(value, forName: name);
    }
    public func getValue(name:String)->AnyObject?{
        return impl.getValue(name);
    }
}

public class TcpJsonResponsePackage : TcpResponsePackage,TcpJsonPackage{
    
    override final public class var type:UInt8{
        return 6;
    }
    
    private var impl:TcpJsonPackageImpl;
    
    public var json:Json{
        if impl._json == nil {
            impl._json = Json();
        }
        return impl.json;
    }
    
    
    public final var path:String{
        return impl._path;
    }
    
    func setPath(path:String){
        impl._path = path;
    }
    
    func setJson(json:Json){
        impl._json = json;
    }
    
    func setHeaders(headers:Dictionary<String,String>){
        impl.setHeaders(headers);
    }
    
    public required init() {
        
        impl = TcpJsonPackageImpl(path: nil,json:nil, headers: [:]);
        
        super.init();
        
        impl._path = TcpJsonPackageManager.request(Mirror(reflecting: self).subjectType as! TcpJsonResponsePackage.Type);
        if impl._path == nil {
            impl._path = "";
        }
        //impl._path = (Mirror(reflecting: self).subjectType as! TcpJsonRequestPackage.Type).path;
        //        _path = "aa";
    }
    
    init(path:String,json:Json,headers:Dictionary<String,String>) {
        
        impl = TcpJsonPackageImpl(path: path, json: json, headers: headers);
        
        super.init();
        //impl._path = (Mirror(reflecting: self).subjectType as! TcpJsonRequestPackage.Type).path;
        //        _path = "aa";
    }
    
    
    public func addHeader(header:String,value:String){
        impl.addHeader(header, value: value);
    }
    
    public func remove(header:String){
        impl.remove(header);
    }
    
    public override func write() -> [UInt8] {
        return impl.write();
    }
    
    public override func write(inout buffer: [UInt8]) {
        impl.write(&buffer);
    }
    
    public subscript(idx:Int) -> Json {
        get{
            return impl[idx];
        }
        set{
            impl[idx] = newValue;
        }
    }
    
    
    public subscript(key:String)->Json {
        get{
            return impl[key];
        }
        set{
            impl[key] = newValue;
        }
    }
    
    public func setValue(value:AnyObject?,forName name:String){
        impl.setValue(value, forName: name);
    }
    public func getValue(name:String)->AnyObject?{
        return impl.getValue(name);
    }
}

//public class TcpJsonPackage : TcpRequestPackage{
//    
//    override public class var type:UInt8{
//        return 6;
//    }
//    
//    private var headers:Dictionary<String,String>;// = [:];
//    
//    private var _json:Json!;
//    private var _path:String!;
//    
//    public var json:Json{
//        if _json == nil {
//            _json = Json();
//        }
//        return _json;
//    }
//    
//    func setJson(json:Json){
//        _json = json;
//    }
//    
//    func setHeaders(headers:Dictionary<String,String>){
//        for (key,value) in headers {
//            self.headers[key] = value;
//        }
//        
//    }
//    
//    public class var path:String{
//        return "/";
//    }
//    
//    public var path:String{
//        return "/";
//    }
//    
//    public required override init() {
//        _json = Json();
//        headers = [:];
//        super.init();
//        _path = (Mirror(reflecting: self).subjectType as! TcpJsonPackage.Type).path;
//        //        _path = "aa";
//    }
//    
//    init(path:String,json:Json,headers:Dictionary<String,String>) {
//        _json = json;
//        self.headers = headers;
//        self._path = path;
//        
//    }
//    
//    
//    public func addHeader(header:String,value:String){
//        self.headers[header] = value;
//    }
//    
//    public func remove(header:String){
//        headers.removeValueForKey(header);
//    }
//    
//    public override func write() -> [UInt8] {
//        let stringBuffer = NSMutableString();
//        
//        stringBuffer.appendString("path:");
//        stringBuffer.appendString(self.path);
//        stringBuffer.appendString("\r\n");
//        
//        stringBuffer.appendString("encoding:utf-8\r\n");
//        
//        for (key,value) in headers{
//            stringBuffer.appendString(key);
//            stringBuffer.appendString(":");
//            stringBuffer.appendString(value);
//            stringBuffer.appendString("\r\n");
//        }
//        
//        stringBuffer.appendString("\r\n");
//        
//        stringBuffer.appendString(json.toString());
//        
//        let len = stringBuffer.lengthOfBytesUsingEncoding(NSUTF8StringEncoding);
//        let ptr:UnsafePointer<Int8> = stringBuffer.cStringUsingEncoding(NSUTF8StringEncoding);
//        
//        var r = [UInt8](count: len, repeatedValue: 0);
//        for(var n=0;n<len;n++){
//            r[n] = asUInt8(ptr[n]);
//        }
//        return r;
//    }
//    
//    public override func write(inout buffer: [UInt8]) {
//        
//    }
//    
//}


//extension TcpJsonPackage {
//    
//    public subscript(idx:Int) -> Json {
//        get{
//            return json[idx];
//        }
//        set{
//            json[idx] = newValue;
//        }
//    }
//
//    
//    public subscript(key:String)->Json {
//        get{
//            return json[key];
//        }
//        set{
//            json[key] = newValue;
//        }
//    }
//    
//    public func setValue(value:AnyObject?,forName name:String){
//        self.json.setValue(value, forName: name);
//    }
//    public func getValue(name:String)->AnyObject?{
//        return self.json.getValue(name);
//    }
//    
//}