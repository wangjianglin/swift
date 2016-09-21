//#if ! __has_feature(objc_arc)
//    #warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
//#endif

// Log levels: off, error, warn, info, verbose
// Other flags: trace
private let httpLogLevel = 0; // | HTTP_LOG_FLAG_TRACE


 

//public class HTTPServer{
//    
//    private let serverQueue:dispatch_queue_t;
//    private let connectionQueue:dispatch_queue_t;
//    private let asyncSocket:GCDAsyncSocket;
//    
//    private let connectionClass:AnyClass;
//    
//    private let interface:String?;
//    
//    private let port:UInt16 = 0
//    private let domain:String
//    
//    private let name = ""
//    
//    private let connections = NSMutableArray()
//    private let webSockets  = NSMutableArray()
//    
//    private let connectionsLock = NSLock()
//    private let webSocketsLock  = NSLock()
//    
//    private let isRunning = false;
//    
//    public init(){


//      // Log levels: off, error, warn, info, verbose
//    // Other flags: trace
//    static const int httpLogLevel = HTTP_LOG_LEVEL_INFO; // | HTTP_LOG_FLAG_TRACE;
//    
//    @interface HTTPServer (PrivateAPI)
//    
//    - (void)unpublishBonjour;
//    - (void)publishBonjour;
//    
//    + (void)startBonjourThreadIfNeeded;
//    + (void)performBonjourBlock:(dispatch_block_t)block;
//    
//    @end

    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//MARK: -
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
open class HTTPServer:NSObject,NetServiceDelegate{
    
    fileprivate static var __once: () = {
        
//        HTTPLogVerbose(@"%@: Starting bonjour thread...", THIS_FILE);
        
//        BonjourThread.bonjourThread = [[NSThread alloc] initWithTarget:self
//        selector:@selector(bonjourThread)
//        object:nil];
//        [bonjourThread start];
            BonjourThread.bonjourThread = Thread(target: self, selector:#selector(HTTPServer.bonjourThread), object: nil);
            BonjourThread.bonjourThread.start();
        }()
    
    fileprivate let serverQueue:DispatchQueue!;
    fileprivate let connectionQueue:DispatchQueue!;
    fileprivate var asyncSocket:GCDAsyncSocket!;
    

//    private let connectionClass:AnyClass;

//    private let interface:String?;

//    private let port:UInt16 = 0
//    private let domain:String

//    private let name = ""

//    private let connections = NSMutableArray()
//    private let webSockets  = NSMutableArray()
    fileprivate var connections = [HTTPConnection]();
    fileprivate var webSockets  = [WebSocket]();

    fileprivate let connectionsLock = NSLock()
    fileprivate let webSocketsLock  = NSLock()
    
    fileprivate var _isRunning = false;
    
    fileprivate var netService:NetService? = nil;
    
    public override init(){
//            HTTPLogTrace();
    
            // Setup underlying dispatch queues
            serverQueue = DispatchQueue(label: "HTTPServer");
            connectionQueue = DispatchQueue(label: "HTTPConnection");
            
//            IsOnServerQueueKey = &IsOnServerQueueKey;
//            IsOnConnectionQueueKey = &IsOnConnectionQueueKey;
        
//            void *nonNullUnusedPointer = (__bridge void *)self; // Whatever, just not null
        super.init();
        
        let context = Unmanaged.passRetained(self).toOpaque()
        
        //UnsafeMutablePointer<Void> won't manage any memory
        let p = UnsafeMutableRawPointer(context)
        
        
//        let p = UnsafeMutablePointer<AnyObject>.init(form:self);
//        p.memory = self;
        
//            serverQueue.setSpecific(key: /*Migrator FIXME: Use a variable of type DispatchSpecificKey*/ "IsOnServerQueueKey", value: p);
//        let k1 = DispatchSpecificKey();
//        k1.
        serverQueue.setSpecific(key: DispatchSpecificKey(),value:p);
//            connectionQueue.setSpecific(key: /*Migrator FIXME: Use a variable of type DispatchSpecificKey*/ "IsOnConnectionQueueKey", value: p);
        serverQueue.setSpecific(key: DispatchSpecificKey(),value:p);
        
            // Initialize underlying GCD based tcp socket
            asyncSocket = GCDAsyncSocket(delegate:self,delegateQueue:serverQueue);
            
            // Use default connection class of HTTPConnection
            connectionClass = HTTPConnection.self;
            
            // By default bind on all available interfaces, en1, wifi etc
        
            // Register for notifications of closed connections
        NotificationCenter.default.addObserver(self,selector:#selector(self.connectionDidDie(_:)),name:NSNotification.Name("HTTPConnectionDidDieNotification"),object:nil);
            
            // Register for notifications of closed websocket connections
//            [[NSNotificationCenter defaultCenter] addObserver:self
//            selector:@selector(webSocketDidDie:)
//            name:WebSocketDidDieNotification
//            object:nil];
        NotificationCenter.default.addObserver(self,selector:#selector(self.webSocketDidDie(_:)),name:NSNotification.Name("WebSocketDidDieNotification"),object:nil);
        
        self.netService = nil;
        
    }
    
    /**
     * Standard Deconstructor.
     * Stops the server, and clients, and releases any resources connected with this instance.
     **/
    deinit{
//            HTTPLogTrace();
        
            // Remove notification observer
        NotificationCenter.default.removeObserver(self);
        
        // Stop the server if it's running
        self.stop();
        
        // Release all instance variables
        
//            #if !OS_OBJECT_USE_OBJC
//                dispatch_release(serverQueue);
//                dispatch_release(connectionQueue);
//            #endif
    
        asyncSocket.setDelegate(nil,delegateQueue:nil);
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //MARK: Server Configuration
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    /**
     * The document root is filesystem root for the webserver.
     * Thus requests for /index.html will be referencing the index.html file within the document root directory.
     * All file requests are relative to this document root.
     **/
    private var _documentRoot:String = "";
    public var documentRoot:String{
        get {
            var result:String!;
            
            serverQueue.sync(execute: {
                result = self._documentRoot;
            });
            
            return result;
        }
        set{
        
//        NSString *valueCopy = [value copy];
        
        serverQueue.async(execute: {
            self._documentRoot = newValue;
            });
        
        }
    }
    
        /**
         * The connection class is the class that will be used to handle connections.
         * That is, when a new connection is created, an instance of this class will be intialized.
         * The default connection class is HTTPConnection.
         * If you use a different connection class, it is assumed that the class extends HTTPConnection
         **/
    fileprivate var _connectionClass:HTTPConnection.Type = HTTPConnection.self;
    public var connectionClass:HTTPConnection.Type{
        get{
            var result:HTTPConnection.Type!;
            serverQueue.sync(execute: {
                result = self._connectionClass;
                });
            
            return result;
        }
        set {
            
        
        serverQueue.async(execute: {
            self._connectionClass = newValue;
            });
        }
    }
    
        /**
         * What interface to bind the listening socket to.
         **/
    fileprivate var _interface:String? = nil;
    public var interface:String?{
            get{
                var result:String?;
                
                serverQueue.sync(execute: {
                    result = self._interface;
                    });
                
                return result;
            }
            
      set{
        
        serverQueue.async(execute: {
            self._interface = newValue;
            });
        
        }
    }
    
        /**
         * The port to listen for connections on.
         * By default this port is initially set to zero, which allows the kernel to pick an available port for us.
         * After the HTTP server has started, the port being used may be obtained by this method.
         **/
    fileprivate var _port:UInt16 = 8099;
    public var port:UInt16{
            get{
                var result:UInt16 = 0;
                
                serverQueue.sync(execute: {
                    result = self._port;
                    });
                
                return result;
            }
        set{
            serverQueue.async(execute: {
                self._port = newValue;
            });
        }
    }
    
        public var listeningPort:UInt16
                {
            var result:UInt16 = 0;
                    
                    serverQueue.sync(execute: {
                        if self.isRunning{
                            result = self.asyncSocket.localPort();
                        }else{
                        result = 0;
                        }});
                    
                    return result;
                }
                
    
    
        
        /**
         * Domain on which to broadcast this service via Bonjour.
         * The default domain is @"local".
         **/
    fileprivate var _domain:String = "local";
    public var domain:String{
        get{
            var result:String!;
            
            serverQueue.sync(execute: {
                result = self._domain;
            });
            
            return result;
        }
       set{
            serverQueue.async(execute: {
                self._domain = newValue;
            });
        }
    }
    
        /**
         * The name to use for this service via Bonjour.
         * The default name is an empty string,
         * which should result in the published name being the host name of the computer.
         **/
    fileprivate var _name:String = "";
    public var name:String{
        get{
            var result:String!;
            
            serverQueue.sync(execute: {
                result = self._name;
            });
            
            return result;
        }
        set{
            serverQueue.async(execute: {
                self._name = newValue;
            });
        }
    }
    
    public var publishedName:String
    {
        var result:String!;
        
        serverQueue.sync(execute: {
            
            if let netService = self.netService {
                
                let bonjourBlock = {
                    result = netService.name;
                };
//                [[self class] performBonjourBlock:bonjourBlock];
                HTTPServer.performBonjourBlock(bonjourBlock);
                
            }
        });
        
        return result;
    }
    
        
        /**
         * The type of service to publish via Bonjour.
         * No type is set by default, and one must be set in order for the service to be published.
         **/
    fileprivate var _type:String = "";
    public var type:String{
        get{
            var result:String!;
            
            serverQueue.sync(execute: {
                result = self._type;
            });
            
            return result;
        }
        set{
            serverQueue.async(execute: {
                self._type = newValue;
            });
        }
    }
    
        /**
         * The extra data to use for this service via Bonjour.
         **/
    fileprivate var txtRecordDictionary = Dictionary<String,Data>();
    fileprivate var TXTRecordDictionary:Dictionary<String,Data>{
            get{
                var result:Dictionary<String,Data>!;
                
                serverQueue.sync(execute: {
                    result = self.txtRecordDictionary;
                });
                
                return result;
            }
            
    set{
//        HTTPLogTrace();
        
//        NSDictionary *valueCopy = [value copy];
        
        serverQueue.async(execute: {
            
//            txtRecordDictionary = valueCopy;
            
            // Update the txtRecord of the netService if it has already been published
            if let netService = self.netService{
//                NSNetService *theNetService = netService;
//                NSData *txtRecordData = nil;
//                if (txtRecordDictionary)
//                txtRecordData = [NSNetService dataFromTXTRecordDictionary:txtRecordDictionary];
                let textRecordData = NetService.data(fromTXTRecord: newValue);
                let bonjourBlock = {
                    self.txtRecordDictionary = newValue;
//                    [theNetService setTXTRecordData:txtRecordData];
                    netService.setTXTRecord(textRecordData);
                };
                
                HTTPServer.performBonjourBlock(bonjourBlock);
            }
        });
        }
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //MARK: Server Control
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
//    - (BOOL)start:(NSError **)errPtr
    public func start()throws
    {
//        HTTPLogTrace();
        
//        __block BOOL success = YES;
//        __block NSError *err = nil;
        var success:Bool = true;
        var error:NSError?;
        
        serverQueue.sync(execute: {
            
//            success = [asyncSocket acceptOnInterface:interface port:port error:&err];
//            var error:AutoreleasingUnsafeMutablePointer<NSError>?;
//            success = asyncSocket.acceptOnInterface(interface,port:self._port,error:error);
            do{
                try self.asyncSocket.accept(onInterface: self._interface, port: self._port)
            }catch let e as NSError{
                error = e;
                success = false;
            }
            if (success)
            {
//                HTTPLogInfo(@"%@: Started HTTP server on port %hu", THIS_FILE, [asyncSocket localPort]);
                
                self._isRunning = true;
//                [self publishBonjour];
                self.publishBonjour();
            }
//            else
//            {
//                HTTPLogError(@"%@: Failed to start HTTP Server: %@", THIS_FILE, err);
//            }
        });
        
//        if (errPtr)
//        *errPtr = err;
        if let error = error {
            throw error;
        }
        //return (success,error);
        }
        
//        - (void)stop
//            {
//                [self stop:NO];
//            }
    public func stop(){
        self.stop(false);
    }
//            - (void)stop:(BOOL)keepExistingConnections
    public func stop(_ keepExistingConnections:Bool){
//        HTTPLogTrace();
        
        serverQueue.sync(execute: {
            
            // First stop publishing the service via bonjour
            self.unpublishBonjour();
            
            // Stop listening / accepting incoming connections
//            [asyncSocket disconnect];
            self.asyncSocket.disconnect();
            self._isRunning = false;
            
            if (!keepExistingConnections)
            {
                // Stop all HTTP connections the server owns
//                [connectionsLock lock];
                self.connectionsLock.lock();
//                for (HTTPConnection *connection in connections)
//                {
//                    [connection stop];
//                }
                for connection in self.connections{
                    connection.stop();
                }
                
//                [connections removeAllObjects];
//                [connectionsLock unlock];
                self.connections.removeAll();
                self.connectionsLock.unlock();
                
                // Stop all WebSocket connections the server owns
//                [webSocketsLock lock];
                self.webSocketsLock.lock();
//                for (WebSocket *webSocket in webSockets)
//                {
//                    [webSocket stop];
//                }
                for webSocket in self.webSockets {
                    webSocket.stop();
                }
                self.webSockets.removeAll();
                self.webSocketsLock.unlock();
            }
        });
    }
        
    public var isRunning:Bool{
        var result:Bool = false;
    
        serverQueue.sync(execute: {
            result = self._isRunning;
            });
        
        return result;
    }
    
    public func addWebSocket(_ ws:WebSocket){
//        [webSocketsLock lock];
        webSocketsLock.lock();
        
//        HTTPLogTrace();
//        [webSockets addObject:ws];
        webSockets.append(ws);
        
        webSocketsLock.unlock();
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //MARK: Server Status
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    /**
     * Returns the number of http client connections that are currently connected to the server.
     **/
    fileprivate var numberOfHTTPConnections:Int
    {
        var result:Int = 0;
        
        connectionsLock.lock();
        result = connections.count;
        connectionsLock.unlock();
        
        return result;
    }
        
        /**
         * Returns the number of websocket client connections that are currently connected to the server.
         **/
    fileprivate var numberOfWebSocketConnections:Int
            {
        var result:Int = 0;
        
        webSocketsLock.lock();
        result = webSockets.count;
        webSocketsLock.unlock();
        
        return result;
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //MARK: Incoming Connections
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    fileprivate var config:HTTPConfig
    {
        // Override me if you want to provide a custom config to the new connection.
        //
        // Generally this involves overriding the HTTPConfig class to include any custom settings,
        // and then having this method return an instance of 'MyHTTPConfig'.
        
        // Note: Think you can make the server faster by putting each connection on its own queue?
        // Then benchmark it before and after and discover for yourself the shocking truth!
        // 
        // Try the apache benchmark tool (already installed on your Mac):
        // $  ab -n 1000 -c 1 http://localhost:<port>/some_path.html
        
        //return [[HTTPConfig alloc] initWithServer:self documentRoot:documentRoot queue:connectionQueue];
        return HTTPConfig(server: self, documentRoot: _documentRoot, queue: connectionQueue);
        }
        
        //- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket
    public func socket(_ sock:GCDAsyncSocket,didAcceptNewSocket newSocket:GCDAsyncSocket)
    {
//        HTTPConnection *newConnection = (HTTPConnection *)[[connectionClass alloc] initWithAsyncSocket:newSocket
//            configuration:[self config]];
        let newConnection = _connectionClass.init(socket:newSocket,configuration:self.config);
        connectionsLock.lock();
        connections.append(newConnection);
        connectionsLock.unlock();
        
        newConnection.start();
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //MARK: Bonjour
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    fileprivate func publishBonjour()
    {
//        HTTPLogTrace();
//        
//        NSAssert(dispatch_get_specific(IsOnServerQueueKey) != NULL, @"Must be on serverQueue");
        
        if (self._type != "")
        {
//            netService = [[NSNetService alloc] initWithDomain:domain type:type name:name port:[asyncSocket localPort]];
//            [netService setDelegate:self];
            netService = NetService(domain: self._domain, type: self._type, name: self._name, port: Int32(asyncSocket.localPort()));
            
//            NSNetService *theNetService = netService;
//            NSData *txtRecordData = nil;
//            if (txtRecordDictionary)
//            txtRecordData = [NSNetService dataFromTXTRecordDictionary:txtRecordDictionary];
            let txtRecordData = NetService.data(fromTXTRecord: txtRecordDictionary);
            let bonjourBlock = {
                
                self.netService!.remove(from: RunLoop.main, forMode:RunLoopMode.commonModes);
                self.netService!.schedule(in: RunLoop.current, forMode:RunLoopMode.commonModes);
                self.netService!.publish();
                
                // Do not set the txtRecordDictionary prior to publishing!!!
                // This will cause the OS to crash!!!
//                if let txtRecordData = txtRecordData
//                {
//                    [theNetService setTXTRecordData:txtRecordData];
                    self.netService?.setTXTRecord(txtRecordData);
//                }
            };
            
            HTTPServer.startBonjourThreadIfNeeded();
            HTTPServer.performBonjourBlock(bonjourBlock);
        }
    }
        
    fileprivate func unpublishBonjour()
            {
//                HTTPLogTrace();
                
//                NSAssert(dispatch_get_specific(IsOnServerQueueKey) != NULL, @"Must be on serverQueue");
                
                if let netService = netService
                {
//                    NSNetService *theNetService = netService;
                    
                    let bonjourBlock = {
                        
                        netService.stop();
                    };
                    
                    HTTPServer.performBonjourBlock(bonjourBlock);
                    
                    self.netService = nil;
                }
            }
            
            /**
             * Republishes the service via bonjour if the server is running.
             * If the service was not previously published, this method will publish it (if the server is running).
             **/
    fileprivate func republishBonjour()
    {
//                    HTTPLogTrace();
        
        serverQueue.async(execute: {
            
            self.unpublishBonjour();
            self.publishBonjour();
        });
    }
    
                /**
                 * Called when our bonjour service has been successfully published.
                 * This method does nothing but output a log message telling us about the published service.
                 **/
    @objc public func netServiceDidPublish(_ ns:NetService)
    {
        // Override me to do something here...
        // 
        // Note: This method is invoked on our bonjour thread.
        
//        HTTPLogInfo(@"Bonjour Service Published: domain(%@) type(%@) name(%@)", [ns domain], [ns type], [ns name]);
        print("Bonjour Service Publicshed: domain(\(ns.domain)) type(\(ns.type)) name(\(ns.name) port(\(ns.port)\n");
    }
        
        /**
         * Called if our bonjour service failed to publish itself.
         * This method does nothing but output a log message telling us about the published service.
         **/
    @objc public func netService(_ ns: NetService, didNotPublish errorDict: [String : NSNumber])
    {
        // Override me to do something here...
        // 
        // Note: This method in invoked on our bonjour thread.
        
//        HTTPLogWarn(@"Failed to Publish Service: domain(%@) type(%@) name(%@) - %@",
//                     [ns domain], [ns type], [ns name], errorDict);
        print("Failed to Publish Service: domain(\(ns.domain)) type(\(ns.type)) name(\(ns.type)) port(\(ns.port)) - \(errorDict)\n");
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //MARK: Notifications
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    /**
     * This method is automatically called when a notification of type HTTPConnectionDidDieNotification is posted.
     * It allows us to remove the connection from our array.
     **/
    @objc fileprivate func connectionDidDie(_ notification:Notification)
    {
        // Note: This method is called on the connection queue that posted the notification
        
        connectionsLock.lock();
        
//        HTTPLogTrace();
//        connections.removeObject(notification.object);
        if let index = connections.index(of: notification.object as! HTTPConnection){
            connections.remove(at: index)
        }
        
        connectionsLock.unlock();
    }
        
        /**
         * This method is automatically called when a notification of type WebSocketDidDieNotification is posted.
         * It allows us to remove the websocket from our array.
         **/
    @objc fileprivate func webSocketDidDie(_ notification:Notification)
    {
        // Note: This method is called on the connection queue that posted the notification
        
        webSocketsLock.lock();
        
//        HTTPLogTrace();
//        webSockets removeObject:[notification object]];
        if let index = webSockets.index(of: notification.object as! WebSocket){
            webSockets.remove(at: index)
        }
        webSocketsLock.unlock();
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //MARK: Bonjour Thread
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    /**
     * NSNetService is runloop based, so it requires a thread with a runloop.
     * This gives us two options:
     * 
     * - Use the main thread
     * - Setup our own dedicated thread
     * 
     * Since we have various blocks of code that need to synchronously access the netservice objects,
     * using the main thread becomes troublesome and a potential for deadlock.
     **/
    
    struct BonjourThread {
        static var bonjourThread:Thread!;
        static var predicate:Int = 0;
    }
    
    
    fileprivate class func startBonjourThreadIfNeeded()
    {
//        HTTPLogTrace();
        
//        static  ;
        _ = HTTPServer.__once;
   }
       
    @objc fileprivate class func bonjourThread()
            {
//                @autoreleasepool {
                
//                    HTTPLogVerbose(@"%@: BonjourThread: Started", THIS_FILE);
                
                    // We can't run the run loop unless it has an associated input source or a timer.
                    // So we'll just create a timer that will never fire - unless the server runs for 10,000 years.
//                    #pragma clang diagnostic push
//                    #pragma clang diagnostic ignored "-Wundeclared-selector"
//                    [NSTimer scheduledTimerWithTimeInterval:[[NSDate distantFuture] timeIntervalSinceNow]
//                    target:self
//                    selector:@selector(donothingatall:)
//                    userInfo:nil
//                    repeats:YES];
//                    #pragma clang diagnostic pop
                Timer.scheduledTimer(timeInterval: Date.distantFuture.timeIntervalSinceNow, target: self, selector: #selector(self.donothingatall(_:)), userInfo: nil, repeats: true);
                
                    RunLoop.current.run();
                    
//                    HTTPLogVerbose(@"%@: BonjourThread: Aborted", THIS_FILE);
                
//                }
            }
    @objc fileprivate class func donothingatall(_:AnyObject){}
    @objc fileprivate class func executeBonjourBlock(_ block:BlockClass)
    {
//        HTTPLogTrace();
        
//        NSAssert([NSThread currentThread] == bonjourThread, @"Executed on incorrect thread");
        
//        block();
        block.block?();
        }
        
    fileprivate class func performBonjourBlock(_ block:@escaping ()->())
    {
//        HTTPLogTrace();
        
//        [self performSelector:@selector(executeBonjourBlock:)
//        onThread:bonjourThread
//           withObject:block
//        waitUntilDone:YES];
//        - (void)performSelector:(SEL)aSelector onThread:(NSThread *)thr withObject:(nullable id)arg waitUntilDone:(BOOL)wait NS_AVAILABLE(10_5, 2_0);
//        @conveenttion
//        self.performSelector(#selector(self.executeBonjourBlock(_:)), onThread: BonjourThread.bonjourThread, withObject: block, waitUntilDone: true);
        let bc = BlockClass();
        bc.block = block;
        self.perform(#selector(HTTPServer.executeBonjourBlock(_:)), on: BonjourThread.bonjourThread, with: bc, waitUntilDone: true);
    }
}

@objc fileprivate class BlockClass:NSObject{
    override init() {
//        self.block = nil;
    }
    fileprivate var block:(()->())?;
}
//    @end
