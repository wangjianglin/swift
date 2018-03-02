//
//  TcpJsonPackage.swift
//  LinClient
//
//  Created by lin on 1/25/16.
//  Copyright © 2016 lin. All rights reserved.
//

import CessUtil


public protocol TcpJsonPackage : TcpPackage{
    
    var json:Json{get};
    
//    static var path:String{get};
    
    var path:String{get};
    
    
    func addHeader(_ header:String,value:String);
    
    func remove(_ header:String);
    
    subscript(idx:Int) -> Json {get set}


    subscript(key:String)->Json {get set}

    func setValue(_ value:Any?,forName name:String);
    
    func getValue(_ name:String)->Any?;

}

private class TcpJsonPackageImpl{
    
    fileprivate var _path:String!;
    fileprivate var _json:Json!;
    
    var json:Json!{
        if _json == nil{
            _json = Json();
        }
        return _json;
    }
    
    fileprivate var headers:Dictionary<String,String>;// = [:];
    
    func setHeaders(_ headers:Dictionary<String,String>){
        for (key,value) in headers {
            self.headers[key] = value;
        }
        
    }
    
    init(path:String!,json:Json!,headers:Dictionary<String,String>){
        self._path = path;
        self._json = json;
        self.headers = headers;
    }
    
 
    
    
    func addHeader(_ header:String,value:String){
        self.headers[header] = value;
    }
    
    func remove(_ header:String){
        headers.removeValue(forKey: header);
    }
    
    func write() -> [UInt8] {
        let stringBuffer = NSMutableString();
        
        stringBuffer.append("path:");
        stringBuffer.append(self._path);
        stringBuffer.append("\r\n");
        
        stringBuffer.append("encoding:utf-8\r\n");
        
        for (key,value) in headers{
            stringBuffer.append(key);
            stringBuffer.append(":");
            stringBuffer.append(value);
            stringBuffer.append("\r\n");
        }
        
        stringBuffer.append("\r\n");
        
        stringBuffer.append(json.toString());
        
        let len = stringBuffer.lengthOfBytes(using: String.Encoding.utf8.rawValue);
        let ptr:UnsafePointer<Int8> = stringBuffer.cString(using: String.Encoding.utf8.rawValue)!;
        
        var r = [UInt8](repeating: 0, count: len);
        for n in 0 ..< len {
            r[n] = asUInt8(ptr[n]);
        }
        return r;
    }
    
    func write(_ buffer: inout [UInt8]) {
        
    }
    
    fileprivate subscript(idx:Int) -> Json {
        get{
            return json[idx];
        }
        set{
            json[idx] = newValue;
        }
    }


    fileprivate subscript(key:String)->Json {
        get{
            return json[key];
        }
        set{
            json[key] = newValue;
        }
    }

    fileprivate func setValue(_ value:Any?,forName name:String){
        self.json.setValue(value, forName: name);
    }
    fileprivate func getValue(_ name:String)->Any?{
        return self.json.getValue(name);
    }
}

open class TcpJsonRequestPackage : TcpRequestPackage,TcpJsonPackage{
    
    override final public class var type:UInt8{
        return 6;
    }
    
    fileprivate var impl:TcpJsonPackageImpl;
    
    open var json:Json{
        return impl.json;
    }

    open class var path:String{
        return "/";
    }
    
    public final var path:String{
        return impl._path;
    }
    
    func setPath(_ path:String){
        impl._path = path;
    }
    
    func setJson(_ json:Json){
        impl._json = json;
    }
    
    func setHeaders(_ headers:Dictionary<String,String>){
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
    
    open func addHeader(_ header:String,value:String){
        impl.addHeader(header, value: value);
    }
    
    open func remove(_ header:String){
        impl.remove(header);
    }
    
    open override func write() -> [UInt8] {
        return impl.write();
    }
    
    open override func write(_ buffer: inout [UInt8]) {
        impl.write(&buffer);
    }
    
    open subscript(idx:Int) -> Json {
        get{
            return impl[idx];
        }
        set{
            impl[idx] = newValue;
        }
    }


    open subscript(key:String)->Json {
        get{
            return impl[key];
        }
        set{
            impl[key] = newValue;
        }
    }

    open func setValue(_ value:Any?,forName name:String){
        impl.setValue(value, forName: name);
    }
    open func getValue(_ name:String)->Any?{
        return impl.getValue(name);
    }
}

open class TcpJsonResponsePackage : TcpResponsePackage,TcpJsonPackage{
    
    override final public class var type:UInt8{
        return 6;
    }
    
    fileprivate var impl:TcpJsonPackageImpl;
    
    open var json:Json{
        if impl._json == nil {
            impl._json = Json();
        }
        return impl.json;
    }
    
    
    public final var path:String{
        return impl._path;
    }
    
    func setPath(_ path:String){
        impl._path = path;
    }
    
    func setJson(_ json:Json){
        impl._json = json;
    }
    
    func setHeaders(_ headers:Dictionary<String,String>){
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
    
    
    open func addHeader(_ header:String,value:String){
        impl.addHeader(header, value: value);
    }
    
    open func remove(_ header:String){
        impl.remove(header);
    }
    
    open override func write() -> [UInt8] {
        return impl.write();
    }
    
    open override func write(_ buffer: inout [UInt8]) {
        impl.write(&buffer);
    }
    
    open subscript(idx:Int) -> Json {
        get{
            return impl[idx];
        }
        set{
            impl[idx] = newValue;
        }
    }
    
    
    open subscript(key:String)->Json {
        get{
            return impl[key];
        }
        set{
            impl[key] = newValue;
        }
    }
    
    open func setValue(_ value:Any?,forName name:String){
        impl.setValue(value, forName: name);
    }
    open func getValue(_ name:String)->Any?{
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
