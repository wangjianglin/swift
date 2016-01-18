//////////////////////////////////////////////////////////////////////////////////////////////////
//
//  HTTPTask.swift
//
//  Created by Dalton Cherry on 6/3/14.
//  Copyright (c) 2014 Vluxe. All rights reserved.
//
//////////////////////////////////////////////////////////////////////////////////////////////////

import Foundation

/// HTTP Verbs.
///
/// - GET: For GET requests.
/// - POST: For POST requests.
/// - PUT: For PUT requests.
/// - HEAD: For HEAD requests.
/// - DELETE: For DELETE requests.
public enum HttpMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case HEAD = "HEAD"
    case DELETE = "DELETE"
}

/// Object representation of a HTTP Response.
public class HttpResponse {
    /// The header values in HTTP response.
    public var headers: Dictionary<String,String>?
    /// The mime type of the HTTP response.
    public var mimeType: String?
    /// The suggested filename for a downloaded file.
    public var suggestedFilename: String?
    /// The body or response data of the HTTP Response.
    public var responseObject: AnyObject?
    /// The status code of the HTTP Response.
    public var statusCode: Int?
    ///Returns the response as a string
    public func text() -> String? {
        if let d = self.responseObject as? NSData {
            return  NSString(data: d, encoding: NSUTF8StringEncoding) as? String;
        }
        return nil
    }
    /// The URL of the HTTP Response.
    public var URL: NSURL?
}

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
public class HttpOperation : NSOperation {
    private var task: NSURLSessionDataTask!
    private var stopped = false
    private var running = false
    
    /// Controls if the task is finished or not.
    public var done = false
    
    //MARK: Subclassed NSOperation Methods
    
    /// Returns if the task is asynchronous or not. This should always be false.
    override public var asynchronous: Bool {
        return false
    }
    
    /// Returns if the task has been cancelled or not.
    override public var cancelled: Bool {
        return stopped
    }
    
    /// Returns if the task is current running.
    override public var executing: Bool {
        return running
    }
    
    /// Returns if the task is finished.
    override public var finished: Bool {
        return done
    }
    
    /// Returns if the task is ready to be run or not.
    override public var ready: Bool {
        return !running
    }
    
    /// Starts the task.
    override public func start() {
        super.start()
        stopped = false
        running = true
        done = false
        task.resume()
    }
    
    /// Cancels the running task.
    override public func cancel() {
        super.cancel()
        running = false
        stopped = true
        done = true
        task.cancel()
    }
    
    /// Sets the task to finished.
    public func finish() {
        self.willChangeValueForKey("isExecuting")
        self.willChangeValueForKey("isFinished")
        
        running = false
        done = true
        
        self.didChangeValueForKey("isExecuting")
        self.didChangeValueForKey("isFinished")
    }
}

/// Configures NSURLSession Request for HTTPOperation. Also provides convenience methods for easily running HTTP Request.
public class HttpTask : NSObject, NSURLSessionDelegate, NSURLSessionTaskDelegate {
    var backgroundTaskMap = Dictionary<String,BackgroundBlocks>()
    //var sess: NSURLSession?
    
    public var baseURL: String?
    public var requestSerializer = HttpRequestSerializer()
    public var responseSerializer: HttpResponseSerializer?
    //This gets called on auth challenges. If nil, default handling is use.
    //Returning nil from this method will cause the request to be rejected and cancelled
    public var auth:((NSURLAuthenticationChallenge) -> NSURLCredential?)?
    
    //MARK: Public Methods
    
    /// A newly minted HTTPTask for your enjoyment.
    
    //private var config:NSURLSessionConfiguration;// = NSURLSessionConfiguration.defaultSessionConfiguration()
    //private var cookies:NSHTTPCookieStorage;
    private var session:NSURLSession!;//(configuration: config, delegate: self, delegateQueue: nil)
    public override init() {
        //self.config = NSURLSessionConfiguration.defaultSessionConfiguration();
        //self.config.HTTPCookieStorage = NSHTTPCookieStorage();
        //self.cookies = NSHTTPCookieStorage()
        
        // makes no difference whether it's set or left at default
        //self.config.HTTPCookieStorage = self.cookies;
        //self.config.HTTPCookieAcceptPolicy = NSHTTPCookieAcceptPolicy.Always
        super.init()
        
        let config:NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration();
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
        self.session = NSURLSession(configuration: config, delegate: self, delegateQueue: nil)
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
    public func create(url: String, method: HttpMethod, parameters: Dictionary<String,AnyObject>!,isDebug:Bool, success:((HttpResponse) -> Void)!, failure:((NSError, HttpResponse?) -> Void)!) ->  HttpOperation? {

        let serialReq = createRequest(url, method: method, parameters: parameters,isDebug:isDebug)
        if serialReq.error != nil {
            if failure != nil {
                failure(serialReq.error!, nil)
            }
            return nil
        }
        let opt = HttpOperation()
 
        let task = session.dataTaskWithRequest(serialReq.request,
            completionHandler: {(data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
                opt.finish()
                self.processResponse(success,failure:failure,data:data,response:response,error:error);

        });
        opt.task = task
        return opt
    }
    
    private func processResponse(success:((HttpResponse) -> Void)!, failure:((NSError, HttpResponse?) -> Void)!,data: NSData!, response: NSURLResponse!, error: NSError!){
        if error != nil {
            if failure != nil {
                failure(error, nil)
            }
            return
        }
        if data != nil {
            var responseObject: AnyObject = data
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
            let extraResponse = HttpResponse()
            if let hresponse = response as? NSHTTPURLResponse {
                extraResponse.headers = hresponse.allHeaderFields as? Dictionary<String,String>
                extraResponse.mimeType = hresponse.MIMEType
                extraResponse.suggestedFilename = hresponse.suggestedFilename
                extraResponse.statusCode = hresponse.statusCode
                extraResponse.URL = hresponse.URL
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
    public func GET(url: String, parameters: Dictionary<String,AnyObject>?,isDebug:Bool, success:((HttpResponse) -> Void)!, failure:((NSError, HttpResponse?) -> Void)!) {
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
    public func POST(url: String, parameters: Dictionary<String,AnyObject>?,isDebug:Bool, success:((HttpResponse) -> Void)!, failure:((NSError, HttpResponse?) -> Void)!) {
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
    public func PUT(url: String, parameters: Dictionary<String,AnyObject>?,isDebug:Bool, success:((HttpResponse) -> Void)!, failure:((NSError, HttpResponse?) -> Void)!) {
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
    public func DELETE(url: String, parameters: Dictionary<String,AnyObject>?,isDebug:Bool, success:((HttpResponse) -> Void)!, failure:((NSError, HttpResponse?) -> Void)!)  {
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
    public func HEAD(url: String, parameters: Dictionary<String,AnyObject>?,isDebug:Bool, success:((HttpResponse) -> Void)!, failure:((NSError, HttpResponse?) -> Void)!) {
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
    public func download(url: String, parameters: Dictionary<String,AnyObject>?,progress:((Double) -> Void)!,isDebug:Bool, success:((HttpResponse) -> Void)!, failure:((NSError, HttpResponse?) -> Void)!) -> NSURLSessionDownloadTask? {
        let serialReq = createRequest(url,method: .GET, parameters: parameters,isDebug:isDebug)
        if serialReq.error != nil {
            failure(serialReq.error!, nil)
            return nil
        }
        let ident = createBackgroundIdent()
        let config = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier(ident)
        let session = NSURLSession(configuration: config, delegate: self, delegateQueue: nil)
        let task = session.downloadTaskWithRequest(serialReq.request)
        self.backgroundTaskMap[ident] = BackgroundBlocks(success,failure,progress)
        //this does not have to be queueable as Apple's background dameon *should* handle that.
        task.resume()
        return task
    }
    
    //TODO: not implemented yet.
    /// not implemented yet.
    public func uploadFile(url: String, parameters: Dictionary<String,AnyObject>?,isDebug:Bool, progress:((Int64,Int64) -> Void)!, success:((HttpResponse) -> Void)!, failure:((NSError,HttpResponse?) -> Void)!) -> Void {
        

        let serialReq = createRequest(url,method: .GET, parameters: parameters,isDebug:isDebug,isMulti:true)
        if serialReq.error != nil {
            failure(serialReq.error!,nil)
            return
        }
        self.uploadProgress = progress;
//        self.uploadSuccess = success;
//        self.uploadFailure = failure;
        
//        var task = session.uploadTaskWithRequest(serialReq.request, fromData: nil);
        
        let task = session.uploadTaskWithRequest(serialReq.request, fromData:nil, completionHandler: {(data:NSData?,response: NSURLResponse?, error:NSError?) in
            self.processResponse(success,failure:failure,data:data,response:response,error:error);
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
    private func createRequest(url: String, method: HttpMethod, parameters: Dictionary<String,AnyObject>!,isDebug:Bool,isMulti:Bool? = nil) -> (request: NSMutableURLRequest, error: NSError?) {
        var urlVal = url
        //probably should change the 'http' to something more generic
        if !url.hasPrefix("http") && self.baseURL != nil {
            let split = url.hasPrefix("/") ? "" : "/"
            urlVal = "\(self.baseURL!)\(split)\(url)"
        }
    let result = self.requestSerializer.createRequest(NSURL(string: urlVal)!,
        method: method, parameters: parameters,isMulti : isMulti);
        
        result.request.setValue("",forHTTPHeaderField:HTTP_COMM_PROTOCOL);
        if isDebug {
            result.request.setValue("",forHTTPHeaderField:HTTP_COMM_PROTOCOL_DEBUG);
        }
        return result;
    }
    
    /**
        Creates a random string to use for the identifier of the background download/upload requests.
    
        - returns: Identifier String.
    */
    private func createBackgroundIdent() -> String {
        let letters = "abcdefghijklmnopqurstuvwxyz"
        var str = ""
        for var i = 0; i < 14; i++ {
            let start = Int(arc4random() % 14)
            str.append(letters[letters.startIndex.advancedBy(start)])
        }
        return "com.vluxe.swifthttp.request.\(str)"
    }
    
    /**
        Creates a random string to use for the identifier of the background download/upload requests.
        
        - parameter code: Code for error.
        
        - returns: An NSError.
    */
    private func createError(code: Int) -> NSError {
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
    private func cleanupBackground(identifier: String) {
        self.backgroundTaskMap.removeValueForKey(identifier)
    }
    
    //MARK: NSURLSession Delegate Methods
    
    /// Method for authentication challenge.
    public func URLSession(session: NSURLSession, task: NSURLSessionTask, didReceiveChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void) {
        if let a = auth {
            let cred = a(challenge)
            if let c = cred {
                completionHandler(.UseCredential, c)
            }
            completionHandler(.RejectProtectionSpace, nil)
            return
        }
        completionHandler(.PerformDefaultHandling, nil)
    }
    
    /// Called when the background task failed.
    public func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
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
    func URLSession(session: NSURLSession!, downloadTask: NSURLSessionDownloadTask!, didFinishDownloadingToURL location: NSURL!) {
        let blocks = self.backgroundTaskMap[session.configuration.identifier!]
        if blocks?.success != nil {
            let resp = HttpResponse()
            if let hresponse = downloadTask.response as? NSHTTPURLResponse {
                resp.headers = hresponse.allHeaderFields as? Dictionary<String,String>
                resp.mimeType = hresponse.MIMEType
                resp.suggestedFilename = hresponse.suggestedFilename
                resp.statusCode = hresponse.statusCode
                resp.URL = hresponse.URL
            }
            resp.responseObject = location
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
    func URLSession(session: NSURLSession!, downloadTask: NSURLSessionDownloadTask!, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
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
    public func URLSessionDidFinishEventsForBackgroundURLSession(session: NSURLSession) {
//        println("ok.");
    }
    
    //TODO: not implemented yet.
    /// not implemented yet. The background upload finished and reports the response data (if any).
    func URLSession(session: NSURLSession!, dataTask: NSURLSessionDataTask!, didReceiveData data: NSData!) {
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
    public func URLSession(session: NSURLSession, task: NSURLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        //add progress block logic
        if let progress = self.uploadProgress {
            progress(totalBytesSent,totalBytesExpectedToSend);
        }
    }
    
    //TODO: not implemented yet.
    /// not implemented yet.
    func URLSession(session: NSURLSession!, downloadTask: NSURLSessionDownloadTask!, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
//        println("ok.");
    }
    
    deinit{
        print("http task deinit.");
    }
}
