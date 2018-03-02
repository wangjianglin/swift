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
    
    public class FileInfo{
        
        private var _location:NSURL!;
        public var location:NSURL!{
            return _location;
        }
        fileprivate func setLocation(_ url:NSURL!){
            _location = url;
        }
        
        private var _fileName:String!;
        public var fileName:String!{
            return _fileName;
        }
        fileprivate func setFileName(_ name:String!){
            _fileName = name;
        }
        
        private var _fileSize:UInt64 = 0;
        public var fileSize:UInt64 {
            return _fileSize;
        }
        
        fileprivate func setFileSize(_ size:UInt64){
            _fileSize = size;
        }
    }
    
    public class Params{
        open var mainThread:Bool? = nil;
        
        open var isDebug:Bool? = nil;
        
        open var timeout:TimeInterval? = nil;//以秒为单位
        
        internal var header = [String:String]();
    }
    
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
    
    open class var timeout:TimeInterval{
        get{ return global.timeout; }
        set{ global.timeout = newValue; }
    }
    
    open class var mainThread:Bool{
        get{ return global.mainThread; }
        set{ global.mainThread = newValue; }
    }
    
    open class var isDebug:Bool{
        get{ return global.isDebug; }
        set{ global.isDebug = newValue; }
    }
    
    open class var authentication:Authentication?{
        get{return global.authentication;}
        set{global.authentication = newValue;}
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
    
    open class func upload(_ package:HttpUploadPackage,result:((_ obj:AnyObject?,_ warning:[HttpError])->())! = nil,fault:((_ error:HttpError)->())! = nil,progress:((_ send:Int64,_ total:Int64,_ bytes:Int64) -> Void)! = nil)->HttpCommunicateResult{
        return global.upload(package,result:result,fault:fault,progress:progress);
    }
    
    //    public class func download(url:String)->HttpCommunicateResult{
    public class func download(url:String,result:((_ fileInfo:FileInfo?,_ warning:[HttpError])->())! = nil,fault:((_ error:HttpError)->())! = nil,progress:((_ down: Int64, _ expected: Int64, _ bytes: Int64)->Void)? = nil)->HttpCommunicateResult{
        return global.download(url: url,result: result,fault: fault,progress: progress);
    }
    
    public class func download(package:HttpDownloadPackage,result:((_ fileInfo:FileInfo?,_ warning:[HttpError])->())! = nil,fault:((_ error:HttpError)->())! = nil,progress:((_ down: Int64, _ expected: Int64, _ bytes: Int64)->Void)? = nil)->HttpCommunicateResult{
        return global.download(package: package,result: result,fault: fault,progress: progress);
    }
    
    public class func addHandleEventsForBackgroundURLSession(identifier: String, completionHandler: @escaping () -> Swift.Void){
        global.addHandleEventsForBackgroundURLSession(identifier: identifier, completionHandler: completionHandler);
        
    }
    
    open class var install:HttpCommunicateArgs{
        get{
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
    
    open class var http:Mock{
        return global.http;
    }
    
    public class Mock {
        
        private var httpResult = [NSObject:Any]();
        private var httpError = [NSObject:HttpError]();
        private var resultListener:((HttpPackage)->Any?)?;
        private var errorListener:((HttpPackage)->HttpError?)?;
        
        fileprivate init(){}
        
        public func clear() {
            httpResult.removeAll();
            httpError.removeAll();
            resultListener = nil;
            errorListener = nil;
        }
        
        public func mock(pack:HttpPackage, result:Any?) {
            httpResult[pack] = result;
        }
        
        public func mock(cls : HttpPackage.Type, result:Any?) {
            httpResult["cls:\(NSStringFromClass(cls))" as NSString] = result;
        }
        
        public func mock(pack:HttpPackage, error:HttpError) {
            httpError[pack] = error;
        }
        
        public func mock(cls:HttpPackage.Type, error:HttpError) {
            httpError["cls:\(NSStringFromClass(cls))" as NSString] = error;
        }
        
        public func removeMock(packe:HttpPackage) {
            httpResult.removeValue(forKey: packe);
            httpError.removeValue(forKey: packe);
        }
        
        public func removeMock(cls:HttpPackage.Type) {
            httpResult.removeValue(forKey: "cls:\(NSStringFromClass(cls))" as NSString);
            httpError.removeValue(forKey: "cls:\(NSStringFromClass(cls))" as NSString);
        }
        
        public func result(listener:@escaping ((HttpPackage)->Any?)) {
            resultListener = listener;
        }
        
        public func error(listener:@escaping ((HttpPackage)->HttpError?)) {
            errorListener = listener;
        }
        
        
        
        //func process(ThreadPoolExecutor executor, final lin.comm.http.ResultListener listener, HttpPackage pack) {
        func process(queue:Queue,pack:HttpPackage, result:((_ obj:AnyObject?,_ warning:[HttpError])->())! = nil,fault:((_ error:HttpError)->())! = nil)->Bool {
        
            var error = httpError[pack];
            if (error == nil) {
                error = httpError["cls:\(NSStringFromClass(pack.classForCoder))" as NSString];
            }
            
            if (error == nil && errorListener != nil) {
                error = errorListener?(pack);
            }
            
            if (error != nil) {
                if(fault != nil){
                    queue.asynQueue {
                        fault?(error!)
                    }
                }
                return true;
            }
            
            var resultObj = httpResult[pack];
            var hasResult = httpResult.index(forKey: pack) != nil;
            if (resultObj == nil && !hasResult) {
                resultObj = httpResult["cls:\(NSStringFromClass(pack.classForCoder))" as NSString];
            }
            
            hasResult = hasResult || httpResult.index(forKey: "cls:\(NSStringFromClass(pack.classForCoder))" as NSString) != nil;
            
            if (resultObj == nil && resultListener != nil && !hasResult) {
                resultObj = resultListener?(pack);
            }
            
            if (resultObj != nil || hasResult) {
                if(result != nil){
                    queue.asynQueue {
                        result?(resultObj as AnyObject, [HttpError]());
                    }
                }
                return true;
            }
            
            return false;
        }
        
    }
    
    
}

public class HttpCommunicateImpl{
    
    private var lazyMock:HttpCommunicate.Mock! = nil
    private var lazyQueue:Queue! = nil;
    open var authentication:Authentication?;
//    private lazy let __init:() = {
//        lazyMock = HttpCommunicate.Mock();
//        lazyQueue = Queue.init(count: 5);
//    }()
    
    public func addHandleEventsForBackgroundURLSession(identifier: String, completionHandler: @escaping () -> Swift.Void){
        httpSession.addHandleEventsForBackgroundURLSession(identifier: identifier, completionHandler: completionHandler);
    }
    private var httpSession:HttpCommunicateSession!;
    fileprivate init(name:String){
        self.name = name;
        //        super();
        httpSession = HttpCommunicateSession(impl: self);
        //        URLSessionConfiguration.init()
        //        var c = config.HTTPCookieStorage;
        //        config.HTTPCookieStorage = NSHTTPCookieStorage()
        //        println("cookies:\(c)");
        //        for var n=0;n<c?.cookies?.count;n++ {
        //            println("item:\(c?.cookies?[n])");
        //            var hc = c?.cookies?[n] as NSHTTPCookie;
        //            config.HTTPCookieStorage?.setCookie(hc);
        //        }
        
        //        println("cookies:\(config.HTTPCookieStorage)");
        //        var c2 = c?.cookies;
        //        config.HTTPCookieStorage.cookies = c2;
        //config.
        //        self.session = Foundation.URLSession(configuration: config, delegate: self, delegateQueue: nil)
    }
    
    open var mainThread:Bool = true;
    open var isDebug:Bool = false;
    
    fileprivate var name:String;
    
    open var httpDns:HttpDNS?{
        didSet{
            self.httpSession.httpDns = self.httpDns;
        }
    }
    
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
    
    open var timeout:TimeInterval = 10;
    
    private func getIsDebug(_ package:HttpPackage)->Bool{
        if let isDebug = package.commParams.isDebug {
            return isDebug;
        }
        return self.isDebug;
    }
    
    private func getMainThread(_ package:HttpPackage)->Bool{
        if let mainThread = package.commParams.mainThread {
            return mainThread;
        }
        return self.mainThread;
    }
    
    private func getTimeout(_ package:HttpPackage)->TimeInterval{
        if let timeout = package.commParams.timeout {
            return timeout;
        }
        return timeout;
    }
    
    open var http:HttpCommunicate.Mock{
        if let lazyMock = lazyMock {
            return lazyMock;
        }
        objc_sync_enter(self);
        if lazyMock == nil {
            lazyMock = HttpCommunicate.Mock();
            lazyQueue = Queue.init(count: 5);
        }
        objc_sync_exit(self);
        return lazyMock;
    }
    
    open var httprequestComplete:((HttpPackage,AnyObject?,[HttpError])->())?
    
    
    open var httprequestFault:((HttpPackage,HttpError)->())?
    
    
    open var httprequest:((HttpPackage)->())?
    
    fileprivate func mainThreadResult(_ httpResult:HttpCommunicateResult,pack:HttpPackage,result:((_ obj:AnyObject?,_ warning:[HttpError])->())?)->((_ obj:AnyObject?,_ warning:[HttpError])->()){
        
        return {[weak self](obj:AnyObject?,warning:[HttpError]) ->() in
            self?.fireResult(httpResult: httpResult, obj: obj, warning: warning, pack: pack, result: result);
        }
        
    }
    
    private func fireResult<T:AnyObject>(httpResult:HttpCommunicateResult,obj:T?,warning:[HttpError],pack:HttpPackage,result:((_ obj:T?,_ warning:[HttpError])->())?){
        httpResult.setResult(obj);
        self.httprequestComplete?(pack,obj,warning);
        if getMainThread(pack) {
            httpResult.set(mainThreadction: {
                result?(obj,warning);
            })
        }else{
            result?(obj,warning);
            httpResult.set();
        }
    }
    
    fileprivate func mainThreadFault(_ httpResult:HttpCommunicateResult,pack:HttpPackage,fault:((_ error:HttpError)->())?)->((_ error:HttpError)->()){
        
        return {[weak self](error:HttpError) ->() in
            self?.fireFault(httpResult: httpResult, pack: pack, error: error, fault: fault);
        }
    }
    
    private func fireFault(httpResult:HttpCommunicateResult,pack:HttpPackage,error:HttpError,fault:((_ error:HttpError)->())?){
        httpResult.setError(error);
        self.httprequestFault?(pack,error);
        if getMainThread(pack) {
            httpResult.set(mainThreadction: {
                fault?(error);
            })
        }else{
            fault?(error);
            httpResult.set();
        }
    }
    
    private func generParams(package:HttpPackage)->(params:Dictionary<String,AnyObject>?,headers:IndexProperty<String,String>){
        
        let params = HttpCommunicate.Params();
        params.isDebug = self.getIsDebug(package);
        params.mainThread = self.getMainThread(package);
        let r = package.handle.preprocess(package, params: params);
        let packParams = package.handle.getParams(package);
        
        let headers = r?.headers ?? IndexProperty<String,String>();
        
        for (head,value) in self.headers {
            headers[head] = value;
        }
        
        return (packParams,headers);
    }
    
    open func request(_ package:HttpPackage,result:((_ obj:AnyObject?,_ warning:[HttpError])->())! = nil,fault:((_ error:HttpError)->())! = nil)->HttpCommunicateResult{
        
    
        if let mock = lazyMock {
            let mockHttpResult = HttpCommunicateResult();
            
            if(mock.process(queue:lazyQueue!,pack: package, result: self.mainThreadResult(mockHttpResult,pack:package,result:result), fault: self.mainThreadFault(mockHttpResult,pack:package,fault:fault))){
                return mockHttpResult;
            }
        }
        
        if let uploadPackage = package as? HttpUploadPackage{
            return self.upload(uploadPackage,result:result,fault:fault,progress:nil);
        }
        if let downloadPackage = package as? HttpDownloadPackage {
            return self.download(package: downloadPackage, result: result, fault: fault, progress: nil);
        }
        let httpResult = HttpCommunicateResult();
        
        self.httprequest?(package);
        
        if !NetWorkTool.isEnable3G() && !NetWorkTool.isEnableWIFI() {
            let error = HttpError(code:-2,message:"无网络，请检查系统设置");
            self.mainThreadFault(httpResult,pack:package,fault:fault)(error);
            return httpResult;
        }
        
        let url = HttpUtils.url(self, pack: package);
        let p = self.generParams(package: package);

        let params = HttpCommunicateSessionParams(url:url);
        params.method = package.method;
        params.parameters = p.params;
        params.headers = p.headers.toDict();
        params.timeout = self.getTimeout(package);
        params.success = {(response: HttpResponse) in
            
            package.handle.response(package, response: response.responseObject, result: self.mainThreadResult(httpResult,pack:package,result:result), fault: self.mainThreadFault(httpResult,pack:package,fault:fault));
        };
        params.failure = {(error: NSError?,response: HttpResponse?) in
            
            //println("error: \(error)")
            
            //-1004 端口不对
            //-1003 域名不对
            //-1001
            //-1005  NSURLErrorDomain
            let e:HttpError = HttpError(code:-2
                ,message:"net error."
                ,cause:"net error."
                ,stackTrace:error?.description
            );
            //            e.message = "net error.";
            //            e.cause = "net error.";
            //            e.strackTrace = error?.description;
            self.mainThreadFault(httpResult,pack:package,fault:fault)(e);
        };
        self.httpSession.request(params: params,httpResult:httpResult)
        //        self.httpTask.create(url,method: package.method,parameters: p.params,headers:p.headers.toDict(), success: {(response: HttpResponse) in
        //
        //            package.handle.response(package, response: response.responseObject, result: self.mainThreadResult(httpResult,pack:package,result:result), fault: self.mainThreadFault(httpResult,pack:package,fault:fault));
        //            },failure: {(error: NSError?,response: HttpResponse?) in
        //
        //                //println("error: \(error)")
        //
        //                //-1004 端口不对
        //                //-1003 域名不对
        //                //-1001
        //                //-1005  NSURLErrorDomain
        //                let e:HttpError = HttpError(code:-2);
        //                e.message = "net error.";
        //                e.cause = "net error.";
        //                e.strackTrace = error?.description;
        //                self.mainThreadFault(httpResult,pack:package,fault:fault)(e);
        //        })?.start()
        
        return httpResult;
    }
    
    //    fileprivate func requestImpl(_ package:HttpPackage, success:((HttpResponse) -> Void)!, failure:((NSError, HttpResponse?) -> Void)!) {
    //
    //
    //
    //        let opt = self.httpTask.create(url, method:package.method, parameters: parameters,headers:headers,success:success,failure:failure)
    //        if opt != nil {
    //            opt!.start()
    //        }
    //    }
    
    
    open func upload(_ package:HttpUploadPackage,result:((_ obj:AnyObject?,_ warning:[HttpError])->())! = nil,fault:((_ error:HttpError)->())! = nil,progress:((_ send:Int64,_ total:Int64,_ bytes:Int64) -> Void)! = nil)->HttpCommunicateResult{
        
        
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
        //        let params = package.handle.getParams(package);
        let p = self.generParams(package: package);
        
        let url = HttpUtils.url(self, pack: package);
        
        let backgroundIdentifier:String!;
        
        if let i = package.identifier{
            backgroundIdentifier = i;
        }else if package.upMode == HttpUploadPackage.UpMode.Background {
            let paramsString = NSMutableString();
            if let ps = p.params?.sorted(by: { (a, b) -> Bool in
                return a.key.compare(b.key) == ComparisonResult.orderedAscending;
            }){
                for item in ps {
                    paramsString.append(item.key);
                    paramsString.append("=");
                    switch item.value {
                    case let str as String:
                        paramsString.append(str);
                    default:
                        paramsString.append("cls:");
                        paramsString.append(NSStringFromClass(item.value.classForCoder));
                    }
                    paramsString.append("&");
                }
            }
            
            backgroundIdentifier = "\(url);\(package.method.rawValue);\(paramsString)%$#@!^&*()-=%$#@".ext.hmac(key: "identifier", algorithm: CryptoAlgorithm.SHA384);
        }else{
            backgroundIdentifier = nil;
        }
        
        let httpResult = HttpCommunicateResult();
        httpResult.setIdentifier(backgroundIdentifier);
        
        
        let params = HttpCommunicateSessionParams(url: url);
        params.identifier = backgroundIdentifier;
        params.parameters = p.params;
        params.headers = p.headers.toDict();
        params.progress = progress;
        params.timeout = self.getTimeout(package);
        params.success = { (response) -> Void in
            package.handle.response(package, response: response.responseObject, result: self.mainThreadResult(httpResult,pack:package,result:result), fault: self.mainThreadFault(httpResult,pack:package,fault:fault));
            
        }
        params.failure = { (error,response) -> Void in
            
            let e:HttpError = HttpError(code:-1
                ,message:"net error."
                ,cause:"net error."
                ,stackTrace:error.description
            );
            //            e.message = "net error.";
            //            e.cause = "net error.";
            //            e.strackTrace = error.description;
            
            self.mainThreadFault(httpResult,pack:package,fault:fault)(e);
            
        };
        self.httpSession.uploadFile(params: params);
        
        //        self.httpTask.uploadFile(HttpUtils.url(self, pack: package),identifier: nil, parameters: p.params,headers:p.headers.toDict(),progress: progress, success: { (response) -> Void in
        //            package.handle.response(package, response: response.responseObject, result: self.mainThreadResult(httpResult,pack:package,result:result), fault: self.mainThreadFault(httpResult,pack:package,fault:fault));
        //
        //        }) { (error,response) -> Void in
        //
        //            let e:HttpError = HttpError(code:-1);
        //            e.message = "net error.";
        //            e.cause = "net error.";
        //            e.strackTrace = error.description;
        //
        //            self.mainThreadFault(httpResult,pack:package,fault:fault)(e);
        //
        //        };
        
        return httpResult;
    }
    
    public func download(url:String,result:((_ fileInfo:HttpCommunicate.FileInfo?,_ warning:[HttpError])->())! = nil,fault:((_ error:HttpError)->())! = nil,progress:((_ down: Int64, _ expected: Int64, _ bytes: Int64)->Void)? = nil)->HttpCommunicateResult{
        return self.download(package: HttpDownloadPackage(url:url), result: result, fault: fault, progress: progress);
    }
    
    
    public func download(package:HttpDownloadPackage,result:((_ fileInfo:HttpCommunicate.FileInfo?,_ warning:[HttpError])->())! = nil,fault:((_ error:HttpError)->())! = nil,progress:((_ down: Int64, _ expected: Int64, _ bytes: Int64)->Void)? = nil)->HttpCommunicateResult{
        
        let httpResult = HttpCommunicateResult();
        
        let url = HttpUtils.url(self, pack: package);
        
        let backgroundIdentifier:String!;
        
        let p = self.generParams(package: package);
        
        if let i = package.identifier{
            backgroundIdentifier = i;
        }else if package.downMode == HttpDownloadPackage.DownMode.Background {
            let paramsString = NSMutableString();
            if let ps = p.params?.sorted(by: { (a, b) -> Bool in
                return a.key.compare(b.key) == ComparisonResult.orderedAscending;
            }){
                for item in ps {
                    paramsString.append(item.key);
                    paramsString.append("=");
                    switch item.value {
                    case let str as String:
                        paramsString.append(str);
                    default:
                        paramsString.append("cls:");
                        paramsString.append(NSStringFromClass(item.value.classForCoder));
                    }
                    paramsString.append("&");
                }
            }
            
            backgroundIdentifier = "\(url);\(package.method.rawValue);\(paramsString)%$#@!^&*()-=%$#@".ext.hmac(key: "identifier", algorithm: CryptoAlgorithm.SHA384);
        }else{
            backgroundIdentifier = nil;
        }
        
        let params = HttpCommunicateSessionParams(url: url);
        params.identifier = backgroundIdentifier;
        httpResult.setIdentifier(backgroundIdentifier);
        params.method = package.method;
        params.parameters = p.params;
        params.headers = p.headers.toDict();
        params.timeout = self.getTimeout(package);
        params.success = { (response) in
            
            let fileInfo = HttpCommunicate.FileInfo();
            fileInfo.setLocation(response.responseObject as! NSURL?);
            fileInfo.setFileSize(UInt64.init(response.headers?["Content-Length"] ?? "0") ?? 0);
            fileInfo.setFileName(response.URL?.lastPathComponent);
            
            if let disposition = response.headers?["Content-Disposition"]{
                if let r = disposition.range(of: "filename=") {
                    fileInfo.setFileName(disposition.substring(from: r.upperBound));
                }
            }
            
            self.fireResult(httpResult: httpResult, obj: fileInfo, warning: [HttpError](), pack: package, result: result);
            //            httpResult.setResult(fileInfo);
            //            httpResult.set.set();
        };
        
        params.failure = { (error, response) in
            //                print("error.")
            //
            //                httpResult.setError(HttpError(code: -1));
            //                httpResult.set.set();
            self.fireFault(httpResult: httpResult, pack: package, error: HttpError(code: -1), fault: fault);
        };
        
        params.progress = progress;
        
        self.httpSession.download(params: params);
        
        //        self.httpTask.download(url,identifier: backgroundIdentifier,method: package.method, parameters: p.params,headers: p.headers.toDict(), success: { (response) in
        //
        //            let fileInfo = HttpCommunicate.FileInfo();
        //            fileInfo.setLocation(response.responseObject as! NSURL?);
        //            fileInfo.setFileSize(UInt64.init(response.headers?["Content-Length"] ?? "0") ?? 0);
        //            fileInfo.setFileName(response.URL?.lastPathComponent);
        //
        //            if let disposition = response.headers?["Content-Disposition"]{
        //                if let r = disposition.range(of: "filename=") {
        //                    fileInfo.setFileName(disposition.substring(from: r.upperBound));
        //                }
        //            }
        //
        //            self.fireResult(httpResult: httpResult, obj: fileInfo, warning: [HttpError](), pack: package, result: result);
        //            //            httpResult.setResult(fileInfo);
        //            //            httpResult.set.set();
        //            },failure: { (error, response) in
        //            //                print("error.")
        //            //
        //            //                httpResult.setError(HttpError(code: -1));
        //            //                httpResult.set.set();
        //            self.fireFault(httpResult: httpResult, pack: package, error: HttpError(code: -1), fault: fault);
        //        }, progress: progress);
        return httpResult;
    }
}


public class HttpCommunicateArgs{
    
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




