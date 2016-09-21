//
//  HTTPConnection.swift
//  LinComm
//
//  Created by lin on 5/21/16.
//  Copyright © 2016 lin. All rights reserved.
//

import Foundation
import LinUtil
import Dispatch
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



// Log levels: off, error, warn, info, verbose
// Other flags: trace
private let httpLogLevel:Int = 0;//HTTP_LOG_LEVEL_WARN; // | HTTP_LOG_FLAG_TRACE;

// Define chunk size used to read in data for responses
// This is how much data will be read from disk into RAM at a time
//#if TARGET_OS_IPHONE
//  private let READ_CHUNKSIZE  (1024 * 256)
//#else
//  private let READ_CHUNKSIZE  (1024 * 512)
//#endif
private var READ_CHUNKSIZE:UInt{
    if Platform.isSimulator {
        return 1024 * 256
    }else{
        return 1024 * 512
    }
}

// Define chunk size used to read in POST upload data
private var POST_CHUNKSIZE:UInt{
    if Platform.isSimulator {
        return 1024 * 256
    }else{
        return 1024 * 512
    }
}
//#if TARGET_OS_IPHONE


// Define the various timeouts (in seconds) for various parts of the HTTP process
private let TIMEOUT_READ_FIRST_HEADER_LINE       = 30.0
private let TIMEOUT_READ_SUBSEQUENT_HEADER_LINE  = 30.0
private let TIMEOUT_READ_BODY                    = -1.0
private let TIMEOUT_WRITE_HEAD                   = 30.0
private let TIMEOUT_WRITE_BODY                   = -1.0
private let TIMEOUT_WRITE_ERROR                  = 30.0
private let TIMEOUT_NONCE:Int64                        = 300

// Define the various limits
// MAX_HEADER_LINE_LENGTH: Max length (in bytes) of any single line in a header (including \r\n)
// MAX_HEADER_LINES      : Max number of lines in a single header (including first GET line)
private let MAX_HEADER_LINE_LENGTH:UInt  = 8190
private let MAX_HEADER_LINES:UInt         = 100
// MAX_CHUNK_LINE_LENGTH : For accepting chunked transfer uploads, max length of chunk size line (including \r\n)
private let MAX_CHUNK_LINE_LENGTH:UInt    = 200

// Define the various tags we'll use to differentiate what it is we're currently doing
private let HTTP_REQUEST_HEADER:Int                = 10
private let HTTP_REQUEST_BODY                  = 11
private let HTTP_REQUEST_CHUNK_SIZE:Int            = 12
private let HTTP_REQUEST_CHUNK_DATA:Int            = 13
private let HTTP_REQUEST_CHUNK_TRAILER:Int         = 14
private let HTTP_REQUEST_CHUNK_FOOTER          = 15
private let HTTP_PARTIAL_RESPONSE              = 20
private let HTTP_PARTIAL_RESPONSE_HEADER       = 21
private let HTTP_PARTIAL_RESPONSE_BODY         = 22
private let HTTP_CHUNKED_RESPONSE_HEADER       = 30
private let HTTP_CHUNKED_RESPONSE_BODY         = 31
private let HTTP_CHUNKED_RESPONSE_FOOTER       = 32
private let HTTP_PARTIAL_RANGE_RESPONSE_BODY   = 40
private let HTTP_PARTIAL_RANGES_RESPONSE_BODY  = 50
private let HTTP_RESPONSE                      = 90
private let HTTP_FINAL_RESPONSE                = 91

private let HTTPConnectionDidDieNotification = "HTTPConnectionDidDie";
// A quick note about the tags:
// 
// The HTTP_RESPONSE and HTTP_FINAL_RESPONSE are designated tags signalling that the response is completely sent.
// That is, in the onSocket:didWriteDataWithTag: method, if the tag is HTTP_RESPONSE or HTTP_FINAL_RESPONSE,
// it is assumed that the response is now completely sent.
// Use HTTP_RESPONSE if it's the end of a response, and you want to start reading more requests afterwards.
// Use HTTP_FINAL_RESPONSE if you wish to terminate the connection after sending the response.
// 
// If you are sending multiple data segments in a custom response, make sure that only the last segment has
// the HTTP_RESPONSE tag. For all other segments prior to the last segment use HTTP_PARTIAL_RESPONSE, or some other
// tag of your own invention.

//@interface HTTPConnection (PrivateAPI)
//- (void)startReadingRequest;
//- (void)sendResponseHeadersAndBody;
//@end


//MARK: -
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//@implementation HTTPConfig
open class HTTPConfig{
//@synthesize server;
//@synthesize documentRoot;
//@synthesize queue;
    open var server:HTTPServer;
    open var documentRoot:String;
    open var queue:DispatchQueue?;

//- (id)initWithServer:(HTTPServer *)aServer documentRoot:(NSString *)aDocumentRoot
//{
//    if ((self = [super init]))
//    {
//        server = aServer;
//        documentRoot = aDocumentRoot;
//    }
//    return self;
//    }
    public init(server aServer:HTTPServer,documentRoot aDocumentRoot:String){
        self.server = aServer;
        self.documentRoot = aDocumentRoot;
        
    }
    
//    - (id)initWithServer:(HTTPServer *)aServer documentRoot:(NSString *)aDocumentRoot queue:(dispatch_queue_t)q
//{
//    if ((self = [super init]))
//    {
    public init(server aServer:HTTPServer,documentRoot aDocumentRoot:String,queue q:DispatchQueue?){
        
        self.server = aServer;
        
//        documentRoot = [aDocumentRoot stringByStandardizingPath];
        self.documentRoot = (aDocumentRoot as NSString).standardizingPath;
        if self.documentRoot.hasSuffix("/"){
            documentRoot = documentRoot + "/";
        }
        self.queue = q;
//        if (q)
//        {
//            queue = q;
//            #if !OS_OBJECT_USE_OBJC
//                dispatch_retain(queue);
//            #endif
//        }
    }
//    return self;
//    }
    
//    - (void)dealloc
//        {
//            #if !OS_OBJECT_USE_OBJC
//                if (queue) dispatch_release(queue);
//            #endif
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//MARK: -
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//@implementation HTTPConnection
//
//private var recentNonceQueue:DispatchQueue = DispatchQueue(label: "HTTPConnection-Nonce", qos: []);
private var recentNonceQueue:DispatchQueue = DispatchQueue(label: "HTTPConnection-Nonce");

private var recentNonces = [String]();

open class HTTPConnection : NSObject{
    
    struct YRSignal{
        static var onceToken:Int = 0;
        static var df:DateFormatter!;
    }
    
fileprivate static var __once: () = {
            
            // Example: Sun, 06 Nov 1994 08:49:37 GMT
            
            YRSignal.df = DateFormatter();
            YRSignal.df.formatterBehavior = DateFormatter.Behavior.behavior10_4;//NSDateFormatterBehavior10_4
            YRSignal.df.timeZone = TimeZone(abbreviation:"GMT");
            YRSignal.df.dateFormat = "EEE, dd MMM y HH:mm:ss 'GMT'";
            YRSignal.df.locale = Locale(identifier:"en_US");
    //YRSignal.df.locale = Locale.
    
            // For some reason, using zzz in the format string produces GMT+00:00
        }()
/**
 * This method is automatically called (courtesy of Cocoa) before the first instantiation of this class.
 * We use it to initialize any static variables.
**/
//+ (void)initialize
//{
//	static dispatch_once_t onceToken;
//	dispatch_once(&onceToken, ^{
//		
//		// Initialize class variables
//		recentNonceQueue = dispatch_queue_create("HTTPConnection-Nonce", NULL);
//		recentNonces = [[NSMutableArray alloc] initWithCapacity:5];
//	});
//}

/**
 * Generates and returns an authentication nonce.
 * A nonce is a  server-specified string uniquely generated for each 401 response.
 * The default implementation uses a single nonce for each session.
**/
    fileprivate let _connectionQueue:DispatchQueue;
    fileprivate var _asyncSocket:GCDAsyncSocket?;
    fileprivate var _config:HTTPConfig;
    //
    fileprivate var _started:Bool = false;;
    //
//        HTTPMessage * request;
    fileprivate var _numHeaderLines:UInt = 0;
    //
    fileprivate var _sentResponseHeaders:Bool = false;
    //
    fileprivate var _nonce:String?;
    fileprivate var _lastNC:Int64 = 0;
    //
    fileprivate var _httpResponse:HTTPResponse?;
    //
    fileprivate var _ranges = [NSValue]();
    fileprivate var _ranges_headers = [Data]();
    fileprivate var _ranges_boundry:String?;
//    private let _rangeIndex:Int = 0;
    //
    fileprivate var _requestContentLength:UInt = 0;
    fileprivate var _requestContentLengthReceived:UInt64 = 0;
    fileprivate var _requestChunkSize:UInt64 = 0;
    fileprivate var _requestChunkSizeReceived:UInt64 = 0;
    //  
    fileprivate var _responseDataSizes = [NSNumber]();
    
    fileprivate var _rangeIndex = 0;
    
    open class func generateNonce()->String{
        // We use the Core Foundation UUID class to generate a nonce value for us
        // UUIDs (Universally Unique Identifiers) are 128-bit values guaranteed to be unique.
        let theUUID = CFUUIDCreate(nil);
        //	NSString *newNonce = (__bridge_transfer NSString *)CFUUIDCreateString(NULL, theUUID);
        //	CFRelease(theUUID);
        let newNonce = CFUUIDCreateString(nil, theUUID) as String;
            
        // We have to remember that the HTTP protocol is stateless.
        // Even though with version 1.1 persistent connections are the norm, they are not guaranteed.
        // Thus if we generate a nonce for this connection,
        // it should be honored for other connections in the near future.
        // 
        // In fact, this is absolutely necessary in order to support QuickTime.
        // When QuickTime makes it's initial connection, it will be unauthorized, and will receive a nonce.
        // It then disconnects, and creates a new connection with the nonce, and proper authentication.
        // If we don't honor the nonce for the second connection, QuickTime will repeat the process and never connect.

        recentNonceQueue.async(execute: {
            
//            [recentNonces addObject:newNonce];
            recentNonces.append(newNonce);
        });

//        double delayInSeconds = TIMEOUT_NONCE;
        let popTime = DispatchTime.now() + Double(TIMEOUT_NONCE * Int64(NSEC_PER_SEC)) / Double(NSEC_PER_SEC);
        recentNonceQueue.asyncAfter(deadline: popTime, execute: {
            
//            [recentNonces removeObject:newNonce];
            if let index = recentNonces.index(of: newNonce) {
                recentNonces.remove(at: index);
            }
        });

        return newNonce;
    }

    /**
     * Returns whether or not the given nonce is in the list of recently generated nonce's.
    **/
    open class func hasRecentNonce(_ recentNonce:String)->Bool
    {
        var result = false;
        
        recentNonceQueue.sync(execute: {
            
//            result = [recentNonces containsObject:recentNonce];
            result = recentNonces.contains(recentNonce)
        });
        
        return result;
    }

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //MARK:Init, Dealloc:
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//    @synthesize request;
    fileprivate var _request:HTTPMessage!
    open var request:HTTPMessage{
        return _request;
    }
    /**
     * Sole Constructor.
     * Associates this new HTTP connection with the given AsyncSocket.
     * This HTTP connection object will become the socket's delegate and take over responsibility for the socket.
    **/
//    - (id)initWithAsyncSocket:(GCDAsyncSocket *)newSocket configuration:(HTTPConfig *)aConfig
//    {
    required public init(socket newSocket:GCDAsyncSocket,configuration aConfig:HTTPConfig){
        
//        super.init();
//            HTTPLogTrace();
        
        if let queue = aConfig.queue{
            _connectionQueue = queue;
//            #if !OS_OBJECT_USE_OBJC
//            dispatch_retain(connectionQueue);
//            #endif
        }
        else
        {
            //_connectionQueue = DispatchQueue(label: "HTTPConnection", qos: []);
            _connectionQueue = DispatchQueue(label: "HTTPConnection");
        }
        
        // Take over ownership of the socket
        
        
        // Store configuration
        _config = aConfig;
        
        // Initialize lastNC (last nonce count).
        // Used with digest access authentication.
        // These must increment for each request from the client.
//        _lastNC = 0;
        
        // Create a new HTTP message
//        request = [[HTTPMessage alloc] initEmptyRequest];
        _request = HTTPMessage();
        
//        _numHeaderLines = 0;
        
//        responseDataSizes = [[NSMutableArray alloc] initWithCapacity:5];
//        }
//        return self;
        _asyncSocket = newSocket;
        //        [asyncSocket setDelegate:self delegateQueue:connectionQueue];
        super.init()
        _asyncSocket?.setDelegate(self, delegateQueue: _connectionQueue);
    }

    /**
     * Standard Deconstructor.
    **/
    deinit{
//        HTTPLogTrace();
        
//        #if !OS_OBJECT_USE_OBJC
//        dispatch_release(connectionQueue);
//        #endif
        
        _asyncSocket?.setDelegate(nil,delegateQueue:nil);
        _asyncSocket?.disconnect();
        
//        if ([httpResponse respondsToSelector:@selector(connectionDidClose)])
//        {
//            [httpResponse connectionDidClose];
//        }
        _httpResponse?.connectionDidClose?();
    }

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //MARK: Method Support
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    /**
     * Returns whether or not the server will accept messages of a given method
     * at a particular URI.
    **/
    open func supportsMethod(_ method:String,atPath path:String)->Bool{
//        HTTPLogTrace();
        
        // Override me to support methods such as POST.
        // 
        // Things you may want to consider:
        // - Does the given path represent a resource that is designed to accept this method?
        // - If accepting an upload, is the size of the data being uploaded too big?
        //   To do this you can check the requestContentLength variable.
        // 
        // For more information, you can always access the HTTPMessage request variable.
        // 
        // You should fall through with a call to [super supportsMethod:method atPath:path]
        // 
        // See also: expectsRequestBodyFromMethod:atPath:
        
        if method == "GET" {
            return true;
        }
        
        if method == "HEAD" {
            return true;
        }
        
        return false;
    }

    /**
     * Returns whether or not the server expects a body from the given method.
     * 
     * In other words, should the server expect a content-length header and associated body from this method.
     * This would be true in the case of a POST, where the client is sending data,
     * or for something like PUT where the client is supposed to be uploading a file.
    **/
    open func expectsRequestBodyFromMethod(_ method:String,atPath path:String)->Bool{
//        HTTPLogTrace();
        
        // Override me to add support for other methods that expect the client
        // to send a body along with the request header.
        // 
        // You should fall through with a call to [super expectsRequestBodyFromMethod:method atPath:path]
        // 
        // See also: supportsMethod:atPath:
        
        if method == "POST" {
            return true;
        }
        
        if method == "PUT" {
            return true;
        }
        
        return false;
    }

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //MARK: HTTPS
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    /**
     * Returns whether or not the server is configured to be a secure server.
     * In other words, all connections to this server are immediately secured, thus only secure connections are allowed.
     * This is the equivalent of having an https server, where it is assumed that all connections must be secure.
     * If this is the case, then unsecure connections will not be allowed on this server, and a separate unsecure server
     * would need to be run on a separate port in order to support unsecure connections.
     * 
     * Note: In order to support secure connections, the sslIdentityAndCertificates method must be implemented.
    **/
    open var isSecureServer:Bool{
//        HTTPLogTrace();
        
        // Override me to create an https server...
        
        return false;
    }

    /**
     * This method is expected to returns an array appropriate for use in kCFStreamSSLCertificates SSL Settings.
     * It should be an array of SecCertificateRefs except for the first element in the array, which is a SecIdentityRef.
    **/
    open var sslIdentityAndCertificates:[AnyObject]?{
//        HTTPLogTrace();
        
        // Override me to provide the proper required SSL identity.
        
        return nil;
    }

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //MARK: Password Protection
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    /**
     * Returns whether or not the requested resource is password protected.
     * In this generic implementation, nothing is password protected.
    **/
    open func isPasswordProtected(_ path:String)->Bool{
//        HTTPLogTrace();
        
        // Override me to provide password protection...
        // You can configure it for the entire server, or based on the current request
        
        return false;
    }

    /**
     * Returns whether or not the authentication challenge should use digest access authentication.
     * The alternative is basic authentication.
     * 
     * If at all possible, digest access authentication should be used because it's more secure.
     * Basic authentication sends passwords in the clear and should be avoided unless using SSL/TLS.
    **/
    open var useDigestAccessAuthentication:Bool{
//        HTTPLogTrace();
        
        // Override me to customize the authentication scheme
        // Make sure you understand the security risks of using the weaker basic authentication
        
        return true;
    }

    /**
     * Returns the authentication realm.
     * In this generic implmentation, a default realm is used for the entire server.
    **/
    open var realm:String{
//        HTTPLogTrace();
        
        // Override me to provide a custom realm...
        // You can configure it for the entire server, or based on the current request
        
        return "defaultRealm@host.com";
    }

    /**
     * Returns the password for the given username.
    **/
    open func passwordForUser(_ username:String)->String?{
//        HTTPLogTrace();
        
        // Override me to provide proper password authentication
        // You can configure a password for the entire server, or custom passwords for users and/or resources
        
        // Security Note:
        // A nil password means no access at all. (Such as for user doesn't exist)
        // An empty string password is allowed, and will be treated as any other password. (To support anonymous access)
        
        return nil;
    }

    /**
     * Returns whether or not the user is properly authenticated.
    **/
    open var isAuthenticated:Bool{
//        HTTPLogTrace();
        
        // Extract the authentication information from the Authorization header
        let auth = HTTPAuthenticationRequest(request:_request);
        
        if self.useDigestAccessAuthentication {
            // Digest Access Authentication (RFC 2617)
            
            if !auth.isDigest {
                // User didn't send proper digest access authentication credentials
                return false;
            }
            
            if auth.username == nil{
                // The client didn't provide a username
                // Most likely they didn't provide any authentication at all
                return false;
            }
            
            let password = self.passwordForUser(auth.username!);
            if password == nil{
                // No access allowed (username doesn't exist in system)
                return false;
            }
            
            let url = request.url!.relativeString;
            
            if url != auth.uri {
                // Requested URL and Authorization URI do not match
                // This could be a replay attack
                // IE - attacker provides same authentication information, but requests a different resource
                return false;
            }
            
            // The nonce the client provided will most commonly be stored in our local (cached) nonce variable
            if _nonce != auth.nonce {
                // The given nonce may be from another connection
                // We need to search our list of recent nonce strings that have been recently distributed
                if HTTPConnection.hasRecentNonce(auth.nonce!){
                    // Store nonce in local (cached) nonce variable to prevent array searches in the future
//                    nonce = [[auth nonce] copy];
                    _nonce = auth.nonce;
                    
                    // The client has switched to using a different nonce value
                    // This may happen if the client tries to get a file in a directory with different credentials.
                    // The previous credentials wouldn't work, and the client would receive a 401 error
                    // along with a new nonce value. The client then uses this new nonce value and requests the file again.
                    // Whatever the case may be, we need to reset lastNC, since that variable is on a per nonce basis.
                    _lastNC = 0;
                }
                else
                {
                    // We have no knowledge of ever distributing such a nonce.
                    // This could be a replay attack from a previous connection in the past.
                    return false;
                }
            }
            
            let authNC = Int64(strtol((auth.nc! as NSString).utf8String, nil, 16));
            
            if (authNC <= _lastNC)
            {
                // The nc value (nonce count) hasn't been incremented since the last request.
                // This could be a replay attack.
                return false;
            }
            _lastNC = authNC;
            
            let HA1str = "\(auth.username):\(auth.realm):\(password)";
            let HA2str = "\(_request.method!):\(auth.uri!)";
            
            
//            let HA1 = (HA1str.data(using: String.Encoding.utf8)! as Data).md5Digest().hexStringValue();// [[[HA1str dataUsingEncoding:NSUTF8StringEncoding] md5Digest] hexStringValue];
            
//            let HA2 = (HA2str.data(using: String.Encoding.utf8)! as Data).md5Digest().hexStringValue();
            
            let HA1 = HA1str.md5;
            let HA2 = HA2str.md5;
            
            let responseStr = "\(HA1):\(auth.nonce):\(auth.nc):\(auth.cnonce):\(auth.qop):\(HA2)";
            
//            let response = (responseStr.data(using: String.Encoding.utf8)! as NSData).md5Digest().hexStringValue();
            let response = responseStr.md5;
            
            return response == auth.response;
        }
        else
        {
            // Basic Authentication
            
            if !auth.isBasic{
                // User didn't send proper base authentication credentials
                return false;
            }
            
            // Decode the base 64 encoded credentials
            let base64Credentials = auth.base64Credentials;
            
//            let temp = (base64Credentials!.data(using: String.Encoding.utf8)! as Data).base64Decoded();
//            let temp = base64Credentials?.data(using: String.Encoding.utf8)?.
            let temp = Data.init(base64Encoded: base64Credentials ?? "");
            
            let credentials = String.init(data: temp!, encoding: String.Encoding.utf8);// [[NSString alloc] initWithData:temp encoding:NSUTF8StringEncoding];
            
            // The credentials should be of the form "username:password"
            // The username is not allowed to contain a colon
            
            let colonRange = credentials!.range(of: ":");
            
            if colonRange == nil {
                // Malformed credentials
                return false;
            }
            
            let credUsername = credentials!.substring(to: colonRange!.lowerBound);
            let credPassword = credentials!.substring(from: colonRange!.upperBound);
            
            let password = self.passwordForUser(credUsername);
            if (password == nil){
                // No access allowed (username doesn't exist in system)
                return false;
            }
            
            return password == credPassword;
        }
    }

    /**
     * Adds a digest access authentication challenge to the given response.
    **/
    open func addDigestAuthChallenge(_ response:HTTPMessage){
//        HTTPLogTrace();
    
        let authInfo = "Digest realm=\"\(self.realm)\", qop=\"auth\", nonce=\"\(HTTPConnection.generateNonce())\"";
//        NSString *authInfo = [NSString stringWithFormat:authFormat, [self realm], [[self class] generateNonce]];
        
        response.setHeaderField("WWW-Authenticate",value:authInfo);
    }

    /**
     * Adds a basic authentication challenge to the given response.
    **/
    open func addBasicAuthChallenge(_ response:HTTPMessage){
//        HTTPLogTrace();
        
        let authInfo = "Basic realm=\"%\(self.realm)\"";
//        NSString *authInfo = [NSString stringWithFormat:authFormat, [self realm]];
        
        response.setHeaderField("WWW-Authenticate",value:authInfo);
    }

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //MARK: Core
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    /**
     * Starting point for the HTTP connection after it has been fully initialized (including subclasses).
     * This method is called by the HTTP server.
    **/
    open func start(){
        _connectionQueue.async(execute: {
            
            if !self._started{
                self._started = true;
                self.startConnection();
            }
        });
    }

    /**
     * This method is called by the HTTPServer if it is asked to stop.
     * The server, in turn, invokes stop on each HTTPConnection instance.
    **/
    open func stop(){
        _connectionQueue.async(execute: {
            
            // Disconnect the socket.
            // The socketDidDisconnect delegate method will handle everything else.
            self._asyncSocket?.disconnect();
        });
    }

    /**
     * Starting point for the HTTP connection.
    **/
    open func startConnection(){
        // Override me to do any custom work before the connection starts.
        // 
        // Be sure to invoke [super startConnection] when you're done.
        
//        HTTPLogTrace();
        
        if self.isSecureServer{
            // We are configured to be an HTTPS server.
            // That is, we secure via SSL/TLS the connection prior to any communication.
            
            let certificates = self.sslIdentityAndCertificates;
            
            if certificates?.count > 0 {
                // All connections are assumed to be secure. Only secure connections are allowed on this server.
                var settings = [AnyHashable: Any]();//[NSMutableDictionary dictionaryWithCapacity:3];
                
                // Configure this connection as the server
//                [settings setObject:[NSNumber numberWithBool:YES]
//                             forKey:(NSString *)kCFStreamSSLIsServer];
                settings[kCFStreamSSLIsServer as AnyHashable] = true;
                
//                [settings setObject:certificates
//                             forKey:(NSString *)kCFStreamSSLCertificates];
                settings[kCFStreamSSLCertificates as AnyHashable] = certificates;
                // Configure this connection to use the highest possible SSL level
//                [settings setObject:(NSString *)kCFStreamSocketSecurityLevelNegotiatedSSL
//                             forKey:(NSString *)kCFStreamSSLLevel];
                settings[kCFStreamSSLLevel as AnyHashable] = kCFStreamSocketSecurityLevelNegotiatedSSL as String;
                
                _asyncSocket?.startTLS(settings);
            }
        }
        
        self.startReadingRequest();
    }

    /**
     * Starts reading an HTTP request.
    **/
    fileprivate func startReadingRequest(){
//        HTTPLogTrace();
        
//        [asyncSocket readDataToData:[GCDAsyncSocket CRLFData]
//                        withTimeout:TIMEOUT_READ_FIRST_HEADER_LINE
//                          maxLength:MAX_HEADER_LINE_LENGTH
//                                tag:HTTP_REQUEST_HEADER];
        _asyncSocket?.readData(to: GCDAsyncSocket.crlfData(), withTimeout: TIMEOUT_READ_FIRST_HEADER_LINE, maxLength:MAX_HEADER_LINE_LENGTH, tag:HTTP_REQUEST_HEADER);
        
//        _asyncSocket.readDataToData(<#T##data: NSData!##NSData!#>, withTimeout: <#T##NSTimeInterval#>, maxLength: <#T##UInt#>, tag: <#T##Int#>)
    }

    /**
     * Parses the given query string.
     * 
     * For example, if the query is "q=John%20Mayer%20Trio&num=50"
     * then this method would return the following dictionary:
     * { 
     *   q = "John Mayer Trio" 
     *   num = "50" 
     * }
    **/
    fileprivate func parseParams(_ query:String)->Dictionary<String,String?>{
        let components = query.components(separatedBy: "&");
        var result = Dictionary<String,String?>();
        
        for i in 0 ..< components.count {
            let component = components[i];
            if component.lengthOfBytes(using: String.Encoding.utf8) > 0 {
                let range = component.range(of: "=");
//                if range.location != NSNotFound { 
                if let range = range {
                    
                    let escapedKey = component.substring(to: range.lowerBound);
                    let escapedValue = component.substring(from: range.upperBound);
                    
                    if escapedKey.lengthOfBytes(using: String.Encoding.utf8) > 0 {
//                        CFStringRef k, v;
                        
                        let key = CFURLCreateStringByReplacingPercentEscapes(nil, escapedKey as CFString!, "" as CFString!);
                        let value = CFURLCreateStringByReplacingPercentEscapes(nil, escapedValue as CFString!, "" as CFString!);
                        
//                        NSString *key, *value;
                        
//                        key   = (__bridge_transfer NSString *)k;
//                        value = (__bridge_transfer NSString *)v;
                        
                        if let key = key{
                            if let value = value{
                                result[key as String] = value as String;
                            }else{
                                result[key as String] = nil;
                            }
                        }
                    }
                }
            }
        }
        
        return result;
    }

    /** 
     * Parses the query variables in the request URI. 
     * 
     * For example, if the request URI was "/search.html?q=John%20Mayer%20Trio&num=50" 
     * then this method would return the following dictionary: 
     * { 
     *   q = "John Mayer Trio" 
     *   num = "50" 
     * } 
    **/ 
    open func parseGetParams()->Dictionary<String,String?>?{
        if !request.isHeaderComplete {
            return nil;
        }
        
        var result:Dictionary<String,String?>?;
        
        let url = request.url;
        if let url = url{
            let query = url.query;
            if let query = query{
                result = self.parseParams(query);
            }
        }
        
        return result; 
    }

    /**
     * Attempts to parse the given range header into a series of sequential non-overlapping ranges.
     * If successfull, the variables 'ranges' and 'rangeIndex' will be updated, and YES will be returned.
     * Otherwise, NO is returned, and the range request should be ignored.
     **/
    fileprivate func parseRangeRequest(_ rangeHeader:String, withContentLength contentLength:UInt64)->Bool{
//        HTTPLogTrace();
        
        // Examples of byte-ranges-specifier values (assuming an entity-body of length 10000):
        // 
        // - The first 500 bytes (byte offsets 0-499, inclusive):  bytes=0-499
        // 
        // - The second 500 bytes (byte offsets 500-999, inclusive): bytes=500-999
        // 
        // - The final 500 bytes (byte offsets 9500-9999, inclusive): bytes=-500
        // 
        // - Or bytes=9500-
        // 
        // - The first and last bytes only (bytes 0 and 9999):  bytes=0-0,-1
        // 
        // - Several legal but not canonical specifications of the second 500 bytes (byte offsets 500-999, inclusive):
        // bytes=500-600,601-999
        // bytes=500-700,601-999
        // 
        
        let eqsignRange = rangeHeader.range(of: "=");
        
//        if eqsignRange.location == NSNotFound {
        if eqsignRange == nil {
            return false;
        }
        
//        NSUInteger tIndex = eqsignRange.location;
//        NSUInteger fIndex = eqsignRange.location + eqsignRange.length;
        
        var rangeType  = rangeHeader.substring(to: eqsignRange!.lowerBound);
        var rangeValue = rangeHeader.substring(from: eqsignRange!.upperBound)
        
//        CFStringTrimWhitespace((__bridge CFMutableStringRef)rangeType);
//        CFStringTrimWhitespace((__bridge CFMutableStringRef)rangeValue);
        rangeType = rangeType.trim();
        rangeValue = rangeValue.trim();
        
        if rangeType.caseInsensitiveCompare("bytes") != ComparisonResult.orderedSame {
            return false;
        }
        
        let rangeComponents = rangeValue.components(separatedBy: ",");
        
        if rangeComponents.count == 0 {
            return false;
        }
        
//        ranges = [[NSMutableArray alloc] initWithCapacity:[rangeComponents count]];
//        let ranges = [NSValue]();
        
//        let rangeIndex = 0;
        
        // Note: We store all range values in the form of DDRange structs, wrapped in NSValue objects.
        // Since DDRange consists of UInt64 values, the range extends up to 16 exabytes.
        
        for i in 0 ..< rangeComponents.count {
            let rangeComponent = rangeComponents[i];
            
            let dashRange = rangeComponent.range(of: "-");
            
            if (dashRange == nil)
            {
                // We're dealing with an individual byte number
                
                //UInt64 byteIndex;
                let byteIndex = UInt64((rangeComponent as NSString).longLongValue);
//                 if(![NSNumber parseString:rangeComponent intoUInt64:&byteIndex]) return NO;
                if byteIndex == 0 {
                    return false;
                }
                
//                if(byteIndex >= contentLength) return NO;
                if byteIndex >= contentLength {
                    return false;
                }
                
//                [ranges addObject:[NSValue valueWithDDRange:DDMakeRange(byteIndex, 1)]];
//                let v = DDMakeRange(byteIndex,1);
//                let v2 = NSValue(DDRange:v);
//                let v3 = NSValue.valueW
//                let r = CGRectMake(0, 0, 0, 0)
//                let m = UnsafePointer<DDRange>.alloc(1);
//                let v2 = NSValue(bytes: <#T##UnsafePointer<Void>#>, objCType: <#T##UnsafePointer<Int8>#>) //return [NSValue valueWithBytes:&range objCType:@encode(DDRange)];
                _ranges.append(NSValue(ddRange:DDMakeRange(byteIndex,1)));
            }
            else
            {
                // We're dealing with a range of bytes
                
//                tIndex = dashRange.location;
//                fIndex = dashRange.location + dashRange.length;
                
//                NSString *r1str = [rangeComponent substringToIndex:tIndex];
//                NSString *r2str = [rangeComponent substringFromIndex:fIndex];
                let r1str = rangeComponent.substring(to: dashRange!.lowerBound);
                let r2str = rangeComponent.substring(from: dashRange!.upperBound);
                
                
//                UInt64 r1, r2;
//                
//                BOOL hasR1 = [NSNumber parseString:r1str intoUInt64:&r1];
//                BOOL hasR2 = [NSNumber parseString:r2str intoUInt64:&r2];
                let r1 = UInt64((r1str as NSString).longLongValue);
                let r2 = UInt64((r2str as NSString).longLongValue);
                
                if r1 == 0{
                    // We're dealing with a "-[#]" range
                    // 
                    // r2 is the number of ending bytes to include in the range
                    
//                    if(!hasR2) return NO;
                    if r2 == 0 {
                        return false;
                    }
//                    if(r2 > contentLength) return NO;
                    if r2 > contentLength {
                        return false;
                    }
                    
                    let startIndex = contentLength - r2;
                    
//                    [ranges addObject:[NSValue valueWithDDRange:DDMakeRange(startIndex, r2)]];
                    _ranges.append(NSValue(ddRange:DDMakeRange(startIndex,r2)));
                }
                else if r2 == 0
                {
                    // We're dealing with a "[#]-" range
                    // 
                    // r1 is the starting index of the range, which goes all the way to the end
                    
//                    if(r1 >= contentLength) return NO;
                    if r1 >= contentLength {
                        return false;
                    }
                    
//                    [ranges addObject:[NSValue valueWithDDRange:DDMakeRange(r1, contentLength - r1)]];
                    _ranges.append(NSValue(ddRange:DDMakeRange(r1,contentLength-r2)));
                }
                else
                {
                    // We're dealing with a normal "[#]-[#]" range
                    // 
                    // Note: The range is inclusive. So 0-1 has a length of 2 bytes.
                    
//                    if(r1 > r2) return NO;
//                    if(r2 >= contentLength) return NO;
                    if r1 > r2 {
                        return false;
                    }
                    if r2 >= contentLength {
                        return false;
                    }
                    
//                    [ranges addObject:[NSValue valueWithDDRange:DDMakeRange(r1, r2 - r1 + 1)]];
                    _ranges.append(NSValue(ddRange:DDMakeRange(r1,r2-r1+1)));
                }
            }
        }
        
//        if([ranges count] == 0) return NO;?
        if _ranges.count == 0 {
            return false;
        }
        
        // Now make sure none of the ranges overlap
        
        for i in 0 ..< _ranges.count - 1 {
//            DDRange range1 = [[ranges objectAtIndex:i] ddrangeValue];
            let range1 = _ranges[i].ddrangeValue();
            
//            NSUInteger j;
            for j in i+1 ..< _ranges.count {
//                DDRange range2 = [[ranges objectAtIndex:j] ddrangeValue];
                let range2 = _ranges[j].ddrangeValue();
                
//                DDRange iRange = DDIntersectionRange(range1, range2);
                let iRange = DDIntersectionRange(range1,range2);
                
                if iRange.length != 0 {
                    return false;
                }
            }
        }
        
        // Sort the ranges
        
//        [ranges sortUsingSelector:@selector(ddrangeCompare:)];
        _ranges.sort(by: self.ddrangeCompare);
//        _ranges.sort(<#T##isOrderedBefore: (NSValue, NSValue) -> Bool##(NSValue, NSValue) -> Bool#>)
        
        return true;
    }
    
    fileprivate func ddrangeCompare(_ that:NSValue,other:NSValue)->Bool{
        return false;
        var r1 = that.ddrangeValue();
        var r2 = other.ddrangeValue();
//
        return DDRangeCompare(&r1, &r2) < 0;
    }

//    - (NSString *)requestURI
    open var requestURI:String?{
//        if(request == nil) return nil;
//        
//        return [[request url] relativeString];
//        if let request = _request {
            return _request.url!.relativeString;
//        }
//        return nil;
    }

    /**
     * This method is called after a full HTTP request has been received.
     * The current request is in the HTTPMessage request variable.
    **/
//    - (void)replyToHTTPRequest
    open func replyToHTTPRequest(){
//        HTTPLogTrace();
        
//        if (HTTP_LOG_VERBOSE)
//        {
//            NSData *tempData = [request messageData];
//            
//            NSString *tempStr = [[NSString alloc] initWithData:tempData encoding:NSUTF8StringEncoding];
//            HTTPLogVerbose(@"%@[%p]: Received HTTP request:\n%@", THIS_FILE, self, tempStr);
//        }
        
        // Check the HTTP version
        // We only support version 1.0 and 1.1
        
//        NSString *version = [request version];
        let version = _request.version!;
        if version != kCFHTTPVersion1_1 as String && version != kCFHTTPVersion1_0 as String{
//            [self handleVersionNotSupported:version];
            self.handleVersionNotSupported(version);
            return;
        }
        
        // Extract requested URI
        let uri = self.requestURI;
        
        // Check for WebSocket request
        if WebSocket.isWebSocketRequest(request){
//            HTTPLogVerbose(@"isWebSocket");
            
            let ws = self.webSocketForURI(uri!);
            
            if ws == nil{
                self.handleResourceNotFound();
            }
            else
            {
                ws!.start();
                
    			_config.server.addWebSocket(ws!);//需要加上
                
                // The WebSocket should now be the delegate of the underlying socket.
                // But gracefully handle the situation if it forgot.
//                if (_asyncSocket?.delegate())! == self{
                if self == (_asyncSocket!.delegate() as! HTTPConnection) {
//                    HTTPLogWarn(@"%@[%p]: WebSocket forgot to set itself as socket delegate", THIS_FILE, self);
                    
                    // Disconnect the socket.
                    // The socketDidDisconnect delegate method will handle everything else.
                    _asyncSocket?.disconnect();
                }
                else
                {
                    // The WebSocket is using the socket,
                    // so make sure we don't disconnect it in the dealloc method.
                    _asyncSocket = nil;
                    
                    self.die();
                    
                    // Note: There is a timing issue here that should be pointed out.
                    // 
                    // A bug that existed in previous versions happend like so:
                    // - We invoked [self die]
                    // - This caused us to get released, and our dealloc method to start executing
                    // - Meanwhile, AsyncSocket noticed a disconnect, and began to dispatch a socketDidDisconnect at us
                    // - The dealloc method finishes execution, and our instance gets freed
                    // - The socketDidDisconnect gets run, and a crash occurs
                    // 
                    // So the issue we want to avoid is releasing ourself when there is a possibility
                    // that AsyncSocket might be gearing up to queue a socketDidDisconnect for us.
                    // 
                    // In this particular situation notice that we invoke [asyncSocket delegate].
                    // This method is synchronous concerning AsyncSocket's internal socketQueue.
                    // Which means we can be sure, when it returns, that AsyncSocket has already
                    // queued any delegate methods for us if it was going to.
                    // And if the delegate methods are queued, then we've been properly retained.
                    // Meaning we won't get released / dealloc'd until the delegate method has finished executing.
                    // 
                    // In this rare situation, the die method will get invoked twice.
                }
            }
            
            return;
        }
        
        // Check Authentication (if needed)
        // If not properly authenticated for resource, issue Unauthorized response
        if self.isPasswordProtected(uri!) && !self.isAuthenticated {
            self.handleAuthenticationFailed();
            return;
        }
        
        // Extract the method
        let method = request.method!;
        
        // Note: We already checked to ensure the method was supported in onSocket:didReadData:withTag:
        
        // Respond properly to HTTP 'GET' and 'HEAD' commands
//        httpResponse = [self httpResponseForMethod:method URI:uri];
        _httpResponse = self.httpResponseForMethod(method,URI:uri!);
        
        if _httpResponse == nil {
            self.handleResourceNotFound();
            return;
        }
        
        self.sendResponseHeadersAndBody();
    }

    /**
     * Prepares a single-range response.
     * 
     * Note: The returned HTTPMessage is owned by the sender, who is responsible for releasing it.
    **/
//    - (HTTPMessage *)newUniRangeResponse:(UInt64)contentLength
    open func newUniRangeResponse(_ contentLength:UInt64)->HTTPMessage{
//        HTTPLogTrace();
        
        // Status Code 206 - Partial Content
        let response = HTTPMessage(statusCode:206,description:nil,version:kCFHTTPVersion1_1 as String);
        
        let range = _ranges[0].ddrangeValue();
        
        let contentLengthStr = "\(range.length)";
        response.setHeaderField("Content-Length",value:contentLengthStr);
        
        let rangeStr = "\(range.location)-\(DDMaxRange(range)-1)";
        let contentRangeStr = "bytes \(rangeStr)/\(contentLength)";
        response.setHeaderField("Content-Range",value:contentRangeStr);
        
        return response;
    }

    /**
     * Prepares a multi-range response.
     * 
     * Note: The returned HTTPMessage is owned by the sender, who is responsible for releasing it.
    **/
    open func newMultiRangeResponse(_ contentLength:UInt64)->HTTPMessage{
//        HTTPLogTrace();
        
        // Status Code 206 - Partial Content
        let response = HTTPMessage(statusCode: 206,description:nil,version:kCFHTTPVersion1_1 as String);
        
        // We have to send each range using multipart/byteranges
        // So each byterange has to be prefix'd and suffix'd with the boundry
        // Example:
        // 
        // HTTP/1.1 206 Partial Content
        // Content-Length: 220
        // Content-Type: multipart/byteranges; boundary=4554d24e986f76dd6
        // 
        // 
        // --4554d24e986f76dd6
        // Content-Range: bytes 0-25/4025
        // 
        // [...]
        // --4554d24e986f76dd6
        // Content-Range: bytes 3975-4024/4025
        // 
        // [...]
        // --4554d24e986f76dd6--
        
//        _ranges_headers = [[NSMutableArray alloc] initWithCapacity:[ranges count]];
        
        let theUUID = CFUUIDCreate(nil);
        _ranges_boundry = CFUUIDCreateString(nil, theUUID) as String;
//        CFRelease(theUUID);
        
        let startingBoundryStr = "\r\n--\(_ranges_boundry!)\r\n";
        let endingBoundryStr = "\r\n--\(_ranges_boundry)--\r\n";
        
        var actualContentLength:UInt64 = 0;
        
//        NSUInteger i;
        for i in 0 ..< _ranges.count {
            let range = _ranges[i].ddrangeValue();
            
            let rangeStr = "\(range.location)-\(DDMaxRange(range) - 1)";
            let contentRangeVal = "bytes \(rangeStr)/\(contentLength)";
            let contentRangeStr = "Content-Range: \(contentRangeVal)\r\n\r\n";
            
            let fullHeader = startingBoundryStr + contentRangeStr;
            let fullHeaderData = fullHeader.data(using: String.Encoding.utf8);
            
            _ranges_headers.append(fullHeaderData!);
            
            actualContentLength += UInt64(fullHeaderData!.count);
            actualContentLength += UInt64(range.length);
        }
        
        let endingBoundryData = endingBoundryStr.data(using: String.Encoding.utf8);
        
        actualContentLength += UInt64(endingBoundryData!.count);
        
        let contentLengthStr = "\(actualContentLength)";
        response.setHeaderField("Content-Length", value:contentLengthStr);
        
        let contentTypeStr = "multipart/byteranges; boundary=\(_ranges_boundry)";
        response.setHeaderField("Content-Type", value:contentTypeStr);
        
        return response;
    }

    /**
     * Returns the chunk size line that must precede each chunk of data when using chunked transfer encoding.
     * This consists of the size of the data, in hexadecimal, followed by a CRLF.
    **/
    open func chunkedTransferSizeLineForLength(_ length:UInt64)->Data
    {
        return "\(length)\r\n".data(using: String.Encoding.utf8)!// ?? NSData();
    }

    /**
     * Returns the data that signals the end of a chunked transfer.
    **/
    open func chunkedTransferFooter()->Data{
        // Each data chunk is preceded by a size line (in hex and including a CRLF),
        // followed by the data itself, followed by another CRLF.
        // After every data chunk has been sent, a zero size line is sent,
        // followed by optional footer (which are just more headers),
        // and followed by a CRLF on a line by itself.
        
        return "\r\n0\r\n\r\n".data(using: String.Encoding.utf8)!;
    }

    open func sendResponseHeadersAndBody(){
//        if ([httpResponse respondsToSelector:@selector(delayResponseHeaders)])
//        {
//            if ([httpResponse delayResponseHeaders])
//            {
//                return;
//            }
//        }
        if ((_httpResponse?.delayHeaders?()) != nil) {
            return;
        }
        
//        BOOL isChunked = NO;
//        
//        if ([httpResponse respondsToSelector:@selector(isChunked)])
//        {
//            isChunked = [httpResponse isChunked];
//        }
        let isChunked = _httpResponse?.isChunked?() ?? false;
        
        // If a response is "chunked", this simply means the HTTPResponse object
        // doesn't know the content-length in advance.
        
        var contentLength:UInt64 = 0;
        
        if !isChunked{
            contentLength = _httpResponse!.contentLength;
        }
        
        // Check for specific range request
        let rangeHeader = request.headerField("Range");
        
        var isRangeRequest = false;
        
        // If the response is "chunked" then we don't know the exact content-length.
        // This means we'll be unable to process any range requests.
        // This is because range requests might include a range like "give me the last 100 bytes"
        
        if !isChunked && rangeHeader != nil {
            if self.parseRangeRequest(rangeHeader!, withContentLength:contentLength){
                isRangeRequest = true;
            }
        }
        
        var response:HTTPMessage!;
        
        if !isRangeRequest{
            // Create response
            // Default status code: 200 - OK
//            let status = 200;
            
//            if ([httpResponse respondsToSelector:@selector(status)])
//            {
//                status = [httpResponse status];
//            }
            let status = _httpResponse?.status?() ?? 200;
            response = HTTPMessage(statusCode:status, description:nil, version:kCFHTTPVersion1_1 as String);
            
            if isChunked{
                response.setHeaderField("Transfer-Encoding", value:"chunked");
            }
            else
            {
                let contentLengthStr = "\(contentLength)";
                response.setHeaderField("Content-Length", value:contentLengthStr);
            }
        }
        else
        {
            if _ranges.count == 1{
                response = self.newUniRangeResponse(contentLength);
            }
            else{
                response = self.newMultiRangeResponse(contentLength);
            }
        }
        
        let isZeroLengthResponse = !isChunked && (contentLength == 0);
        
        // If they issue a 'HEAD' command, we don't have to include the file
        // If they issue a 'GET' command, we need to include the file
        
        if request.method! == "HEAD" || isZeroLengthResponse{
            let responseData = self.preprocessResponse(response);
            _asyncSocket?.write(responseData, withTimeout:TIMEOUT_WRITE_HEAD, tag:HTTP_RESPONSE);
            
            _sentResponseHeaders = true;
        }
        else
        {
            // Write the header response
            let responseData = self.preprocessResponse(response);
            _asyncSocket?.write(responseData, withTimeout:TIMEOUT_WRITE_HEAD, tag:HTTP_PARTIAL_RESPONSE_HEADER);
            
            _sentResponseHeaders = true;
            
            // Now we need to send the body of the response
            if !isRangeRequest{
                // Regular request
                let data = _httpResponse!.readData(ofLength: READ_CHUNKSIZE);
                
                if data?.count > 0{
                    _responseDataSizes.append(NSNumber(value:(data?.count)!));
                    
                    if isChunked {
                        let chunkSize = self.chunkedTransferSizeLineForLength(UInt64((data?.count)!));
                        _asyncSocket?.write(chunkSize, withTimeout:TIMEOUT_WRITE_HEAD, tag:HTTP_CHUNKED_RESPONSE_HEADER);
                        
                        _asyncSocket?.write(data, withTimeout:TIMEOUT_WRITE_BODY, tag:HTTP_CHUNKED_RESPONSE_BODY);
                        
                        if _httpResponse!.isDone {
                            let footer = self.chunkedTransferFooter();
                            _asyncSocket?.write(footer, withTimeout:TIMEOUT_WRITE_HEAD, tag:HTTP_RESPONSE);
                        }
                        else {
                            let footer = GCDAsyncSocket.crlfData();
                            _asyncSocket?.write(footer, withTimeout:TIMEOUT_WRITE_HEAD, tag:HTTP_CHUNKED_RESPONSE_FOOTER);
                        }
                    }
                    else {
                        let tag = _httpResponse!.isDone ? HTTP_RESPONSE : HTTP_PARTIAL_RESPONSE_BODY;
                        _asyncSocket?.write(data, withTimeout:TIMEOUT_WRITE_BODY, tag:tag);
                    }
                }
            }
            else {
                // Client specified a byte range in request
                
                if _ranges.count == 1 {
                    // Client is requesting a single range
                    let range = _ranges[0].ddrangeValue();
                    
                    _httpResponse?.offset = range.location;
                    
                    let bytesToRead = UInt(range.length) < READ_CHUNKSIZE ? UInt(range.length) : READ_CHUNKSIZE;
                    
                    let data = _httpResponse!.readData(ofLength: bytesToRead);
                    
                    if data?.count == 0 {
                        _responseDataSizes.append(NSNumber(value:(data?.count)!));
                        
                        let tag = Int((data?.count)!) == Int(range.length) ? HTTP_RESPONSE : HTTP_PARTIAL_RANGE_RESPONSE_BODY;
                        _asyncSocket?.write(data, withTimeout:TIMEOUT_WRITE_BODY, tag:tag);
                    }
                }
                else{
                    // Client is requesting multiple ranges
                    // We have to send each range using multipart/byteranges
                    
                    // Write range header
                    let rangeHeaderData = _ranges_headers[0];
                    _asyncSocket?.write(rangeHeaderData, withTimeout:TIMEOUT_WRITE_HEAD, tag:HTTP_PARTIAL_RESPONSE_HEADER);
                    
                    // Start writing range body
                    let range = _ranges[0].ddrangeValue();
                    
                    _httpResponse?.offset = range.location;
                    
                    let bytesToRead = UInt(range.length) < READ_CHUNKSIZE ? UInt(range.length) : READ_CHUNKSIZE;
                    
                    let data = _httpResponse!.readData(ofLength: bytesToRead);
                    
                    if data?.count > 0{
                        _responseDataSizes.append(NSNumber(value:(data?.count)!));
                        
                        _asyncSocket?.write(data, withTimeout:TIMEOUT_WRITE_BODY, tag:HTTP_PARTIAL_RANGES_RESPONSE_BODY);
                    }
                }
            }
        }
        
    }

    /**
     * Returns the number of bytes of the http response body that are sitting in asyncSocket's write queue.
     * 
     * We keep track of this information in order to keep our memory footprint low while
     * working with asynchronous HTTPResponse objects.
    **/
    open var writeQueueSize:UInt{
        var result:UInt = 0;
        
        for i in 0 ..< _responseDataSizes.count {
            result += _responseDataSizes[i].uintValue;
        }
        
        return result;
    }

    /**
     * Sends more data, if needed, without growing the write queue over its approximate size limit.
     * The last chunk of the response body will be sent with a tag of HTTP_RESPONSE.
     * 
     * This method should only be called for standard (non-range) responses.
    **/
    open func continueSendingStandardResponseBody(){
//        HTTPLogTrace();
        
        // This method is called when either asyncSocket has finished writing one of the response data chunks,
        // or when an asynchronous HTTPResponse object informs us that it has more available data for us to send.
        // In the case of the asynchronous HTTPResponse, we don't want to blindly grab the new data,
        // and shove it onto asyncSocket's write queue.
        // Doing so could negatively affect the memory footprint of the application.
        // Instead, we always ensure that we place no more than READ_CHUNKSIZE bytes onto the write queue.
        // 
        // Note that this does not affect the rate at which the HTTPResponse object may generate data.
        // The HTTPResponse is free to do as it pleases, and this is up to the application's developer.
        // If the memory footprint is a concern, the developer creating the custom HTTPResponse object may freely
        // use the calls to readDataOfLength as an indication to start generating more data.
        // This provides an easy way for the HTTPResponse object to throttle its data allocation in step with the rate
        // at which the socket is able to send it.
        
        let writeQueueSize = self.writeQueueSize;
        
        if writeQueueSize >= READ_CHUNKSIZE{
            return;
        }
        
        let available = READ_CHUNKSIZE - writeQueueSize;
        let data = _httpResponse!.readData(ofLength: available);
        
        if data?.count > 0 {
            _responseDataSizes.append(NSNumber(value:UInt((data?.count)!)));
            
//            BOOL isChunked = NO;
//            
//            if ([httpResponse respondsToSelector:@selector(isChunked)])
//            {
//                isChunked = [httpResponse isChunked];
//            }
            let isChunked = _httpResponse?.isChunked?() ?? false;
            
            if isChunked {
                let chunkSize = self.chunkedTransferSizeLineForLength(UInt64((data?.count)!));
                _asyncSocket?.write(chunkSize, withTimeout:TIMEOUT_WRITE_HEAD, tag:HTTP_CHUNKED_RESPONSE_HEADER);
                
                _asyncSocket?.write(data, withTimeout:TIMEOUT_WRITE_BODY, tag:HTTP_CHUNKED_RESPONSE_BODY);
                
                if _httpResponse!.isDone {
                    let footer = self.chunkedTransferFooter();
                    _asyncSocket?.write(footer, withTimeout:TIMEOUT_WRITE_HEAD, tag:HTTP_RESPONSE);
                }
                else{
                    let footer = GCDAsyncSocket.crlfData();
                    _asyncSocket?.write(footer, withTimeout:TIMEOUT_WRITE_HEAD, tag:HTTP_CHUNKED_RESPONSE_FOOTER);
                }
            }
            else{
                let tag = _httpResponse!.isDone ? HTTP_RESPONSE : HTTP_PARTIAL_RESPONSE_BODY;
                _asyncSocket?.write(data, withTimeout:TIMEOUT_WRITE_BODY, tag:tag);
            }
        }
    }

    /**
     * Sends more data, if needed, without growing the write queue over its approximate size limit.
     * The last chunk of the response body will be sent with a tag of HTTP_RESPONSE.
     * 
     * This method should only be called for single-range responses.
    **/
    open func continueSendingSingleRangeResponseBody(){
//        HTTPLogTrace();
        
        // This method is called when either asyncSocket has finished writing one of the response data chunks,
        // or when an asynchronous response informs us that is has more available data for us to send.
        // In the case of the asynchronous response, we don't want to blindly grab the new data,
        // and shove it onto asyncSocket's write queue.
        // Doing so could negatively affect the memory footprint of the application.
        // Instead, we always ensure that we place no more than READ_CHUNKSIZE bytes onto the write queue.
        // 
        // Note that this does not affect the rate at which the HTTPResponse object may generate data.
        // The HTTPResponse is free to do as it pleases, and this is up to the application's developer.
        // If the memory footprint is a concern, the developer creating the custom HTTPResponse object may freely
        // use the calls to readDataOfLength as an indication to start generating more data.
        // This provides an easy way for the HTTPResponse object to throttle its data allocation in step with the rate
        // at which the socket is able to send it.
        
        let writeQueueSize = self.writeQueueSize;
        
        if writeQueueSize >= READ_CHUNKSIZE {
            return;
        }
        
        let range = _ranges[0].ddrangeValue();
        
        let offset = _httpResponse!.offset;
        let bytesRead = offset - range.location;
        let bytesLeft = range.length - bytesRead;
        
        if bytesLeft > 0 {
            let available = READ_CHUNKSIZE - writeQueueSize;
            let bytesToRead = UInt(bytesLeft) < available ? UInt(bytesLeft) : available;
            
            let data = _httpResponse!.readData(ofLength: bytesToRead);
            
            if data?.count > 0 {
                _responseDataSizes.append(NSNumber(value:(data?.count)!));
                
                let tag = Int((data?.count)!) == Int(bytesLeft) ? HTTP_RESPONSE : HTTP_PARTIAL_RANGE_RESPONSE_BODY;
                _asyncSocket?.write(data, withTimeout:TIMEOUT_WRITE_BODY, tag:tag);
            }
        }
    }

    /**
     * Sends more data, if needed, without growing the write queue over its approximate size limit.
     * The last chunk of the response body will be sent with a tag of HTTP_RESPONSE.
     * 
     * This method should only be called for multi-range responses.
    **/
    open func continueSendingMultiRangeResponseBody(){
//        HTTPLogTrace();
        
        // This method is called when either asyncSocket has finished writing one of the response data chunks,
        // or when an asynchronous HTTPResponse object informs us that is has more available data for us to send.
        // In the case of the asynchronous HTTPResponse, we don't want to blindly grab the new data,
        // and shove it onto asyncSocket's write queue.
        // Doing so could negatively affect the memory footprint of the application.
        // Instead, we always ensure that we place no more than READ_CHUNKSIZE bytes onto the write queue.
        // 
        // Note that this does not affect the rate at which the HTTPResponse object may generate data.
        // The HTTPResponse is free to do as it pleases, and this is up to the application's developer.
        // If the memory footprint is a concern, the developer creating the custom HTTPResponse object may freely
        // use the calls to readDataOfLength as an indication to start generating more data.
        // This provides an easy way for the HTTPResponse object to throttle its data allocation in step with the rate
        // at which the socket is able to send it.
        
        let writeQueueSize = self.writeQueueSize;
        
        if writeQueueSize >= READ_CHUNKSIZE { return; }
        
        var range = _ranges[_rangeIndex].ddrangeValue();
        
        let offset = _httpResponse!.offset;
        let bytesRead = offset - range.location;
        let bytesLeft = range.length - bytesRead;
        
        if bytesLeft > 0{
            let available = READ_CHUNKSIZE - writeQueueSize;
            let bytesToRead = UInt(bytesLeft) < available ? UInt(bytesLeft) : available;
            
            let data = _httpResponse!.readData(ofLength: bytesToRead);
            
            if data?.count > 0 {
                _responseDataSizes.append(NSNumber(value:(data?.count)!));
                
                _asyncSocket?.write(data, withTimeout:TIMEOUT_WRITE_BODY, tag:HTTP_PARTIAL_RANGES_RESPONSE_BODY);
            }
        }
        else{
            _rangeIndex += 1
            if _rangeIndex < _ranges.count {
                // Write range header
                let rangeHeader = _ranges_headers[_rangeIndex];
                _asyncSocket?.write(rangeHeader, withTimeout:TIMEOUT_WRITE_HEAD, tag:HTTP_PARTIAL_RESPONSE_HEADER);
                
                // Start writing range body
                range = _ranges[_rangeIndex].ddrangeValue();
                
                _httpResponse?.offset = range.location;
                
                let available = READ_CHUNKSIZE - writeQueueSize;
                let bytesToRead = UInt(range.length) < available ? UInt(range.length) : available;
                
                let data = _httpResponse!.readData(ofLength: bytesToRead);
                
                if data?.count > 0 {
                    _responseDataSizes.append(NSNumber(value:(data?.count)!));
                    
                    _asyncSocket?.write(data, withTimeout:TIMEOUT_WRITE_BODY, tag:HTTP_PARTIAL_RANGES_RESPONSE_BODY);
                }
            }
            else{
                // We're not done yet - we still have to send the closing boundry tag
                let endingBoundryStr = "\r\n--\(_ranges_boundry)--\r\n";
                let endingBoundryData = endingBoundryStr.data(using: String.Encoding.utf8);
                
                _asyncSocket?.write(endingBoundryData, withTimeout:TIMEOUT_WRITE_HEAD, tag:HTTP_RESPONSE);
            }
        }
    }

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //MARK:Responses
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    /**
     * Returns an array of possible index pages.
     * For example: {"index.html", "index.htm"}
    **/
    open func directoryIndexFileNames()->[String]{
//        HTTPLogTrace();
        
        // Override me to support other index pages.
        
        return ["index.html", "index.htm"];
    }

    open func filePathForURI(_ path:String)->String {
        return self.filePathForURI(path, allowDirectory:false);
    }

    /**
     * Converts relative URI path into full file-system path.
    **/
    open func filePathForURI(_ path:String, allowDirectory:Bool)->String!{
//        HTTPLogTrace();
        
        // Override me to perform custom path mapping.
        // For example you may want to use a default file other than index.html, or perhaps support multiple types.
        
        var documentRoot = _config.documentRoot;
        
        // Part 0: Validate document root setting.
        // 
        // If there is no configured documentRoot,
        // then it makes no sense to try to return anything.
        
//        if (documentRoot == nil)
//        {
////            HTTPLogWarn(@"%@[%p]: No configured document root", THIS_FILE, self);
//            return nil;
//        }
        
        // Part 1: Strip parameters from the url
        // 
        // E.g.: /page.html?q=22&var=abc -> /page.html
        
        let docRoot = URL(fileURLWithPath: documentRoot, isDirectory:true);
//        if docRoot == nil{
////            HTTPLogWarn(@"%@[%p]: Document root is invalid file path", THIS_FILE, self);
//            return nil;
//        }
        
        let relativePath = URL(string:path, relativeTo:docRoot)!.relativePath;
        
        // Part 2: Append relative path to document root (base path)
        // 
        // E.g.: relativePath="/images/icon.png"
        //       documentRoot="/Users/robbie/Sites"
        //           fullPath="/Users/robbie/Sites/images/icon.png"
        // 
        // We also standardize the path.
        // 
        // E.g.: "Users/robbie/Sites/images/../index.html" -> "/Users/robbie/Sites/index.html"
        
        var fullPath = ((documentRoot as NSString).appendingPathComponent(relativePath) as NSString).standardizingPath;
        
        if relativePath ==  "/" {
            fullPath = fullPath + "/";
        }
        
        // Part 3: Prevent serving files outside the document root.
        // 
        // Sneaky requests may include ".." in the path.
        // 
        // E.g.: relativePath="../Documents/TopSecret.doc"
        //       documentRoot="/Users/robbie/Sites"
        //           fullPath="/Users/robbie/Documents/TopSecret.doc"
        // 
        // E.g.: relativePath="../Sites_Secret/TopSecret.doc"
        //       documentRoot="/Users/robbie/Sites"
        //           fullPath="/Users/robbie/Sites_Secret/TopSecret"
        
        if documentRoot.hasSuffix("/") {
            documentRoot = documentRoot + "/";
        }
        
        if !fullPath.hasPrefix(documentRoot) {
//            HTTPLogWarn(@"%@[%p]: Request for file outside document root", THIS_FILE, self);
            return nil;
        }
        
        // Part 4: Search for index page if path is pointing to a directory
        if !allowDirectory {
//            var isDir = false;
            let isDir = UnsafeMutablePointer<ObjCBool>.allocate(capacity: 1);
            
            if FileManager.default.fileExists(atPath: fullPath, isDirectory: isDir) && isDir.pointee.boolValue {
                let indexFileNames = self.directoryIndexFileNames();

                for  indexFileName in indexFileNames {
                    let indexFilePath = (fullPath as NSString).appendingPathComponent(indexFileName);

                    if FileManager.default.fileExists(atPath: indexFilePath, isDirectory:isDir) && !isDir.pointee.boolValue {
                        return indexFilePath;
                    }
                }

                // No matching index files found in directory
                return nil;
            }
        }

        return fullPath;
    }

    /**
     * This method is called to get a response for a request.
     * You may return any object that adopts the HTTPResponse protocol.
     * The HTTPServer comes with two such classes: HTTPFileResponse and HTTPDataResponse.
     * HTTPFileResponse is a wrapper for an NSFileHandle object, and is the preferred way to send a file response.
     * HTTPDataResponse is a wrapper for an NSData object, and may be used to send a custom response.
    **/
    public func httpResponseForMethod(_ method:String, URI path:String)->HTTPResponse?{
//        HTTPLogTrace();
        
        // Override me to provide custom responses.
        
        let filePath = self.filePathForURI(path, allowDirectory:false);
        
        //let isDir = UnsafeMutablePointer<ObjCBool>(allocatingCapacity: 1);
        let isDir = UnsafeMutablePointer<ObjCBool>.allocate(capacity: 1);
        
        if filePath != nil && FileManager.default.fileExists(atPath: filePath!, isDirectory:isDir) && !(isDir.pointee.boolValue){
            return HTTPFileResponse(filePath:filePath!, forConnection:self);
        
            // Use me instead for asynchronous file IO.
            // Generally better for larger files.
            
        //	return [[[HTTPAsyncFileResponse alloc] initWithFilePath:filePath forConnection:self] autorelease];
        }
        
        return nil;
    }

    public func webSocketForURI(_ path:String)->WebSocket?{
//        HTTPLogTrace();
        
        // Override me to provide custom WebSocket responses.
        // To do so, simply override the base WebSocket implementation, and add your custom functionality.
        // Then return an instance of your custom WebSocket here.
        // 
        // For example:
        // 
        // if ([path isEqualToString:@"/myAwesomeWebSocketStream"])
        // {
        //     return [[[MyWebSocket alloc] initWithRequest:request socket:asyncSocket] autorelease];
        // }
        // 
        // return [super webSocketForURI:path];
        
        return nil;
    }

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //MARK: Uploads
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    /**
     * This method is called after receiving all HTTP headers, but before reading any of the request body.
    **/
    public func prepareForBodyWithSize(_ contentLength:UInt64)
    {
        // Override me to allocate buffers, file handles, etc.
    }

    /**
     * This method is called to handle data read from a POST / PUT.
     * The given data is part of the request body.
    **/
    public func processBodyData(_ postDataChunk:Data){
        // Override me to do something useful with a POST / PUT.
        // If the post is small, such as a simple form, you may want to simply append the data to the request.
        // If the post is big, such as a file upload, you may want to store the file to disk.
        // 
        // Remember: In order to support LARGE POST uploads, the data is read in chunks.
        // This prevents a 50 MB upload from being stored in RAM.
        // The size of the chunks are limited by the POST_CHUNKSIZE definition.
        // Therefore, this method may be called multiple times for the same POST request.
    }

    /**
     * This method is called after the request body has been fully read but before the HTTP request is processed.
    **/
    public func finishBody(){
        // Override me to perform any final operations on an upload.
        // For example, if you were saving the upload to disk this would be
        // the hook to flush any pending data to disk and maybe close the file.
    }

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //MARK: Errors
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    /**
     * Called if the HTML version is other than what is supported
    **/
    public func handleVersionNotSupported(_ version:String){
        // Override me for custom error handling of unsupported http version responses
        // If you simply want to add a few extra header fields, see the preprocessErrorResponse: method.
        // You can also use preprocessErrorResponse: to add an optional HTML body.
        
//        HTTPLogWarn(@"HTTP Server: Error 505 - Version Not Supported: %@ (%@)", version, [self requestURI]);
        
        let response = HTTPMessage(statusCode:505, description:nil, version:kCFHTTPVersion1_1 as String);
        response.setHeaderField("Content-Length", value:"0");
        
        let responseData = self.preprocessErrorResponse(response);
        _asyncSocket?.write(responseData, withTimeout:TIMEOUT_WRITE_ERROR, tag:HTTP_RESPONSE);
        
    }

    /**
     * Called if the authentication information was required and absent, or if authentication failed.
    **/
    public func handleAuthenticationFailed(){
        // Override me for custom handling of authentication challenges
        // If you simply want to add a few extra header fields, see the preprocessErrorResponse: method.
        // You can also use preprocessErrorResponse: to add an optional HTML body.
        
//        HTTPLogInfo(@"HTTP Server: Error 401 - Unauthorized (%@)", [self requestURI]);
        
        // Status Code 401 - Unauthorized
        let response = HTTPMessage(statusCode:401, description:nil, version:kCFHTTPVersion1_1 as String);
        response.setHeaderField("Content-Length", value:"0");
        
        if self.useDigestAccessAuthentication {
            self.addDigestAuthChallenge(response);
        }
        else{
            self.addBasicAuthChallenge(response);
        }
        
        let responseData = self.preprocessErrorResponse(response);
        _asyncSocket?.write(responseData, withTimeout:TIMEOUT_WRITE_ERROR, tag:HTTP_RESPONSE);
        
    }

    /**
     * Called if we receive some sort of malformed HTTP request.
     * The data parameter is the invalid HTTP header line, including CRLF, as read from GCDAsyncSocket.
     * The data parameter may also be nil if the request as a whole was invalid, such as a POST with no Content-Length.
    **/
    public func handleInvalidRequest(_ data:Data?){
        // Override me for custom error handling of invalid HTTP requests
        // If you simply want to add a few extra header fields, see the preprocessErrorResponse: method.
        // You can also use preprocessErrorResponse: to add an optional HTML body.
        
//        HTTPLogWarn(@"HTTP Server: Error 400 - Bad Request (%@)", [self requestURI]);
        
        // Status Code 400 - Bad Request
        let response = HTTPMessage(statusCode:400, description:nil, version:kCFHTTPVersion1_1 as String);
        response.setHeaderField("Content-Length", value:"0");
        response.setHeaderField("Connection", value:"close");
        
        let responseData = self.preprocessErrorResponse(response);
        _asyncSocket?.write(responseData, withTimeout:TIMEOUT_WRITE_ERROR, tag:HTTP_FINAL_RESPONSE);
        
        
        // Note: We used the HTTP_FINAL_RESPONSE tag to disconnect after the response is sent.
        // We do this because we couldn't parse the request,
        // so we won't be able to recover and move on to another request afterwards.
        // In other words, we wouldn't know where the first request ends and the second request begins.
    }

    /**
     * Called if we receive a HTTP request with a method other than GET or HEAD.
    **/
    public func handleUnknownMethod(_ method:String){
        // Override me for custom error handling of 405 method not allowed responses.
        // If you simply want to add a few extra header fields, see the preprocessErrorResponse: method.
        // You can also use preprocessErrorResponse: to add an optional HTML body.
        // 
        // See also: supportsMethod:atPath:
        
//        HTTPLogWarn(@"HTTP Server: Error 405 - Method Not Allowed: %@ (%@)", method, [self requestURI]);
        
        // Status code 405 - Method Not Allowed
        let response = HTTPMessage(statusCode:405, description:nil, version:kCFHTTPVersion1_1 as String);
        response.setHeaderField("Content-Length", value:"0");
        response.setHeaderField("Connection", value:"close");
        
        let responseData = self.preprocessErrorResponse(response);
        _asyncSocket?.write(responseData, withTimeout:TIMEOUT_WRITE_ERROR, tag:HTTP_FINAL_RESPONSE);
        
        
        // Note: We used the HTTP_FINAL_RESPONSE tag to disconnect after the response is sent.
        // We do this because the method may include an http body.
        // Since we can't be sure, we should close the connection.
    }

    /**
     * Called if we're unable to find the requested resource.
    **/
    public func handleResourceNotFound(){
        // Override me for custom error handling of 404 not found responses
        // If you simply want to add a few extra header fields, see the preprocessErrorResponse: method.
        // You can also use preprocessErrorResponse: to add an optional HTML body.
        
//        HTTPLogInfo(@"HTTP Server: Error 404 - Not Found (%@)", [self requestURI]);
        
        // Status Code 404 - Not Found
        let response = HTTPMessage(statusCode:404, description:nil, version:kCFHTTPVersion1_1 as String);
        response.setHeaderField("Content-Length", value:"0");
        
        let responseData = self.preprocessErrorResponse(response);
        _asyncSocket?.write(responseData, withTimeout:TIMEOUT_WRITE_ERROR, tag:HTTP_RESPONSE);
        
    }

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //MARK: Headers
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    /**
     * Gets the current date and time, formatted properly (according to RFC) for insertion into an HTTP header.
    **/
    public func dateAsString(_ date:Date)->String{
        // From Apple's Documentation (Data Formatting Guide -> Date Formatters -> Cache Formatters for Efficiency):
        // 
        // "Creating a date formatter is not a cheap operation. If you are likely to use a formatter frequently,
        // it is typically more efficient to cache a single instance than to create and dispose of multiple instances.
        // One approach is to use a static variable."
        // 
        // This was discovered to be true in massive form via issue #46:
        // 
        // "Was doing some performance benchmarking using instruments and httperf. Using this single optimization
        // I got a 26% speed improvement - from 1000req/sec to 3800req/sec. Not insignificant.
        // The culprit? Why, NSDateFormatter, of course!"
        // 
        // Thus, we are using a static NSDateFormatter here.
        
        
        
        _ = HTTPConnection.__once;
        
        return YRSignal.df.string(from: date);
    }

    /**
     * This method is called immediately prior to sending the response headers.
     * This method adds standard header fields, and then converts the response to an NSData object.
    **/
    public func preprocessResponse(_ response:HTTPMessage)->Data{
//        HTTPLogTrace();
        
        // Override me to customize the response headers
        // You'll likely want to add your own custom headers, and then return [super preprocessResponse:response]
        
        // Add standard headers
        let now = self.dateAsString(Date());
        response.setHeaderField("Date", value:now);
        
        // Add server capability headers
        response.setHeaderField("Accept-Ranges", value:"bytes");
        
        // Add optional response headers
//        if _httpResponse.respondsToSelector(#selector(httpHeaders))
        if _httpResponse?.httpHeaders != nil {
            let responseHeaders = _httpResponse!.httpHeaders!();
            
//            NSEnumerator *keyEnumerator = [responseHeaders keyEnumerator];
//            NSString *key;
//            
//            while ((key = [keyEnumerator nextObject]))
//            {
//                NSString *value = [responseHeaders objectForKey:key];
//                
//                [response setHeaderField:key value:value];
//            }
            for (key,value) in responseHeaders! {
                response.setHeaderField(key as! String, value: value as! String);
            }
        }
        
        return response.messageData! as Data;
    }

    /**
     * This method is called immediately prior to sending the response headers (for an error).
     * This method adds standard header fields, and then converts the response to an NSData object.
    **/
    public func preprocessErrorResponse(_ response:HTTPMessage )->Data{
//        HTTPLogTrace();
        
        // Override me to customize the error response headers
        // You'll likely want to add your own custom headers, and then return [super preprocessErrorResponse:response]
        // 
        // Notes:
        // You can use [response statusCode] to get the type of error.
        // You can use [response setBody:data] to add an optional HTML body.
        // If you add a body, don't forget to update the Content-Length.
        // 
        // if ([response statusCode] == 404)
        // {
        //     NSString *msg = @"<html><body>Error 404 - Not Found</body></html>";
        //     NSData *msgData = [msg dataUsingEncoding:NSUTF8StringEncoding];
        //     
        //     [response setBody:msgData];
        //     
        //     NSString *contentLengthStr = [NSString stringWithFormat:@"%lu", (unsigned long)[msgData length]];
        //     [response setHeaderField:@"Content-Length" value:contentLengthStr];
        // }
        
        // Add standard headers
        let now = self.dateAsString(Date());
        response.setHeaderField("Date", value:now);
        
        // Add server capability headers
        response.setHeaderField("Accept-Ranges", value:"bytes");
        
        // Add optional response headers
//        if ([httpResponse respondsToSelector:@selector(httpHeaders)])
//        {
//            NSDictionary *responseHeaders = [httpResponse httpHeaders];
//            
//            NSEnumerator *keyEnumerator = [responseHeaders keyEnumerator];
//            NSString *key;
//            
//            while((key = [keyEnumerator nextObject]))
//            {
//                NSString *value = [responseHeaders objectForKey:key];
//                
//                [response setHeaderField:key value:value];
//            }
//        }
        if _httpResponse?.httpHeaders != nil {
            let responseHeaders = _httpResponse!.httpHeaders!();
            
            //            NSEnumerator *keyEnumerator = [responseHeaders keyEnumerator];
            //            NSString *key;
            //
            //            while ((key = [keyEnumerator nextObject]))
            //            {
            //                NSString *value = [responseHeaders objectForKey:key];
            //
            //                [response setHeaderField:key value:value];
            //            }
            for (key,value) in responseHeaders! {
                response.setHeaderField(key as! String, value: value as! String);
            }
        }
        
        return response.messageData! as Data;
    }

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //MARK: GCDAsyncSocket Delegate
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    /**
     * This method is called after the socket has successfully read data from the stream.
     * Remember that this method will only be called after the socket reaches a CRLF, or after it's read the proper length.
    **/
    public func socket(_ sock:GCDAsyncSocket, didReadData data:Data, withTag tag:Int64){
        if tag == Int64(HTTP_REQUEST_HEADER) {
            // Append the header line to the http message
            let result = request.appendData(data);
            if !result{
//                HTTPLogWarn(@"%@[%p]: Malformed request", THIS_FILE, self);
                
                self.handleInvalidRequest(data);
            }
            else if !request.isHeaderComplete {
                // We don't have a complete header yet
                // That is, we haven't yet received a CRLF on a line by itself, indicating the end of the header
                _numHeaderLines += 1
                if _numHeaderLines > MAX_HEADER_LINES {
                    // Reached the maximum amount of header lines in a single HTTP request
                    // This could be an attempted DOS attack
                    _asyncSocket?.disconnect();
                    
                    // Explictly return to ensure we don't do anything after the socket disconnect
                    return;
                }
                else{
                    _asyncSocket?.readData(to: GCDAsyncSocket.crlfData(),
                                    withTimeout:TIMEOUT_READ_SUBSEQUENT_HEADER_LINE,
                                      maxLength:MAX_HEADER_LINE_LENGTH,
                                            tag:HTTP_REQUEST_HEADER);
                }
            }
            else
            {
                // We have an entire HTTP request header from the client
                
                // Extract the method (such as GET, HEAD, POST, etc)
                let method = request.method!;
                
                // Extract the uri (such as "/index.html")
                let uri = self.requestURI;
                
                // Check for a Transfer-Encoding field
                let transferEncoding = request.headerField("Transfer-Encoding");
          
                // Check for a Content-Length field
                let contentLength = request.headerField("Content-Length");
                
                // Content-Length MUST be present for upload methods (such as POST or PUT)
                // and MUST NOT be present for other methods.
                let expectsUpload = self.expectsRequestBodyFromMethod(method, atPath:uri!);
                
                if expectsUpload {
                    if transferEncoding != nil && transferEncoding!.caseInsensitiveCompare("Chunked") != ComparisonResult.orderedSame {
                        _requestContentLength = UInt.max;//-1;
                    }
                    else{
                        if (contentLength == nil){
//                            HTTPLogWarn(@"%@[%p]: Method expects request body, but had no specified Content-Length",
//                                        THIS_FILE, self);
                            
                            self.handleInvalidRequest(nil);
                            return;
                        }
                        _requestContentLength = UInt((contentLength! as NSString).longLongValue);
                        //if (![NSNumber parseString:(NSString *)contentLength intoUInt64:&requestContentLength])
                        if _requestContentLength == 0 {
//                            HTTPLogWarn(@"%@[%p]: Unable to parse Content-Length header into a valid number",
//                                        THIS_FILE, self);
                            
                            self.handleInvalidRequest(nil);
                            return;
                        }
                    }
                }
                else{
                    if contentLength != nil {
                        // Received Content-Length header for method not expecting an upload.
                        // This better be zero...
                        
//                        if (![NSNumber parseString:(NSString *)contentLength intoUInt64:&requestContentLength])
                        _requestContentLength = UInt((contentLength! as NSString).longLongValue);
                        if _requestContentLength == 0 {
//                            HTTPLogWarn(@"%@[%p]: Unable to parse Content-Length header into a valid number",
//                                        THIS_FILE, self);
                            
                            self.handleInvalidRequest(nil);
                            return;
                        }
                        
                        if _requestContentLength > 0 {
//                            HTTPLogWarn(@"%@[%p]: Method not expecting request body had non-zero Content-Length",
//                                        THIS_FILE, self);
                            
                            self.handleInvalidRequest(nil);
                            return;
                        }
                    }
                    
                    _requestContentLength = 0;
                    _requestContentLengthReceived = 0;
                }
                
                // Check to make sure the given method is supported
                if !self.supportsMethod(method, atPath:uri!) {
                    // The method is unsupported - either in general, or for this specific request
                    // Send a 405 - Method not allowed response
                    self.handleUnknownMethod(method);
                    return;
                }
                
                if expectsUpload {
                    // Reset the total amount of data received for the upload
                    _requestContentLengthReceived = 0;
                    
                    // Prepare for the upload
                    self.prepareForBodyWithSize(UInt64(_requestContentLength));
                    
                    if _requestContentLength > 0 {
                        // Start reading the request body
                        if _requestContentLength == UInt.max {//-1 {
                            // Chunked transfer
                            
                            _asyncSocket?.readData(to: GCDAsyncSocket.crlfData(),
                                            withTimeout:TIMEOUT_READ_BODY,
                                              maxLength:MAX_CHUNK_LINE_LENGTH,
                                                    tag:HTTP_REQUEST_CHUNK_SIZE);
                        }
                        else
                        {
                            var bytesToRead:UInt = 0;
                            if _requestContentLength < POST_CHUNKSIZE{
                                bytesToRead = _requestContentLength;
                            }else{
                                bytesToRead = POST_CHUNKSIZE;
                            }
                            _asyncSocket?.readData(toLength: bytesToRead,
                                              withTimeout:TIMEOUT_READ_BODY,
                                                      tag:HTTP_REQUEST_BODY);
                        }
                    }
                    else
                    {
                        // Empty upload
                        self.finishBody();
                        self.replyToHTTPRequest();
                    }
                }
                else
                {
                    // Now we need to reply to the request
                    self.replyToHTTPRequest();
                }
            }
        }
        else
        {
            var doneReadingRequest = false;
            
            // A chunked message body contains a series of chunks,
            // followed by a line with "0" (zero),
            // followed by optional footers (just like headers),
            // and a blank line.
            // 
            // Each chunk consists of two parts:
            // 
            // 1. A line with the size of the chunk data, in hex,
            //    possibly followed by a semicolon and extra parameters you can ignore (none are currently standard),
            //    and ending with CRLF.
            // 2. The data itself, followed by CRLF.
            // 
            // Part 1 is represented by HTTP_REQUEST_CHUNK_SIZE
            // Part 2 is represented by HTTP_REQUEST_CHUNK_DATA and HTTP_REQUEST_CHUNK_TRAILER
            // where the trailer is the CRLF that follows the data.
            // 
            // The optional footers and blank line are represented by HTTP_REQUEST_CHUNK_FOOTER.
            
            if tag == Int64(HTTP_REQUEST_CHUNK_SIZE) {
                // We have just read in a line with the size of the chunk data, in hex, 
                // possibly followed by a semicolon and extra parameters that can be ignored,
                // and ending with CRLF.
                
                let sizeLine = NSString(data:data, encoding:String.Encoding.utf8.rawValue);
                
//                errno = 0;  // Reset errno before calling strtoull() to ensure it is always zero on success
                _requestChunkSize = strtoull(sizeLine!.utf8String, nil, 16);
                _requestChunkSizeReceived = 0;
                
                if errno != 0 {
//                    HTTPLogWarn(@"%@[%p]: Method expects chunk size, but received something else", THIS_FILE, self);
                    
                    self.handleInvalidRequest(nil);
                    return;
                }
                
                if _requestChunkSize > 0 {
                    var bytesToRead:UInt = 0;
                    bytesToRead = (UInt(_requestChunkSize) < POST_CHUNKSIZE) ? UInt(_requestChunkSize) : POST_CHUNKSIZE;
                    
                    _asyncSocket?.readData(toLength: bytesToRead,
                                      withTimeout:TIMEOUT_READ_BODY,
                                              tag:HTTP_REQUEST_CHUNK_DATA);
                }
                else
                {
                    // This is the "0" (zero) line,
                    // which is to be followed by optional footers (just like headers) and finally a blank line.
                    
                    _asyncSocket?.readData(to: GCDAsyncSocket.crlfData(),
                                    withTimeout:TIMEOUT_READ_BODY,
                                      maxLength:MAX_HEADER_LINE_LENGTH,
                                            tag:HTTP_REQUEST_CHUNK_FOOTER);
                }
                
                return;
            }
            else if tag == Int64(HTTP_REQUEST_CHUNK_DATA){
                // We just read part of the actual data.
                
                _requestContentLengthReceived += UInt64(data.count);
                _requestChunkSizeReceived += UInt64(data.count);
                
                self.processBodyData(data);
                
                let bytesLeft = UInt(_requestChunkSize - _requestChunkSizeReceived);
                if (bytesLeft > 0)
                {
                    let bytesToRead = (bytesLeft < POST_CHUNKSIZE) ? bytesLeft : POST_CHUNKSIZE;
                    
                    _asyncSocket?.readData(toLength: bytesToRead,
                                      withTimeout:TIMEOUT_READ_BODY,
                                              tag:HTTP_REQUEST_CHUNK_DATA);
                }
                else
                {
                    // We've read in all the data for this chunk.
                    // The data is followed by a CRLF, which we need to read (and basically ignore)
                    
                    _asyncSocket?.readData(toLength: 2,
                                      withTimeout:TIMEOUT_READ_BODY,
                                              tag:HTTP_REQUEST_CHUNK_TRAILER);
                }
                
                return;
            }
            else if tag == Int64(HTTP_REQUEST_CHUNK_TRAILER) {
                // This should be the CRLF following the data.
                // Just ensure it's a CRLF.
                
                if data != GCDAsyncSocket.crlfData(){
//                    HTTPLogWarn(@"%@[%p]: Method expects chunk trailer, but is missing", THIS_FILE, self);
                    
                    self.handleInvalidRequest(nil);
                    return;
                }
                
                // Now continue with the next chunk
                
                _asyncSocket?.readData(to: GCDAsyncSocket.crlfData(),
                                withTimeout:TIMEOUT_READ_BODY,
                                  maxLength:MAX_CHUNK_LINE_LENGTH,
                                        tag:HTTP_REQUEST_CHUNK_SIZE);
                
            }
            else if tag == Int64(HTTP_REQUEST_CHUNK_FOOTER) {
                _numHeaderLines += 1;
                if _numHeaderLines > MAX_HEADER_LINES {
                    // Reached the maximum amount of header lines in a single HTTP request
                    // This could be an attempted DOS attack
                    _asyncSocket?.disconnect();
                    
                    // Explictly return to ensure we don't do anything after the socket disconnect
                    return;
                }
                
                if data.count > 2 {
                    // We read in a footer.
                    // In the future we may want to append these to the request.
                    // For now we ignore, and continue reading the footers, waiting for the final blank line.
                    
                    _asyncSocket?.readData(to: GCDAsyncSocket.crlfData(),
                                    withTimeout:TIMEOUT_READ_BODY,
                                      maxLength:MAX_HEADER_LINE_LENGTH,
                                            tag:HTTP_REQUEST_CHUNK_FOOTER);
                }
                else
                {
                    doneReadingRequest = true;
                }
            }
            else  // HTTP_REQUEST_BODY
            {
                // Handle a chunk of data from the POST body
                
                _requestContentLengthReceived += UInt64(data.count);
                self.processBodyData(data);
                
                if UInt(_requestContentLengthReceived) < _requestContentLength {
                    // We're not done reading the post body yet...
                    
                    let bytesLeft = _requestContentLength - UInt(_requestContentLengthReceived);
                    
                    let bytesToRead = bytesLeft < POST_CHUNKSIZE ? bytesLeft : POST_CHUNKSIZE;
                    
                    _asyncSocket?.readData(toLength: bytesToRead,
                                      withTimeout:TIMEOUT_READ_BODY,
                                              tag:HTTP_REQUEST_BODY);
                }
                else
                {
                    doneReadingRequest = true;
                }
            }
            
            // Now that the entire body has been received, we need to reply to the request
            
            if (doneReadingRequest)
            {
                self.finishBody();
                self.replyToHTTPRequest();
            }
        }
    }

    /**
     * This method is called after the socket has successfully written data to the stream.
    **/
    public func socket(_ sock:GCDAsyncSocket, didWriteDataWithTag tag:Int64){
        var doneSendingResponse = true;
        
        if tag == Int64(HTTP_PARTIAL_RESPONSE_BODY) {
            // Update the amount of data we have in asyncSocket's write queue
            if _responseDataSizes.count > 0 {
                self._responseDataSizes.remove(at: 0);
            }
            
            // We only wrote a part of the response - there may be more
            self.continueSendingStandardResponseBody();
        }
        else if Int(tag) == HTTP_CHUNKED_RESPONSE_BODY {
            // Update the amount of data we have in asyncSocket's write queue.
            // This will allow asynchronous responses to continue sending more data.
            if _responseDataSizes.count > 0 {
                _responseDataSizes.remove(at: 0);
            }
            // Don't continue sending the response yet.
            // The chunked footer that was sent after the body will tell us if we have more data to send.
        }
        else if Int(tag) == HTTP_CHUNKED_RESPONSE_FOOTER {
            // Normal chunked footer indicating we have more data to send (non final footer).
            self.continueSendingStandardResponseBody();
        }
        else if Int(tag) == HTTP_PARTIAL_RANGE_RESPONSE_BODY {
            // Update the amount of data we have in asyncSocket's write queue
            if _responseDataSizes.count > 0 {
                _responseDataSizes.remove(at: 0);
            }
            // We only wrote a part of the range - there may be more
            self.continueSendingSingleRangeResponseBody();
        }
        else if Int(tag) == HTTP_PARTIAL_RANGES_RESPONSE_BODY {
            // Update the amount of data we have in asyncSocket's write queue
            if _responseDataSizes.count > 0 {
                _responseDataSizes.remove(at: 0);
            }
            // We only wrote part of the range - there may be more, or there may be more ranges
            self.continueSendingMultiRangeResponseBody();
        }
        else if Int(tag) == HTTP_RESPONSE || Int(tag) == HTTP_FINAL_RESPONSE {
            // Update the amount of data we have in asyncSocket's write queue
            if _responseDataSizes.count > 0 {
                _responseDataSizes.remove(at: 0)
            }
            
            doneSendingResponse = true;
        }
        
        if doneSendingResponse {
            // Inform the http response that we're done
//            if ([httpResponse respondsToSelector:@selector(connectionDidClose)])
//            {
//                [httpResponse connectionDidClose];
//            }
            _httpResponse?.connectionDidClose?();
            
            
            if Int(tag) == HTTP_FINAL_RESPONSE {
                // Cleanup after the last request
                self.finishResponse();
                
                // Terminate the connection
                _asyncSocket?.disconnect();
                
                // Explictly return to ensure we don't do anything after the socket disconnects
                return;
            }
            else
            {
                if self.shouldDie() {
                    // Cleanup after the last request
                    // Note: Don't do this before calling shouldDie, as it needs the request object still.
                    self.finishResponse();
                    
                    // The only time we should invoke [self die] is from socketDidDisconnect,
                    // or if the socket gets taken over by someone else like a WebSocket.
                    
                    _asyncSocket?.disconnect();
                }
                else{
                    // Cleanup after the last request
                    self.finishResponse();
                    
                    // Prepare for the next request
                    
                    // If this assertion fails, it likely means you overrode the
                    // finishBody method and forgot to call [super finishBody].
//                    NSAssert(request == nil, @"Request not properly released in finishBody");
                    
                    _request = HTTPMessage();
                    
                    _numHeaderLines = 0;
                    _sentResponseHeaders = false;
                    
                    // And start listening for more requests
                    self.startReadingRequest();
                }
            }
        }
    }

    /**
     * Sent after the socket has been disconnected.
    **/
    public func socketDidDisconnect(_ sock:GCDAsyncSocket, withError err:NSError){
//        HTTPLogTrace();
        
        _asyncSocket = nil;
        
        self.die();
    }

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //MARK: HTTPResponse Notifications
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    /**
     * This method may be called by asynchronous HTTPResponse objects.
     * That is, HTTPResponse objects that return YES in their "- (BOOL)isAsynchronous" method.
     * 
     * This informs us that the response object has generated more data that we may be able to send.
    **/
    public func responseHasAvailableData(_ sender:HTTPResponse){
//        HTTPLogTrace();
        
        // We always dispatch this asynchronously onto our connectionQueue,
        // even if the connectionQueue is the current queue.
        // 
        // We do this to give the HTTPResponse classes the flexibility to call
        // this method whenever they want, even from within a readDataOfLength method.
        
        _connectionQueue.async(execute: {
            
            if sender as! NSObject != self._httpResponse! as! NSObject {
//                HTTPLogWarn(@"%@[%p]: %@ - Sender is not current httpResponse", THIS_FILE, self, THIS_METHOD);
                return;
            }
            
            if !self._sentResponseHeaders {
                self.sendResponseHeadersAndBody();
            }
            else
            {
                if self._ranges.count == 0 {// == nil {
                    self.continueSendingStandardResponseBody();
                }
                else{
                    if self._ranges.count == 1 {
                        self.continueSendingSingleRangeResponseBody();
                    }else{
                        self.continueSendingMultiRangeResponseBody();
                    }
                }
            }
        });
    }

    /**
     * This method is called if the response encounters some critical error,
     * and it will be unable to fullfill the request.
    **/
    public func responseDidAbort(_ sender:HTTPResponse){
//        HTTPLogTrace();
        
        // We always dispatch this asynchronously onto our connectionQueue,
        // even if the connectionQueue is the current queue.
        // 
        // We do this to give the HTTPResponse classes the flexibility to call
        // this method whenever they want, even from within a readDataOfLength method.
        
        _connectionQueue.async(execute: {
            
            if (sender as! NSObject != self._httpResponse! as! NSObject)
            {
//                HTTPLogWarn(@"%@[%p]: %@ - Sender is not current httpResponse", THIS_FILE, self, THIS_METHOD);
                return;
            }
            
            self._asyncSocket?.disconnectAfterWriting();
        });
    }

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //MARK: Post Request
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    /**
     * This method is called after each response has been fully sent.
     * Since a single connection may handle multiple request/responses, this method may be called multiple times.
     * That is, it will be called after completion of each response.
    **/
    public func finishResponse(){
//        HTTPLogTrace();
        
        // Override me if you want to perform any custom actions after a response has been fully sent.
        // This is the place to release memory or resources associated with the last request.
        // 
        // If you override this method, you should take care to invoke [super finishResponse] at some point.
        
        _request = nil;
        
        _httpResponse = nil;
        
        _ranges.removeAll();
        _ranges_headers.removeAll();
        _ranges_boundry = nil;
    }

    /**
     * This method is called after each successful response has been fully sent.
     * It determines whether the connection should stay open and handle another request.
    **/
    public func shouldDie()->Bool{
//        HTTPLogTrace();
        
        // Override me if you have any need to force close the connection.
        // You may do so by simply returning YES.
        // 
        // If you override this method, you should take care to fall through with [super shouldDie]
        // instead of returning NO.
        
        
        var shouldDie = false;
        
        let version = request.version;
        if version != nil && version == kCFHTTPVersion1_1 as String {
            // HTTP version 1.1
            // Connection should only be closed if request included "Connection: close" header
            
            let connection = request.headerField("Connection");
            
            shouldDie = connection != nil && (connection! as NSString).caseInsensitiveCompare("close") == ComparisonResult.orderedSame;
        }
        else if version != nil && version == kCFHTTPVersion1_0 as String {
            // HTTP version 1.0
            // Connection should be closed unless request included "Connection: Keep-Alive" header
            
            let connection = request.headerField("Connection");
            
            if connection == nil {
                shouldDie = true;
            }else{
                shouldDie = (connection! as NSString).caseInsensitiveCompare("Keep-Alive") != ComparisonResult.orderedSame
            }
        }
        
        return shouldDie;
    }

    public func die(){
//        HTTPLogTrace();
    
        // Override me if you want to perform any custom actions when a connection is closed.
        // Then call [super die] when you're done.
        // 
        // See also the finishResponse method.
        // 
        // Important: There is a rare timing condition where this method might get invoked twice.
        // If you override this method, you should be prepared for this situation.
        
        // Inform the http response that we're done
//        if ([httpResponse respondsToSelector:@selector(connectionDidClose)])
//        {
//            [httpResponse connectionDidClose];
//        }
        _httpResponse?.connectionDidClose?();
        
        // Release the http response so we don't call it's connectionDidClose method again in our dealloc method
        _httpResponse = nil;
        
        // Post notification of dead connection
        // This will allow our server to release us from its array of connections
        NotificationCenter.default.post(name: Notification.Name(rawValue: HTTPConnectionDidDieNotification), object:self);
    }

}

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

