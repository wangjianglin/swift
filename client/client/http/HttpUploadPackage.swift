//
//  HttpUploadPackage.swift
//  LinClient
//
//  Created by lin on 1/7/15.
//  Copyright (c) 2015 lin. All rights reserved.
//

import Foundation

public class HttpUploadPackage : HttpPackage{
    
    public init(url:String){
        _files = Dictionary<String,HttpUpload>();
        super.init(url: url, method: HttpMethod.POST);
//        self._json = JSON();
        //handle = HttpUploadPackage.FILE_UPLOAD_HANDLE;
        //handle = HttpPackage.STANDARD_HANDLE;
        //handle = HttpPackage.ENCRYPT_JSON_HANDLE;
        
//        self._url = url;
//        self._method = method;
    }
    
    public class var FILE_UPLOAD_HANDLE:HttpRequestHandle {
        
        struct YRSingleton{
            static var predicate:dispatch_once_t = 0
            static var instance:FileUploadHttpRequestHandle? = nil
        }
        dispatch_once(&YRSingleton.predicate,{
            YRSingleton.instance = FileUploadHttpRequestHandle()
        })
        return YRSingleton.instance!
    }
    
    
    public var progress:((send:Int64,total:Int64) -> Void)!;
    
    private var _files:Dictionary<String,HttpUpload>;
    
    internal var files:Dictionary<String,HttpUpload>{
        return _files;
    }
    
    public func addFile(name:String,file:String){
        _files[name] = HttpUpload(fileUrl: NSURL(fileURLWithPath: file));
    }
    
    public func addFile(name:String,data: NSData, fileName: String, mimeType: String){
        _files[name] = HttpUpload(data: data, fileName: fileName, mimeType: mimeType);
    }
    
    public func getFile(name:String)->HttpUpload?{
        return _files[name];
    }
    
    public func remove(name:String){
        _files.removeValueForKey(name);
    }
}