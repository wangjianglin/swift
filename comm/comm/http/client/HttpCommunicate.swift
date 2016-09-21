//
//  HttpCommunicate.swift
//  LinClient
//
//  Created by lin on 12/1/14.
//  Copyright (c) 2014 lin. All rights reserved.
//

import Foundation
import LinUtil


//HTTP通信实现类
open class HttpCommunicate{
    
    struct YRSingleton{
        static var predicate:Int = 0
        static var instance:HttpCommunicateArgs? = nil
    }
    
    fileprivate static var __once: () = {

                YRSingleton.instance = HttpCommunicateArgs()

            }()

    

    

    open class var commUrl:String{
        get{ return global.commUrl; }
        set{ global.commUrl = newValue; }
    }
    
    open class var mainThread:Bool{
        get{ return global.mainThread; }
        set{ global.mainThread = newValue; }
    }
    
    open class var isDebug:Bool{
        get{ return global.isDebug; }
        set{ global.isDebug = newValue; }
    }
    
    open class var httpDns:HttpDNS?{
        get{return global.httpDns;}
        set{global.httpDns = newValue;}
    }
    
    open class var headers:IndexProperty<String,String>{
        return global.headers;
    }
    
    open class func removeHeader(_ header:String){
        global.removeHeader(header);
    }
    
    open class func request(_ package:HttpPackage,result:((_ obj:AnyObject?,_ warning:[HttpError])->())? = nil,fault:((_ error:HttpError)->())? = nil)->HttpCommunicateResult{
        return global.request(package,result:result,fault:fault);
    }
    
    open class func upload(_ package:HttpUploadPackage,result:((_ obj:AnyObject?,_ warning:[HttpError])->())! = nil,fault:((_ error:HttpError)->())! = nil,progress:((_ send:Int64,_ total:Int64) -> Void)! = nil)->HttpCommunicateResult{
        return global.upload(package,result:result,fault:fault,progress:progress);
    }
 
    
    open class var install:HttpCommunicateArgs{
        get{
            //return _install;
            _ = HttpCommunicate.__once
            return YRSingleton.instance!
        }
    }
    
    open class var httprequestComplete:((HttpPackage,AnyObject?,[HttpError])->())?{
        get{ return global.httprequestComplete;}
        set{ global.httprequestComplete = newValue;}
    }
    
    
    open class var httprequestFault:((HttpPackage,HttpError)->())?{
        get{ return global.httprequestFault;}
        set{ global.httprequestFault = newValue;}
    }
    
    
    open class var httprequest:((HttpPackage)->())?{
        get{ return global.httprequest;}
        set{ global.httprequest = newValue;}
    }
    
    open class var global:HttpCommunicateImpl{
        get{
            return HttpCommunicate.install["global"];
        }
    }
    
}

open class HttpCommunicateImpl{
    
    fileprivate init(name:String){
        self.name = name;
    }
    
    open var mainThread:Bool = false;
    open var isDebug:Bool = false;
    
    fileprivate var name:String;
    
    open var httpDns:HttpDNS?;
    
    open var _headers = IndexProperty<String,String>();
    open var headers:IndexProperty<String,String>{
        return _headers;
    }
    
    open func removeHeader(_ header:String){
        headers.remove(header);
    }
    //private var request:HttpTask;
    
    fileprivate var _commUrl = "http://192.168.1.8:8080/lin.demo/";
    open var commUrl:String{
        get{ return _commUrl;}
        set{
            self._commUrl=newValue;
            if !self._commUrl.hasSuffix("/"){
                self._commUrl += "/";
            }
        }
    }
    
    open func upload(_ package:HttpUploadPackage,result:((_ obj:AnyObject?,_ warning:[HttpError])->())! = nil,fault:((_ error:HttpError)->())! = nil,progress:((_ send:Int64,_ total:Int64) -> Void)! = nil)->HttpCommunicateResult{
        let task = HttpTask(impl:self);
        task.httpDns = self.httpDns;
        
        //        var params = Dictionary<String,AnyObject>();
        //
        //        for (name,value) in package.json.toParams() {
        //            params[name] = value;
        //        }
        //
        //        for (name,value) in package.files {
        //            params[name] = value;
        //        }
        
        self.httprequest?(package);
        let params = package.handle.getParams(task,package:package);
        let httpResult = HttpCommunicateResult();
        
        task.uploadFile(HttpUtils.url(self, pack: package), parameters: params,isDebug:self.isDebug,progress: package.progress, success: { (response) -> Void in
            package.handle.response(package, response: response.responseObject, result: self.mainThreadResult(httpResult,pack:package,result:result), fault: self.mainThreadFault(httpResult,pack:package,fault:fault));
            
            }) { (error,response) -> Void in
                
                let e:HttpError = HttpError(code:-1);
                e.message = "net error.";
                e.cause = "net error.";
                e.strackTrace = error.description;
                
                self.mainThreadFault(httpResult,pack:package,fault:fault)(e);
                
        };

        return httpResult;
    }
    
    open var httprequestComplete:((HttpPackage,AnyObject?,[HttpError])->())?
    
    
    open var httprequestFault:((HttpPackage,HttpError)->())?
    
    
    open var httprequest:((HttpPackage)->())?
    
    fileprivate func mainThreadResult(_ httpResult:HttpCommunicateResult,pack:HttpPackage,result:((_ obj:AnyObject?,_ warning:[HttpError])->())?)->((_ obj:AnyObject?,_ warning:[HttpError])->()){

        let tmpResult = {[weak httpResult](obj:AnyObject?,warning:[HttpError]) ->() in
            
            httpResult?.setResult(obj,success:true);
            self.httprequestComplete?(pack,obj,warning);
            if let result = result {
//                if self.mainThread == false || Thread.current.isMainThread || httpResult?.set.canEnterMainThread() ?? false == false {
//                    
//                    result(obj,warning);
//                    httpResult?.set.set();
//                }else{
//                    
//                    DispatchQueue.main.async(execute: {() in
//                        result(obj,warning);
//                        httpResult?.set.set();
//                    });
//                }
                httpResult?.set.set(mainThreadction: { 
                    result(obj,warning);
                })
            }else{
                httpResult?.set.set();
            }
        }
        return tmpResult;

    }
    fileprivate func mainThreadFault(_ httpResult:HttpCommunicateResult,pack:HttpPackage,fault:((_ error:HttpError)->())?)->((_ error:HttpError)->()){
    
        let tmpFault = {[weak httpResult](error:HttpError) ->() in
            httpResult?.setError(error);
            self.httprequestFault?(pack,error);
            if let fault = fault {
//                if self.mainThread == false || Thread.current.isMainThread || httpResult?.set.canEnterMainThread() ?? false == false {
//                    fault(error);
//                    httpResult?.set.set();
//                }else{
//                    DispatchQueue.main.async(execute: {() in
//                        fault(error);
//                        httpResult?.set.set();
//                    });
//                }
                httpResult?.set.set(mainThreadction: { 
                    fault(error);
                })
            }else{
                httpResult?.set.set();
            }
        }
        return tmpFault;
    }

    open func request(_ package:HttpPackage,result:((_ obj:AnyObject?,_ warning:[HttpError])->())! = nil,fault:((_ error:HttpError)->())! = nil)->HttpCommunicateResult{
        if let uploadPackage = package as? HttpUploadPackage{
            return self.upload(uploadPackage,result:result,fault:fault,progress:uploadPackage.progress);
        }
        let httpResult = HttpCommunicateResult();
        
        self.httprequest?(package);
        let request:HttpTask = HttpTask(impl:self);
        request.httpDns = self.httpDns;
        
        requestImpl(request,package:package,url:HttpUtils.url(self, pack: package), parameters: package.handle.getParams(request,package:package),isDebug:self.isDebug, success: {(response: HttpResponse) in
            
            package.handle.response(package, response: response.responseObject, result: self.mainThreadResult(httpResult,pack:package,result:result), fault: self.mainThreadFault(httpResult,pack:package,fault:fault));
            },failure: {(error: NSError?,response: HttpResponse?) in
                
                //println("error: \(error)")
                
                //-1004 端口不对
                //-1003 域名不对
                //-1001
                //-1005  NSURLErrorDomain
                let e:HttpError = HttpError(code:-2);
                e.message = "net error.";
                e.cause = "net error.";
                e.strackTrace = error?.description;
                self.mainThreadFault(httpResult,pack:package,fault:fault)(e);
        })
        
        return httpResult;
    }
    
    fileprivate func requestImpl(_ request:HttpTask,package:HttpPackage,url: String, parameters: Dictionary<String,AnyObject>?,isDebug:Bool, success:((HttpResponse) -> Void)!, failure:((NSError, HttpResponse?) -> Void)!) {
        let opt = request.create(url, method:package.method, parameters: parameters,isDebug:isDebug,success:success,failure:failure)
        if opt != nil {
            opt!.start()
        }
    }
}

    
open class HttpCommunicateArgs{
    
    var insts:Dictionary<String,HttpCommunicateImpl>;
    var lock:NSLock;
    
    fileprivate init(){
        self.insts = Dictionary<String,HttpCommunicateImpl>();
        self.lock = NSLock();
    }
    
    open subscript(name:String)->HttpCommunicateImpl {
        get{
            //线程同步
            //@synchronized(self){
            var impl = insts[name];
            if let i = impl{
                return i;
            }
            lock.lock();
            impl = insts[name];
            if impl == nil{
                impl = HttpCommunicateImpl(name:name);
                insts[name] = impl;
            }
            lock.unlock();
            return impl!;
             //   return HttpCommunicate(name:name);
            //}
        }
//            set{
//                
//            }
    }
}
    //class var test:Dictionary<String,String> = Dictionary<String,String>();




