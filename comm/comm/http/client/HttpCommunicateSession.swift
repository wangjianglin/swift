//
//  HttpCommunicateSession.swift
//  LinComm
//
//  Created by lin on 19/12/2017.
//  Copyright © 2017 lin. All rights reserved.
//

import Foundation
import LinUtil
import CoreData


class HttpCommunicateSession  : NSObject, URLSessionDelegate, URLSessionTaskDelegate {
    private struct YSInstance{
        static var backgroundTaskMap = Dictionary<String,HttpCommunicateSessionParams>();
        static var completionHandlerDictionary = Dictionary<String,() -> Swift.Void>();
        static var coreDataContext:NSManagedObjectContext! = nil;
    }
    
    private static let __init:() = {
        // 从应用程序包中加载模型文件
        //        NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
        
        // 传入模型对象，初始化NSPersistentStoreCoordinator
        //        NSPersistentStoreCoordinator *psc = [[[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model] autorelease];
        let model = NSManagedObjectModel.mergedModel(from: nil);
        let psc = NSPersistentStoreCoordinator.init(managedObjectModel: model!);
        // 构建SQLite数据库文件的路径
        //        NSString *docs = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        let docs = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true).last as NSString?;
        //        NSURL *url = [NSURL fileURLWithPath:[docs stringByAppendingPathComponent:@"person.data"]];
        let url = NSURL.fileURL(withPath: docs?.appendingPathComponent("coredata.data") ?? "");
        // 添加持久化存储库，这里使用SQLite作为存储库
        //        NSError *error = nil;
        //        NSPersistentStore *store = [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error];
        //        let store = try? psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil);
        ////        if (store == nil) { // 直接抛异常
        ////            [NSException raise:@"添加数据库错误" format:@"%@", [error localizedDescription]];
        ////        }
        ////        // 初始化上下文，设置persistentStoreCoordinator属性
        ////        NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init];
        ////        context.persistentStoreCoordinator = psc;
        //        YSInstance.coreDataContext = NSManagedObjectContext();
        //        YSInstance.coreDataContext.persistentStoreCoordinator = psc;
    }()
    
    public func addHandleEventsForBackgroundURLSession(identifier: String, completionHandler: @escaping () -> Swift.Void){
        YSInstance.completionHandlerDictionary[identifier] = completionHandler;
        //        let config = URLSessionConfiguration.background(withIdentifier: identifier);
        //        _ = Foundation.URLSession(configuration: config, delegate: self, delegateQueue: nil);
        
//        let data = BackgroundDown();
        
        _ = HttpCommunicateSession.__init;
        //        NSEntityDescription.i
    }
    
    
    open var baseURL: String?
    open var httpDns:HttpDNS?;
    private var createHttpRequest = CreateHttpRequest()
    open var auth:((URLAuthenticationChallenge) -> URLCredential?)?
    
    fileprivate var impl:HttpCommunicateImpl;
    fileprivate var session:URLSession!;
    public init(impl:HttpCommunicateImpl) {
        self.impl = impl;
        super.init()
        
        _ = HttpCommunicateSession.__init;
        //
        let config:URLSessionConfiguration = URLSessionConfiguration.default;
        self.session = Foundation.URLSession(configuration: config, delegate: nil, delegateQueue: nil)
        
    }
    
    public func create(params:HttpCommunicateSessionParams)->HttpOperation?{
        
        let serialReq = createRequest(params: params);
        if let error = serialReq.error {
            params.failure?(error, nil)
            return nil
        }
        let opt = HttpOperation()
        
        let task = session.dataTask(with: serialReq.request,
                                    completionHandler: {(data: Data?, response: URLResponse?, error: Error?) -> Void in
                                        opt.finish()
        self.processResponse(params.success,failure:params.failure,data:data as AnyObject,response:response,error:error as NSError!);
        });
        
//        let task = session.dataTask(with: serialReq.request)
//        YSInstance.backgroundTaskMap["\(String(describing: session.configuration.identifier))\(task.hash)"] = params;
        opt.task = task
        return opt
    }
    
    private func processResponse(_ success:((HttpClientResponse) -> Void)!, failure:((NSError, HttpClientResponse?) -> Void)!,data: AnyObject!, response: URLResponse!, error: NSError!){
        if error != nil {
            if failure != nil {
                failure(error, nil)
            }
            return
        }
        if let data = data {
            let responseObject: AnyObject = data
            let extraResponse = HttpClientResponse()
            if let hresponse = response as? HTTPURLResponse {
                extraResponse.headers = hresponse.allHeaderFields as? Dictionary<String,String>
                extraResponse.mimeType = hresponse.mimeType
                extraResponse.suggestedFilename = hresponse.suggestedFilename
                extraResponse.statusCode = hresponse.statusCode
                extraResponse.URL = hresponse.url
            }
            extraResponse.responseObject = responseObject
            if extraResponse.statusCode > 299 {
                if failure != nil {
                    failure(self.createError(extraResponse.statusCode), extraResponse)
                }
            } else if success != nil {
                success(extraResponse)
            }
        } else if failure != nil {
            failure(error, nil)
        }
    }
    
    public func download(params:HttpCommunicateSessionParams)->URLSessionDownloadTask?{
        let serialReq = createRequest(params: params);
        if serialReq.error != nil {
            params.failure?(serialReq.error!, nil)
            return nil
        }
        
        var ident:String!;
        
        if let identifier = params.identifier {
            ident = identifier;
        }else{
            ident = createBackgroundIdent();
        }
        
        let session = Foundation.URLSession.shared
        
        let task =   session.downloadTask(with: serialReq.request) { (location, response, error) in
            
            self.processResponse(params.success,failure:params.failure,data:location as AnyObject,response:response,error:error as NSError!);
        }
        
        YSInstance.backgroundTaskMap["\(ident)\(task.hash)"] = params;
        task.resume()
        return task
    }
    
    public func uploadFile(params:HttpCommunicateSessionParams){
        
        let serialReq = createRequest(params: params);
        if let error = serialReq.error {
            params.failure?(error,nil)
            return
        }
        
        var ident:String!;
        
        if let identifier = params.identifier {
            ident = identifier;
        }else{
            ident = createBackgroundIdent();
        }
        
        let config = URLSessionConfiguration.background(withIdentifier: ident);
        let session = Foundation.URLSession(configuration: config, delegate: self, delegateQueue: nil);
        
        let task = session.uploadTask(withStreamedRequest: serialReq.request);
        YSInstance.backgroundTaskMap["\(ident)\(task.hash)"] = params;
        
        task.resume();
        
    }
    
    private func createRequest(params:HttpCommunicateSessionParams)->(request:URLRequest,error:NSError?){
        var urlVal = params.url
        //probably should change the 'http' to something more generic
        if !params.url.hasPrefix("http") && self.baseURL != nil {
            let split = params.url.hasPrefix("/") ? "" : "/"
            urlVal = "\(self.baseURL!)\(split)\(params.url)"
        }
        
        var nsurl = URL(string: urlVal);
        
        var hostName:String?;
        var ip:String?;
        
        if let httpDns = self.httpDns {
            hostName = nsurl!.host;
            ip = httpDns.getIpByHost(hostName!);
            if ip != nil {
                
                let hostFirstRange = urlVal.range(of: hostName!);
                if let hostFirstRange = hostFirstRange {
                    let newUrl = urlVal.replacingCharacters(in: hostFirstRange, with: ip!);
                    nsurl = URL(string: newUrl);
                }else{
                    ip = nil;
                }
            }
            
            
        }
        
        let result = self.createHttpRequest.createRequest(URL(string: urlVal)!,
                                                          method: params.method, parameters: params.parameters,isMulti : params.isMulti);
        
        var request = result.request;
        
        
        if let headers = params.headers {
            for (key,value) in headers {
                request.addValue(value,forHTTPHeaderField:key);
            }
        }
        
        if ip != nil {
            request.addValue(hostName ?? "", forHTTPHeaderField: "Host");
        }
        if let timeout = params.timeout {
            request.timeoutInterval = timeout;
        }
        
        return (request,result.error);
    }
    
    fileprivate func createBackgroundIdent() -> String {
        let letters = "1234567890!@#$%^&*()-_=+`~qwertyuioplkjhgfdsazxcvbnmQWERTYUIOPLKJHGFDSAZXCVBNM[]:,<';./>?|"
        var str = ""
        for _ in 0 ..< 64 {
            let start = Int(arc4random() % 90);
            str.append(letters[letters.characters.index(letters.startIndex, offsetBy: start)])
        }
        return "background iden:\(str)";
    }
    
    fileprivate func createError(_ code: Int) -> NSError {
        var text = "An error occured"
        if code == 404 {
            text = "page not found"
        } else if code == 401 {
            text = "accessed denied"
        }
        return NSError(domain: "HTTPTask", code: code, userInfo: [NSLocalizedDescriptionKey: text])
    }
    
    fileprivate func cleanupBackground(_ identifier: String) {
        YSInstance.backgroundTaskMap.removeValue(forKey: identifier)
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (Foundation.URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        //        if let a = auth {
        //            let cred = a(challenge)
        //            if let c = cred {
        let credential = URLCredential.init(trust: challenge.protectionSpace.serverTrust!)
        completionHandler(.useCredential, credential)
        //            }
        //            completionHandler(.rejectProtectionSpace, nil)
        //            return
        //        }
        //        completionHandler(.performDefaultHandling, nil)
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
        let sessionId = "\(String(describing: session.configuration.identifier))\(task.hash)";
        
        let blocks = YSInstance.backgroundTaskMap[sessionId]
        if let error = error {
            let resp = HttpClientResponse()
//            if let nerror = error {
            blocks?.failure?(error as NSError,resp);
//            }else{
//                let nerror = NSError.init(domain: "net error.", code: -1, userInfo: [:])
//                blocks?.failure?(nerror,resp);
//            }
        }else if let blocks = blocks, blocks.success != nil {
            
            let resp = HttpClientResponse()
            if let hresponse = task.response as? HTTPURLResponse {
                resp.headers = hresponse.allHeaderFields as? Dictionary<String,String>
                resp.mimeType = hresponse.mimeType
                resp.suggestedFilename = hresponse.suggestedFilename
                resp.statusCode = hresponse.statusCode
                resp.URL = hresponse.url
            }
            resp.responseObject = blocks.data as NSData?;
            if resp.statusCode > 299 {
                blocks.failure?(self.createError(resp.statusCode), resp);
            }else{
                blocks.success?(resp)
            }
        }
        cleanupBackground(sessionId)
        //session.finishTasksAndInvalidate();
    }
    
    func URLSession(_ session: Foundation.URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingToURL location: URL) {
        
        let sessionId = "\(String(describing: session.configuration.identifier))\(downloadTask.hash)";
        
        let blocks = YSInstance.backgroundTaskMap[sessionId]
        if blocks?.success != nil {
            let resp = HttpClientResponse()
            if let hresponse = downloadTask.response as? HTTPURLResponse {
                resp.headers = hresponse.allHeaderFields as? Dictionary<String,String>
                resp.mimeType = hresponse.mimeType
                resp.suggestedFilename = hresponse.suggestedFilename
                resp.statusCode = hresponse.statusCode
                resp.URL = hresponse.url
            }
            resp.responseObject = location as AnyObject?
            if resp.statusCode > 299 {
                blocks?.failure?(self.createError(resp.statusCode), resp)
            }else{
                blocks?.success?(resp)
            }
            cleanupBackground(sessionId)
        }
    }
    
    /// Will report progress of background download
    // didWriteData：本次写入的数据大小
    // totalBytesWritten：共下载了多少数据
    // totalBytesExpectedToWrite：估计大小，也就是总数据大小
    func URLSession(_ session: Foundation.URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let blocks = YSInstance.backgroundTaskMap["\(String(describing: session.configuration.identifier))\(downloadTask.hash)"]
        blocks?.progress?(totalBytesWritten,totalBytesExpectedToWrite, bytesWritten);
    }
    
    //private var forBackgroundURLSession:Bool = false;
    /// The background download finished, don't have to really do anything.
    public func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        
        if let identifier = session.configuration.identifier {
            YSInstance.completionHandlerDictionary[identifier]?();
        }
        
    }
    
    //TODO: not implemented yet.
    /// not implemented yet. The background upload finished and reports the response data (if any).
    func URLSession(_ session: Foundation.URLSession, dataTask: URLSessionDataTask, didReceiveData data: Data) {
        let blocks = YSInstance.backgroundTaskMap["\(String(describing: session.configuration.identifier))\(dataTask.hash)"]
        
        if let blocks = blocks {
            blocks.data.append(data);
        }
    }
    
    //TODO: not implemented yet.
    /// not implemented yet.
    public func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        let blocks = YSInstance.backgroundTaskMap["\(String(describing: session.configuration.identifier))\(task.hash)"]
        blocks?.progress?(totalBytesSent,totalBytesExpectedToSend, bytesSent);
    }
    
    //TODO: not implemented yet.
    /// not implemented yet.
    func URLSession(_ session: Foundation.URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        print("ok.");
    }
}



internal class HttpCommunicateSessionParams{
    public var url: String;
    
    public init(url:String){
        self.url = url;
    }
    public var identifier:String?;
    public var method: HttpMethod = HttpMethod.GET;
    public var parameters: Dictionary<String,AnyObject>?;
    public var headers:Dictionary<String,String>?;
    public var success:((HttpClientResponse) -> Void)?;
    public var failure:((NSError, HttpResponse?) -> Void)?;
    public var progress:((_ down: Int64, _ expected: Int64, _ bytes: Int64)->Void)?;
    fileprivate var isMulti:Bool?;
    public var timeout:TimeInterval?;
    
    fileprivate var data = Data();
}

/// Subclass of NSOperation for handling and scheduling HTTPTask on a NSOperationQueue.
internal class HttpOperation : Operation {
    fileprivate var task: URLSessionDataTask!
    fileprivate var stopped = false
    fileprivate var running = false
    
    /// Controls if the task is finished or not.
    open var done = false
    
    //MARK: Subclassed NSOperation Methods
    
    /// Returns if the task is asynchronous or not. This should always be false.
    override open var isAsynchronous: Bool {
        return false
    }
    
    /// Returns if the task has been cancelled or not.
    override open var isCancelled: Bool {
        return stopped
    }
    
    /// Returns if the task is current running.
    override open var isExecuting: Bool {
        return running
    }
    
    /// Returns if the task is finished.
    override open var isFinished: Bool {
        return done
    }
    
    /// Returns if the task is ready to be run or not.
    override open var isReady: Bool {
        return !running
    }
    
    /// Starts the task.
    override open func start() {
        super.start()
        stopped = false
        running = true
        done = false
        task.resume()
    }
    
    /// Cancels the running task.
    override open func cancel() {
        super.cancel()
        running = false
        stopped = true
        done = true
        task.cancel()
    }
    
    /// Sets the task to finished.
    open func finish() {
        self.willChangeValue(forKey: "isExecuting")
        self.willChangeValue(forKey: "isFinished")
        
        running = false
        done = true
        
        self.didChangeValue(forKey: "isExecuting")
        self.didChangeValue(forKey: "isFinished")
    }
}
