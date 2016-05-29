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
    
public class HTTPServer:NSObject,NSNetServiceDelegate{
    
    private let serverQueue:dispatch_queue_t!;
    private let connectionQueue:dispatch_queue_t!;
    private var asyncSocket:GCDAsyncSocket!;
    

//    private let connectionClass:AnyClass;

//    private let interface:String?;

//    private let port:UInt16 = 0
//    private let domain:String

//    private let name = ""

//    private let connections = NSMutableArray()
//    private let webSockets  = NSMutableArray()
    private var connections = [HTTPConnection]();
    private var webSockets  = [WebSocket]();

    private let connectionsLock = NSLock()
    private let webSocketsLock  = NSLock()
    
    private var _isRunning = false;
    
    private var netService:NSNetService? = nil;
    
    public override init(){
//            HTTPLogTrace();
    
            // Setup underlying dispatch queues
            serverQueue = dispatch_queue_create("HTTPServer", nil);
            connectionQueue = dispatch_queue_create("HTTPConnection", nil);
            
//            IsOnServerQueueKey = &IsOnServerQueueKey;
//            IsOnConnectionQueueKey = &IsOnConnectionQueueKey;
        
//            void *nonNullUnusedPointer = (__bridge void *)self; // Whatever, just not null
        super.init();
        
        let context = Unmanaged.passRetained(self).toOpaque()
        
        //UnsafeMutablePointer<Void> won't manage any memory
        let p = UnsafeMutablePointer<Void>(context)
        
        
//        let p = UnsafeMutablePointer<AnyObject>.init(form:self);
//        p.memory = self;
        
            dispatch_queue_set_specific(serverQueue, "IsOnServerQueueKey", p, nil);
            dispatch_queue_set_specific(connectionQueue, "IsOnConnectionQueueKey", p, nil);
            
            // Initialize underlying GCD based tcp socket
            asyncSocket = GCDAsyncSocket(delegate:self,delegateQueue:serverQueue);
            
            // Use default connection class of HTTPConnection
            connectionClass = HTTPConnection.self;
            
            // By default bind on all available interfaces, en1, wifi etc
        
            // Register for notifications of closed connections
        NSNotificationCenter.defaultCenter().addObserver(self,selector:#selector(self.connectionDidDie(_:)),name:"HTTPConnectionDidDieNotification",object:nil);
            
            // Register for notifications of closed websocket connections
//            [[NSNotificationCenter defaultCenter] addObserver:self
//            selector:@selector(webSocketDidDie:)
//            name:WebSocketDidDieNotification
//            object:nil];
        NSNotificationCenter.defaultCenter().addObserver(self,selector:#selector(self.webSocketDidDie(_:)),name:"WebSocketDidDieNotification",object:nil);
        
        self.netService = nil;
        
    }
    
    /**
     * Standard Deconstructor.
     * Stops the server, and clients, and releases any resources connected with this instance.
     **/
    deinit{
//            HTTPLogTrace();
        
            // Remove notification observer
        NSNotificationCenter.defaultCenter().removeObserver(self);
        
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
            
            dispatch_sync(serverQueue, {
                result = self._documentRoot;
            });
            
            return result;
        }
        set{
        
//        NSString *valueCopy = [value copy];
        
        dispatch_async(serverQueue, {
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
    private var _connectionClass:HTTPConnection.Type = HTTPConnection.self;
    public var connectionClass:HTTPConnection.Type{
        get{
            var result:HTTPConnection.Type!;
            dispatch_sync(serverQueue, {
                result = self._connectionClass;
                });
            
            return result;
        }
        set {
            
        
        dispatch_async(serverQueue, {
            self._connectionClass = newValue;
            });
        }
    }
    
        /**
         * What interface to bind the listening socket to.
         **/
    private var _interface:String? = nil;
    public var interface:String?{
            get{
                var result:String?;
                
                dispatch_sync(serverQueue, {
                    result = self._interface;
                    });
                
                return result;
            }
            
      set{
        
        dispatch_async(serverQueue, {
            self._interface = newValue;
            });
        
        }
    }
    
        /**
         * The port to listen for connections on.
         * By default this port is initially set to zero, which allows the kernel to pick an available port for us.
         * After the HTTP server has started, the port being used may be obtained by this method.
         **/
    private var _port:UInt16 = 8099;
    public var port:UInt16{
            get{
                var result:UInt16 = 0;
                
                dispatch_sync(serverQueue, {
                    result = self._port;
                    });
                
                return result;
            }
        set{
            dispatch_async(serverQueue, {
                self._port = newValue;
            });
        }
    }
    
        public var listeningPort:UInt16
                {
            var result:UInt16 = 0;
                    
                    dispatch_sync(serverQueue, {
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
    private var _domain:String = "local";
    public var domain:String{
        get{
            var result:String!;
            
            dispatch_sync(serverQueue, {
                result = self._domain;
            });
            
            return result;
        }
       set{
            dispatch_async(serverQueue, {
                self._domain = newValue;
            });
        }
    }
    
        /**
         * The name to use for this service via Bonjour.
         * The default name is an empty string,
         * which should result in the published name being the host name of the computer.
         **/
    private var _name:String = "";
    public var name:String{
        get{
            var result:String!;
            
            dispatch_sync(serverQueue, {
                result = self._name;
            });
            
            return result;
        }
        set{
            dispatch_async(serverQueue, {
                self._name = newValue;
            });
        }
    }
    
    public var publishedName:String
    {
        var result:String!;
        
        dispatch_sync(serverQueue, {
            
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
    private var _type:String = "";
    public var type:String{
        get{
            var result:String!;
            
            dispatch_sync(serverQueue, {
                result = self._type;
            });
            
            return result;
        }
        set{
            dispatch_async(serverQueue, {
                self._type = newValue;
            });
        }
    }
    
        /**
         * The extra data to use for this service via Bonjour.
         **/
    private var txtRecordDictionary = Dictionary<String,NSData>();
    private var TXTRecordDictionary:Dictionary<String,NSData>{
            get{
                var result:Dictionary<String,NSData>!;
                
                dispatch_sync(serverQueue, {
                    result = self.txtRecordDictionary;
                });
                
                return result;
            }
            
    set{
//        HTTPLogTrace();
        
//        NSDictionary *valueCopy = [value copy];
        
        dispatch_async(serverQueue, {
            
//            txtRecordDictionary = valueCopy;
            
            // Update the txtRecord of the netService if it has already been published
            if let netService = self.netService{
//                NSNetService *theNetService = netService;
//                NSData *txtRecordData = nil;
//                if (txtRecordDictionary)
//                txtRecordData = [NSNetService dataFromTXTRecordDictionary:txtRecordDictionary];
                let textRecordData = NSNetService.dataFromTXTRecordDictionary(newValue);
                let bonjourBlock = {
                    self.txtRecordDictionary = newValue;
//                    [theNetService setTXTRecordData:txtRecordData];
                    netService.setTXTRecordData(textRecordData);
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
        
        dispatch_sync(serverQueue,  {
            
//            success = [asyncSocket acceptOnInterface:interface port:port error:&err];
//            var error:AutoreleasingUnsafeMutablePointer<NSError>?;
//            success = asyncSocket.acceptOnInterface(interface,port:self._port,error:error);
            do{
                try self.asyncSocket.acceptOnInterface(self._interface, port: self._port)
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
    public func stop(keepExistingConnections:Bool){
//        HTTPLogTrace();
        
        dispatch_sync(serverQueue, {
            
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
    
        dispatch_sync(serverQueue, {
            result = self._isRunning;
            });
        
        return result;
    }
    
    public func addWebSocket(ws:WebSocket){
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
    private var numberOfHTTPConnections:Int
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
    private var numberOfWebSocketConnections:Int
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
    
    private var config:HTTPConfig
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
    public func socket(sock:GCDAsyncSocket,didAcceptNewSocket newSocket:GCDAsyncSocket)
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
    
    private func publishBonjour()
    {
//        HTTPLogTrace();
//        
//        NSAssert(dispatch_get_specific(IsOnServerQueueKey) != NULL, @"Must be on serverQueue");
        
        if (self._type != "")
        {
//            netService = [[NSNetService alloc] initWithDomain:domain type:type name:name port:[asyncSocket localPort]];
//            [netService setDelegate:self];
            netService = NSNetService(domain: self._domain, type: self._type, name: self._name, port: Int32(asyncSocket.localPort()));
            
//            NSNetService *theNetService = netService;
//            NSData *txtRecordData = nil;
//            if (txtRecordDictionary)
//            txtRecordData = [NSNetService dataFromTXTRecordDictionary:txtRecordDictionary];
            let txtRecordData = NSNetService.dataFromTXTRecordDictionary(txtRecordDictionary);
            let bonjourBlock = {
                
                self.netService!.removeFromRunLoop(NSRunLoop.mainRunLoop(), forMode:NSRunLoopCommonModes);
                self.netService!.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode:NSRunLoopCommonModes);
                self.netService!.publish();
                
                // Do not set the txtRecordDictionary prior to publishing!!!
                // This will cause the OS to crash!!!
//                if let txtRecordData = txtRecordData
//                {
//                    [theNetService setTXTRecordData:txtRecordData];
                    self.netService?.setTXTRecordData(txtRecordData);
//                }
            };
            
            HTTPServer.startBonjourThreadIfNeeded();
            HTTPServer.performBonjourBlock(bonjourBlock);
        }
    }
        
    private func unpublishBonjour()
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
    private func republishBonjour()
    {
//                    HTTPLogTrace();
        
        dispatch_async(serverQueue, {
            
            self.unpublishBonjour();
            self.publishBonjour();
        });
    }
    
                /**
                 * Called when our bonjour service has been successfully published.
                 * This method does nothing but output a log message telling us about the published service.
                 **/
    @objc public func netServiceDidPublish(ns:NSNetService)
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
    @objc public func netService(ns: NSNetService, didNotPublish errorDict: [String : NSNumber])
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
    @objc private func connectionDidDie(notification:NSNotification)
    {
        // Note: This method is called on the connection queue that posted the notification
        
        connectionsLock.lock();
        
//        HTTPLogTrace();
//        connections.removeObject(notification.object);
        if let index = connections.indexOf(notification.object as! HTTPConnection){
            connections.removeAtIndex(index)
        }
        
        connectionsLock.unlock();
    }
        
        /**
         * This method is automatically called when a notification of type WebSocketDidDieNotification is posted.
         * It allows us to remove the websocket from our array.
         **/
    @objc private func webSocketDidDie(notification:NSNotification)
    {
        // Note: This method is called on the connection queue that posted the notification
        
        webSocketsLock.lock();
        
//        HTTPLogTrace();
//        webSockets removeObject:[notification object]];
        if let index = webSockets.indexOf(notification.object as! WebSocket){
            webSockets.removeAtIndex(index)
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
        static var bonjourThread:NSThread!;
        static var predicate:dispatch_once_t = 0;
    }
    
    
    private class func startBonjourThreadIfNeeded()
    {
//        HTTPLogTrace();
        
//        static  ;
        dispatch_once(&BonjourThread.predicate, {
        
//        HTTPLogVerbose(@"%@: Starting bonjour thread...", THIS_FILE);
        
//        BonjourThread.bonjourThread = [[NSThread alloc] initWithTarget:self
//        selector:@selector(bonjourThread)
//        object:nil];
//        [bonjourThread start];
            BonjourThread.bonjourThread = NSThread(target: self, selector:#selector(self.bonjourThread), object: nil);
            BonjourThread.bonjourThread.start();
        });
    }
        
    @objc private class func bonjourThread()
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
                NSTimer.scheduledTimerWithTimeInterval(NSDate.distantFuture().timeIntervalSinceNow, target: self, selector: #selector(self.donothingatall(_:)), userInfo: nil, repeats: true);
                
                    NSRunLoop.currentRunLoop().run();
                    
//                    HTTPLogVerbose(@"%@: BonjourThread: Aborted", THIS_FILE);
                
//                }
            }
    @objc private class func donothingatall(_:AnyObject){}
    @objc private class func executeBonjourBlock(block:BlockClass)
    {
//        HTTPLogTrace();
        
//        NSAssert([NSThread currentThread] == bonjourThread, @"Executed on incorrect thread");
        
//        block();
        block.block?();
        }
        
    private class func performBonjourBlock(block:dispatch_block_t)
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
        self.performSelector(#selector(HTTPServer.executeBonjourBlock(_:)), onThread: BonjourThread.bonjourThread, withObject: bc, waitUntilDone: true);
    }
}

@objc private class BlockClass:NSObject{
    private var block:dispatch_block_t?;
}
//    @end
