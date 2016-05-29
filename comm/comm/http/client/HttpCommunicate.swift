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
public class HttpCommunicate{
    
    
    public class var commUrl:String{
        get{ return global.commUrl; }
        set{ global.commUrl = newValue; }
    }
    
    public class var mainThread:Bool{
        get{ return global.mainThread; }
        set{ global.mainThread = newValue; }
    }
    
    public class var isDebug:Bool{
        get{ return global.isDebug; }
        set{ global.isDebug = newValue; }
    }
    
    public class var httpDns:HttpDNS?{
        get{return global.httpDns;}
        set{global.httpDns = newValue;}
    }
    
    public class func request(package:HttpPackage,result:((obj:AnyObject!,warning:[HttpError])->())? = nil,fault:((error:HttpError)->())? = nil)->HttpCommunicateResult{
        return global.request(package,result:result,fault:fault);
    }
    
    public class func upload(package:HttpUploadPackage,result:((obj:AnyObject!,warning:[HttpError])->())! = nil,fault:((error:HttpError)->())! = nil,progress:((send:Int64,total:Int64) -> Void)! = nil)->HttpCommunicateResult{
        return global.upload(package,result:result,fault:fault,progress:progress);
    }
 
    
    public class var install:HttpCommunicateArgs{
        get{
            //return _install;
            struct YRSingleton{
                static var predicate:dispatch_once_t = 0
                static var instance:HttpCommunicateArgs? = nil
            }
            dispatch_once(&YRSingleton.predicate,{
                YRSingleton.instance = HttpCommunicateArgs()
            })
            return YRSingleton.instance!
        }
    }
    
    public class var httprequestComplete:((HttpPackage,AnyObject!,[HttpError])->())?{
        get{ return global.httprequestComplete;}
        set{ global.httprequestComplete = newValue;}
    }
    
    
    public class var httprequestFault:((HttpPackage,HttpError)->())?{
        get{ return global.httprequestFault;}
        set{ global.httprequestFault = newValue;}
    }
    
    
    public class var httprequest:((HttpPackage)->())?{
        get{ return global.httprequest;}
        set{ global.httprequest = newValue;}
    }
    
    public class var global:HttpCommunicateImpl{
        get{
            return HttpCommunicate.install["global"];
        }
    }
    
//    class public func commUlr(){
//        
//    }
    
}

public class HttpCommunicateImpl{
    
    private init(name:String){
        self.name = name;
        //self.request = HttpTask();
    }
    
    public var mainThread:Bool = false;
    public var isDebug:Bool = false;
    
    private var name:String;
    
    public var httpDns:HttpDNS?;
    //private var request:HttpTask;
    
    private var _commUrl = "http://192.168.1.8:8080/lin.demo/";
    public var commUrl:String{
        get{ return _commUrl;}
        set{
            self._commUrl=newValue;
            if !self._commUrl.hasSuffix("/"){
                self._commUrl += "/";
            }
        }
    }
    
    public func upload(package:HttpUploadPackage,result:((obj:AnyObject!,warning:[HttpError])->())! = nil,fault:((error:HttpError)->())! = nil,progress:((send:Int64,total:Int64) -> Void)! = nil)->HttpCommunicateResult{
        let task = HttpTask();
        task.httpDns = self.httpDns;
        
        var params = Dictionary<String,AnyObject>();
        let httpResult = HttpCommunicateResult();
//        let set = AutoResetEvent();
//        httpResult.set = set;
        
        for (name,value) in package.json.toParams() {
            params[name] = value;
        }
        
        for (name,value) in package.files {
            params[name] = value;
        }
        self.httprequest?(package);
        task.uploadFile(HttpUtils.url(self, pack: package), parameters: params,isDebug:self.isDebug,progress: package.progress, success: { (response) -> Void in
                //println("success");
//                httpResult.setResult(true);
            package.handle.response(package, response: response.responseObject, result: self.mainThreadResult(httpResult,pack:package,result:result), fault: self.mainThreadFault(httpResult,pack:package,fault:fault));
                
                //set.set();
                
            }) { (error,response) -> Void in
                //println("error.")
                let e:HttpError = HttpError(code:-1);
                e.message = "net error.";
                e.cause = "net error.";
                e.strackTrace = error.description;
                
//                httpResult.setResult(false);
                self.mainThreadFault(httpResult,pack:package,fault:fault)(error:e);
                
                //set.set();
        };

        return httpResult;
    }
    
    public var httprequestComplete:((HttpPackage,AnyObject!,[HttpError])->())?
    
    
    public var httprequestFault:((HttpPackage,HttpError)->())?
    
    
    public var httprequest:((HttpPackage)->())?
    
    private func mainThreadResult(httpResult:HttpCommunicateResult,pack:HttpPackage,result:((obj:AnyObject!,warning:[HttpError])->())?)->((obj:AnyObject!,warning:[HttpError])->()){

        let tmpResult = {[weak httpResult](obj:AnyObject!,warning:[HttpError]) ->() in
            
            httpResult?.setResult(obj,success:true);
            self.httprequestComplete?(pack,obj,warning);
            if let result = result {
                if self.mainThread == false || NSThread.currentThread().isMainThread || httpResult?.set.canEnterMainThread() ?? false == false {
                    
                    result(obj: obj,warning: warning);
//                    set.set();
                    httpResult?.set.set();
                }else{
                    
                    dispatch_async(dispatch_get_main_queue(), {() in
                        result(obj: obj,warning: warning);
//                        set.set();
                        httpResult?.set.set();
                    });
                }
            }else{
//                set.set();
                httpResult?.set.set();
            }
        }
        return tmpResult;

    }
    private func mainThreadFault(httpResult:HttpCommunicateResult,pack:HttpPackage,fault:((error:HttpError)->())?)->((error:HttpError)->()){
    
        let tmpFault = {[weak httpResult](error:HttpError) ->() in
//            httpResult?.setResult(nil,success:false);
            httpResult?.setError(error);
            self.httprequestFault?(pack,error);
            if let fault = fault {
                if self.mainThread == false || NSThread.currentThread().isMainThread || httpResult?.set.canEnterMainThread() ?? false == false {
                    fault(error: error);
//                    set.set();
                    httpResult?.set.set();
                }else{
                    dispatch_async(dispatch_get_main_queue(), {() in
                        fault(error: error);
//                        set.set();
                        httpResult?.set.set();
                    });
                }
            }else{
//                set.set();
                httpResult?.set.set();
            }
        }
        return tmpFault;
    }

    public func request(package:HttpPackage,result:((obj:AnyObject!,warning:[HttpError])->())! = nil,fault:((error:HttpError)->())! = nil)->HttpCommunicateResult{
        if let uploadPackage = package as? HttpUploadPackage{
            return self.upload(uploadPackage,result:result,fault:fault,progress:uploadPackage.progress);
        }
        let httpResult = HttpCommunicateResult();
//        let set = AutoResetEvent();
//        httpResult.set = set;
        
        self.httprequest?(package);
        let request:HttpTask = HttpTask();
        request.httpDns = self.httpDns;
        
        requestImpl(request,package:package,url:HttpUtils.url(self, pack: package), parameters: package.handle.getParams(request,package:package),isDebug:self.isDebug, success: {(response: HttpResponse) in
            
            package.handle.response(package, response: response.responseObject, result: self.mainThreadResult(httpResult,pack:package,result:result), fault: self.mainThreadFault(httpResult,pack:package,fault:fault));
                //set.set();
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
                self.mainThreadFault(httpResult,pack:package,fault:fault)(error:e);
                
                //set.set();
        })
        
        return httpResult;
    }
    
    private func requestImpl(request:HttpTask,package:HttpPackage,url: String, parameters: Dictionary<String,AnyObject>?,isDebug:Bool, success:((HttpResponse) -> Void)!, failure:((NSError, HttpResponse?) -> Void)!) {
        let opt = request.create(url, method:package.method, parameters: parameters,isDebug:isDebug,success:success,failure:failure)
        if opt != nil {
            opt!.start()
        }
    }
}

    
public class HttpCommunicateArgs{
    
    var insts:Dictionary<String,HttpCommunicateImpl>;
    var lock:NSLock;
    
    private init(){
        self.insts = Dictionary<String,HttpCommunicateImpl>();
        self.lock = NSLock();
    }
    
    public subscript(name:String)->HttpCommunicateImpl {
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




