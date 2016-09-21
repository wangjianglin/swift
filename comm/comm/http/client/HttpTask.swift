//////////////////////////////////////////////////////////////////////////////////////////////////
//
//  HTTPTask.swift
//
//  Created by Dalton Cherry on 6/3/14.
//  Copyright (c) 2014 Vluxe. All rights reserved.
//
//////////////////////////////////////////////////////////////////////////////////////////////////

import Foundation
import LinUtil
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


/// Object representation of a HTTP Response.


/// Holds the blocks of the background task.
class BackgroundBlocks {
    // these 2 only get used for background download/upload since they have to be delegate methods
    var success:((HttpResponse) -> Void)?
    var failure:((NSError, HttpResponse?) -> Void)?
    var progress:((Double) -> Void)?
    
    /** 
        Initializes a new Background Block
        
        - parameter success: The block that is run on a sucessful HTTP Request.
        - parameter failure: The block that is run on a failed HTTP Request.
        - parameter progress: The block that is run on the progress of a HTTP Upload or Download.
    */
    init(_ success: ((HttpResponse) -> Void)?, _ failure: ((NSError, HttpResponse?) -> Void)?,_ progress: ((Double) -> Void)?) {
        self.failure = failure
        self.success = success
        self.progress = progress
    }
}

/// Subclass of NSOperation for handling and scheduling HTTPTask on a NSOperationQueue.
open class HttpOperation : Operation {
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

/// Configures NSURLSession Request for HTTPOperation. Also provides convenience methods for easily running HTTP Request.
open class HttpTask : NSObject, URLSessionDelegate, URLSessionTaskDelegate {
    var backgroundTaskMap = Dictionary<String,BackgroundBlocks>()
    //var sess: NSURLSession?
    
    open var baseURL: String?
    open var httpDns:HttpDNS?;
    open var requestSerializer = HttpRequestSerializer()
    open var responseSerializer: HttpResponseSerializer?
    //This gets called on auth challenges. If nil, default handling is use.
    //Returning nil from this method will cause the request to be rejected and cancelled
    open var auth:((URLAuthenticationChallenge) -> URLCredential?)?
    
    fileprivate var impl:HttpCommunicateImpl
    //MARK: Public Methods
    
    /// A newly minted HTTPTask for your enjoyment.
    
    //private var config:NSURLSessionConfiguration;// = NSURLSessionConfiguration.defaultSessionConfiguration()
    //private var cookies:NSHTTPCookieStorage;
    //private var session:Foundation.URLSession!;//(configuration: config, delegate: self, delegateQueue: nil)
    fileprivate var session:URLSession!;
    public init(impl:HttpCommunicateImpl) {
        //self.config = NSURLSessionConfiguration.defaultSessionConfiguration();
        //self.config.HTTPCookieStorage = NSHTTPCookieStorage();
        //self.cookies = NSHTTPCookieStorage()
        
        // makes no difference whether it's set or left at default
        //self.config.HTTPCookieStorage = self.cookies;
        //self.config.HTTPCookieAcceptPolicy = NSHTTPCookieAcceptPolicy.Always
        self.impl = impl;
        super.init()
        
        let config:URLSessionConfiguration = URLSessionConfiguration.default;
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
        self.session = Foundation.URLSession(configuration: config, delegate: self, delegateQueue: nil)
    }
    
    /** 
        Creates a HTTPOperation that can be scheduled on a NSOperationQueue. Called by convenience HTTP verb methods below.
    
        - parameter url: The url you would like to make a request to.
        - parameter method: The HTTP method/verb for the request.
        - parameter parameters: The parameters are HTTP parameters you would like to send.
        - parameter success: The block that is run on a sucessful HTTP Request.
        - parameter failure: The block that is run on a failed HTTP Request.
    
        - returns: A freshly constructed HTTPOperation to add to your NSOperationQueue.
    */
    public func create(_ url: String, method: HttpMethod, parameters: Dictionary<String,AnyObject>!,isDebug:Bool, success:((HttpResponse) -> Void)!, failure:((NSError, HttpResponse?) -> Void)!) ->  HttpOperation? {

        let serialReq = createRequest(url, method: method, parameters: parameters,isDebug:isDebug,headers:impl.headers)
        if serialReq.error != nil {
            if failure != nil {
                failure(serialReq.error!, nil)
            }
            return nil
        }
        let opt = HttpOperation()
 
        let task = session.dataTask(with: serialReq.request as URLRequest,
            completionHandler: {(data: Data?, response: URLResponse?, error: Error?) -> Void in
                opt.finish()
                self.processResponse(success,failure:failure,data:data,response:response,error:error as NSError!);

        });
        opt.task = task
        return opt
    }
    
    private func processResponse(_ success:((HttpResponse) -> Void)!, failure:((NSError, HttpResponse?) -> Void)!,data: Data!, response: URLResponse!, error: NSError!){
        if error != nil {
            if failure != nil {
                failure(error, nil)
            }
            return
        }
        if let data = data {
            var responseObject: AnyObject = data as AnyObject
            if self.responseSerializer != nil {
                let resObj = self.responseSerializer!.responseObjectFromResponse(response, data: data)
                if resObj.error != nil {
                    if failure != nil {
                        failure(resObj.error!, nil)
                    }
                    return
                }
                if resObj.object != nil {
                    responseObject = resObj.object!
                }
            }
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
                    failure(self.createError(extraResponse.statusCode!), extraResponse)
                }
            } else if success != nil {
                success(extraResponse)
            }
        } else if failure != nil {
            failure(error, nil)                                     
        }
    }
    
    /**
        Creates a HTTPOperation as a HTTP GET request and starts it for you.
    
        - parameter url: The url you would like to make a request to.
        - parameter parameters: The parameters are HTTP parameters you would like to send.
        - parameter success: The block that is run on a sucessful HTTP Request.
        - parameter failure: The block that is run on a failed HTTP Request.
    */
    public func GET(_ url: String, parameters: Dictionary<String,AnyObject>?,isDebug:Bool, success:((HttpResponse) -> Void)!, failure:((NSError, HttpResponse?) -> Void)!) {
        let opt = self.create(url, method:.GET, parameters: parameters,isDebug:isDebug,success: success,failure: failure)
        if opt != nil {
            opt!.start()
        }
    }
    
    /**
        Creates a HTTPOperation as a HTTP POST request and starts it for you.
        
        - parameter url: The url you would like to make a request to.
        - parameter parameters: The parameters are HTTP parameters you would like to send.
        - parameter success: The block that is run on a sucessful HTTP Request.
        - parameter failure: The block that is run on a failed HTTP Request.
    */
    public func POST(_ url: String, parameters: Dictionary<String,AnyObject>?,isDebug:Bool, success:((HttpResponse) -> Void)!, failure:((NSError, HttpResponse?) -> Void)!) {
        let opt = self.create(url, method:.POST, parameters: parameters,isDebug:isDebug,success: success,failure: failure)
        if opt != nil {
            opt!.start()
        }
    }
    
    /**
        Creates a HTTPOperation as a HTTP PUT request and starts it for you.
        
        - parameter url: The url you would like to make a request to.
        - parameter parameters: The parameters are HTTP parameters you would like to send.
        - parameter success: The block that is run on a sucessful HTTP Request.
        - parameter failure: The block that is run on a failed HTTP Request.
    */
    public func PUT(_ url: String, parameters: Dictionary<String,AnyObject>?,isDebug:Bool, success:((HttpResponse) -> Void)!, failure:((NSError, HttpResponse?) -> Void)!) {
        let opt = self.create(url, method:.PUT, parameters: parameters,isDebug:isDebug,success: success,failure: failure)
        if opt != nil {
            opt!.start()
        }
    }
    
    /**
        Creates a HTTPOperation as a HTTP DELETE request and starts it for you.
        
        - parameter url: The url you would like to make a request to.
        - parameter parameters: The parameters are HTTP parameters you would like to send.
        - parameter success: The block that is run on a sucessful HTTP Request.
        - parameter failure: The block that is run on a failed HTTP Request.
    */
    public func DELETE(_ url: String, parameters: Dictionary<String,AnyObject>?,isDebug:Bool, success:((HttpResponse) -> Void)!, failure:((NSError, HttpResponse?) -> Void)!)  {
        let opt = self.create(url, method:.DELETE, parameters: parameters,isDebug:isDebug,success: success,failure: failure)
        if opt != nil {
            opt!.start()
        }
    }
    
    /**
        Creates a HTTPOperation as a HTTP HEAD request and starts it for you.
        
        - parameter url: The url you would like to make a request to.
        - parameter parameters: The parameters are HTTP parameters you would like to send.
        - parameter success: The block that is run on a sucessful HTTP Request.
        - parameter failure: The block that is run on a failed HTTP Request.
    */
    public func HEAD(_ url: String, parameters: Dictionary<String,AnyObject>?,isDebug:Bool, success:((HttpResponse) -> Void)!, failure:((NSError, HttpResponse?) -> Void)!) {
        let opt = self.create(url, method:.HEAD, parameters: parameters,isDebug:isDebug,success: success,failure: failure)
        if opt != nil {
            opt!.start()
        }
    }
    
    /**
        Creates and starts a HTTPOperation to download a file in the background.
    
        - parameter url: The url you would like to make a request to.
        - parameter parameters: The parameters are HTTP parameters you would like to send.
        - parameter progress: The progress returned in the progress block is between 0 and 1.
        - parameter success: The block that is run on a sucessful HTTP Request. The HTTPResponse responseObject object will be a fileURL. You MUST copy the fileURL return in HTTPResponse.responseObject to a new location before using it (e.g. your documents directory).
        - parameter failure: The block that is run on a failed HTTP Request.
    */
    public func download(_ url: String, parameters: Dictionary<String,AnyObject>?,progress:((Double) -> Void)!,isDebug:Bool, success:((HttpResponse) -> Void)!, failure:((NSError, HttpResponse?) -> Void)!) -> URLSessionDownloadTask? {
        let serialReq = createRequest(url,method: .GET, parameters: parameters,isDebug:isDebug,headers:impl.headers)
        if serialReq.error != nil {
            failure(serialReq.error!, nil)
            return nil
        }
        let ident = createBackgroundIdent()
        let config = URLSessionConfiguration.background(withIdentifier: ident)
        let session = Foundation.URLSession(configuration: config, delegate: self, delegateQueue: nil)
        let task = session.downloadTask(with: serialReq.request as URLRequest)
        self.backgroundTaskMap[ident] = BackgroundBlocks(success,failure,progress)
        //this does not have to be queueable as Apple's background dameon *should* handle that.
        task.resume()
        return task
    }
    
    //TODO: not implemented yet.
    /// not implemented yet.
    public func uploadFile(_ url: String, parameters: Dictionary<String,AnyObject>?,isDebug:Bool, progress:((Int64,Int64) -> Void)!, success:((HttpResponse) -> Void)!, failure:((NSError,HttpResponse?) -> Void)!) -> Void {
        

        let serialReq = createRequest(url,method: .GET, parameters: parameters,isDebug:isDebug,isMulti:true,headers:impl.headers)
        if serialReq.error != nil {
            failure(serialReq.error!,nil)
            return
        }
        self.uploadProgress = progress;
//        self.uploadSuccess = success;
//        self.uploadFailure = failure;
        
//        var task = session.uploadTaskWithRequest(serialReq.request, fromData: nil);
        let task = session.uploadTask(with: serialReq.request as URLRequest, from:nil, completionHandler: {(data:Data?,response: URLResponse?, error:Error?) in
            self.processResponse(success,failure:failure,data:data,response:response,error:error as NSError!);
        });
        task.resume();
        
    }
    
    private var uploadProgress:((Int64,Int64) -> Void)!;
//    private var uploadSuccess:((HttpResponse) -> Void)!;
//    private var uploadFailure:((NSError,HttpResponse) -> Void)!;
    
    //MARK: Private Helper Methods
    
    /**
        Creates and starts a HTTPOperation to download a file in the background.
    
        - parameter url: The url you would like to make a request to.
        - parameter method: The HTTP method/verb for the request.
        - parameter parameters: The parameters are HTTP parameters you would like to send.
    
        - returns: A NSURLRequest from configured requestSerializer.
    */
    fileprivate func createRequest(_ url: String, method: HttpMethod, parameters: Dictionary<String,AnyObject>!,isDebug:Bool,isMulti:Bool? = nil,headers:IndexProperty<String,String>) -> (request: NSMutableURLRequest, error: NSError?) {
        var urlVal = url
        //probably should change the 'http' to something more generic
        if !url.hasPrefix("http") && self.baseURL != nil {
            let split = url.hasPrefix("/") ? "" : "/"
            urlVal = "\(self.baseURL!)\(split)\(url)"
        }
        
        var nsurl = URL(string: urlVal);
        
        var hostName:String?;
        var ip:String?;
        
        if let httpDns = self.httpDns {
            hostName = nsurl!.host;
//            ip = [httpDNS getIpByHost:hostName];
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
        
        let result = self.requestSerializer.createRequest(URL(string: urlVal)!,
        method: method, parameters: parameters,isMulti : isMulti);
        
        for (key,value) in headers {
            result.request.setValue(value,forHTTPHeaderField:key);
        }
        
//        result.request.setValue("",forHTTPHeaderField:HTTP_COMM_PROTOCOL);
//        if isDebug {
//            result.request.setValue("",forHTTPHeaderField:HTTP_COMM_PROTOCOL_DEBUG);
//        }
        if ip != nil {
            result.request.setValue(hostName, forHTTPHeaderField: "Host");
        }
        return result;
    }
    
    /**
        Creates a random string to use for the identifier of the background download/upload requests.
    
        - returns: Identifier String.
    */
    fileprivate func createBackgroundIdent() -> String {
        let letters = "abcdefghijklmnopqurstuvwxyz"
        var str = ""
        for _ in 0 ..< 14 {
            let start = Int(arc4random() % 14)
            str.append(letters[letters.characters.index(letters.startIndex, offsetBy: start)])
        }
        return "com.vluxe.swifthttp.request.\(str)"
    }
    
    /**
        Creates a random string to use for the identifier of the background download/upload requests.
        
        - parameter code: Code for error.
        
        - returns: An NSError.
    */
    fileprivate func createError(_ code: Int) -> NSError {
        var text = "An error occured"
        if code == 404 {
            text = "page not found"
        } else if code == 401 {
            text = "accessed denied"
        }
        return NSError(domain: "HTTPTask", code: code, userInfo: [NSLocalizedDescriptionKey: text])
    }
    
    
    /**
        Creates a random string to use for the identifier of the background download/upload requests.
        
        - parameter identifier: The identifier string.
        
        - returns: An NSError.
    */
    fileprivate func cleanupBackground(_ identifier: String) {
        self.backgroundTaskMap.removeValue(forKey: identifier)
    }
    
    //MARK: NSURLSession Delegate Methods
    
    /// Method for authentication challenge.
    public func urlSession(_ session: URLSession, task: URLSessionTask, didReceive challenge: URLAuthenticationChallenge, completionHandler: (Foundation.URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if let a = auth {
            let cred = a(challenge)
            if let c = cred {
                completionHandler(.useCredential, c)
            }
            completionHandler(.rejectProtectionSpace, nil)
            return
        }
        completionHandler(.performDefaultHandling, nil)
    }
    
    /// Called when the background task failed.
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if error != nil {
//            println("error:\(error)");
//            println("identifier:\(session.configuration)");
//            println("identifier:\(session.configuration.identifier)");
//            let blocks = self.backgroundTaskMap[session.configuration.identifier]
//            if blocks?.failure != nil { //Swift bug. Can't use && with block (radar: 17469794)
//                blocks?.failure!(error, nil)
//                cleanupBackground(session.configuration.identifier)
//            }
        }
    }
    
    /// The background download finished and reports the url the data was saved to.
    func URLSession(_ session: Foundation.URLSession!, downloadTask: URLSessionDownloadTask!, didFinishDownloadingToURL location: URL!) {
        let blocks = self.backgroundTaskMap[session.configuration.identifier!]
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
                if blocks?.failure != nil {
                    blocks?.failure!(self.createError(resp.statusCode!), resp)
                }
                return
            }
            blocks?.success!(resp)
            cleanupBackground(session.configuration.identifier!)
        }
    }
    
    /// Will report progress of background download
    func URLSession(_ session: Foundation.URLSession!, downloadTask: URLSessionDownloadTask!, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let increment = 100.0/Double(totalBytesExpectedToWrite)
        var current = (increment*Double(totalBytesWritten))*0.01
        if current > 1 {
            current = 1;
        }
        let blocks = self.backgroundTaskMap[session.configuration.identifier!]
        if blocks?.progress != nil {
            blocks?.progress!(current)
        }
    }
    
    /// The background download finished, don't have to really do anything.
    public func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
//        println("ok.");
    }
    
    //TODO: not implemented yet.
    /// not implemented yet. The background upload finished and reports the response data (if any).
    func URLSession(_ session: Foundation.URLSession!, dataTask: URLSessionDataTask!, didReceiveData data: Data!) {
        //add upload finished logic
//        var str = NSString(data: data, encoding: NSUTF8StringEncoding);
//        if let success = self.uploadSuccess {
//            var response = HttpResponse();
//            response.responseObject = data;
//            success(response);
//        }
    }
    
    //TODO: not implemented yet.
    /// not implemented yet.
    public func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        //add progress block logic
        if let progress = self.uploadProgress {
            progress(totalBytesSent,totalBytesExpectedToSend);
        }
    }
    
    //TODO: not implemented yet.
    /// not implemented yet.
    func URLSession(_ session: Foundation.URLSession!, downloadTask: URLSessionDownloadTask!, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
//        println("ok.");
    }
    
    deinit{
        print("http task deinit.");
    }
}
