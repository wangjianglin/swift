//
//  TcpJsonPackage.swift
//  LinClient
//
//  Created by lin on 1/25/16.
//  Copyright © 2016 lin. All rights reserved.
//

import LinUtil

public class TcpJsonPackage : TcpPackage{
    
    override public class var type:UInt8{
        return 6;
    }
    
    private var headers:Dictionary<String,String> = [:];
    
    private var _json:Json;
    private var _path:String!;
    
    public var json:Json{
        return _json;
    }
    
    public class var path:String{
        return "/";
    }
    
    public var path:String{
        return _path;
    }
    
    public init(path:String! = nil) {
        
        _json = Json();
        super.init();
        
        if _path == nil {
            _path = (Mirror(reflecting: self).subjectType as! TcpJsonPackage.Type).path;
        }else{
            _path = path!;
        }
    }
    
    init(path:String,json:Json){
        _json = json;
        _path = path;
    }
    
    public func add(header:String,value:String){
        headers[header] = value;
    }
    
    public func remove(header:String){
        headers.removeValueForKey(header);
    }
    
    public override func write() -> [UInt8] {
        let stringBuffer = NSMutableString();
        
        stringBuffer.appendString("path:");
        stringBuffer.appendString(self.path);
        stringBuffer.appendString("\r\n");
        
        stringBuffer.appendString("encoding:utf-8\r\n");
        
        for (key,value) in headers{
            stringBuffer.appendString(key);
            stringBuffer.appendString(":");
            stringBuffer.appendString(value);
            stringBuffer.appendString("\r\n");
        }
        
        stringBuffer.appendString("\r\n");
        
        stringBuffer.appendString(_json.toString());
        
        let len = stringBuffer.lengthOfBytesUsingEncoding(NSUTF8StringEncoding);
        let ptr:UnsafePointer<Int8> = stringBuffer.cStringUsingEncoding(NSUTF8StringEncoding);
        
        var r = [UInt8](count: len, repeatedValue: 0);
        for(var n=0;n<len;n++){
            r[n] = asUInt8(ptr[n]);
        }
        return r;
    }
    
    public override func write(inout buffer: [UInt8]) {
        
    }
}


extension TcpJsonPackage {
    
    public subscript(idx:Int) -> Json {
        get{
            return _json[idx];
        }
        set{
            _json[idx] = newValue;
        }
    }

    
    public subscript(key:String)->Json {
        get{
            return _json[key];
        }
        set{
            _json[key] = newValue;
        }
    }
    
    public func setValue(value:AnyObject?,forName name:String){
        self._json.setValue(value, forName: name);
    }
    public func getValue(name:String)->AnyObject?{
        return self._json.getValue(name);
    }
    
}