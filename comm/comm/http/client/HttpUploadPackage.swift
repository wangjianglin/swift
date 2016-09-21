//
//  HttpUploadPackage.swift
//  LinClient
//
//  Created by lin on 1/7/15.
//  Copyright (c) 2015 lin. All rights reserved.
//

import Foundation

open class HttpUploadPackage : HttpPackage{
    
    
    struct YRSingleton{
        static var predicate:Int = 0
        static var instance:FileUploadHttpRequestHandle? = nil
    }
  
    fileprivate static var __once: () = {

            YRSingleton.instance = FileUploadHttpRequestHandle()

        }()

    

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
    
    open class var FILE_UPLOAD_HANDLE:HttpRequestHandle {
        
        _ = HttpUploadPackage.__once
        return YRSingleton.instance!
    }
    
    
    open var progress:((_ send:Int64,_ total:Int64) -> Void)!;
    
    fileprivate var _files:Dictionary<String,HttpUpload>;
    
    internal var files:Dictionary<String,HttpUpload>{
        return _files;
    }
    
    open func addFile(_ name:String,file:String){
        _files[name] = HttpUpload(fileUrl: URL(fileURLWithPath: file));
    }
    
    open func addFile(_ name:String,data: Data, fileName: String, mimeType: String){
        _files[name] = HttpUpload(data: data, fileName: fileName, mimeType: mimeType);
    }
    
    open func getFile(_ name:String)->HttpUpload?{
        return _files[name];
    }
    
    open func remove(_ name:String){
        _files.removeValue(forKey: name);
    }
}
