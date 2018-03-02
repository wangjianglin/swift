//import Darwin
//import Dispatch
//import Foundation
//import CessComm
//import CessUtil
//import MobileCoreServices
//
//
//public protocol HTTPResponse {
//    
//    /**
//     * Returns the length of the data in bytes.
//     * If you don't know the length in advance, implement the isChunked method and have it return YES.
//     **/
//    //- (UInt64)contentLength;
//    public var contentLength: UInt64 { get }
//    
//    /**
//     * The HTTP server supports range requests in order to allow things like
//     * file download resumption and optimized streaming on mobile devices.
//     **/
//    //- (UInt64)offset;
//    //- (void)setOffset:(UInt64)offset;
//    public var offset: UInt64 { get set }
//    
//    /**
//     * Returns the data for the response.
//     * You do not have to return data of the exact length that is given.
//     * You may optionally return data of a lesser length.
//     * However, you must never return data of a greater length than requested.
//     * Doing so could disrupt proper support for range requests.
//     *
//     * To support asynchronous responses, read the discussion at the bottom of this header.
//     **/
//    public func readDataOfLength(length: UInt) -> NSData!
//    
//    /**
//     * Should only return YES after the HTTPConnection has read all available data.
//     * That is, all data for the response has been returned to the HTTPConnection via the readDataOfLength method.
//     **/
//    //- (BOOL)isDone;
//    public var isDone: Bool { get }
//    
//    /**
//     * If you need time to calculate any part of the HTTP response headers (status code or header fields),
//     * this method allows you to delay sending the headers so that you may asynchronously execute the calculations.
//     * Simply implement this method and return YES until you have everything you need concerning the headers.
//     *
//     * This method ties into the asynchronous response architecture of the HTTPConnection.
//     * You should read the full discussion at the bottom of this header.
//     *
//     * If you return YES from this method,
//     * the HTTPConnection will wait for you to invoke the responseHasAvailableData method.
//     * After you do, the HTTPConnection will again invoke this method to see if the response is ready to send the headers.
//     *
//     * You should only delay sending the headers until you have everything you need concerning just the headers.
//     * Asynchronously generating the body of the response is not an excuse to delay sending the headers.
//     * Instead you should tie into the asynchronous response architecture, and use techniques such as the isChunked method.
//     *
//     * Important: You should read the discussion at the bottom of this header.
//     **/
//    optional public func delayResponseHeaders() -> Bool
//    
//    /**
//     * Status code for response.
//     * Allows for responses such as redirect (301), etc.
//     **/
//    optional public func status() -> Int
//    
//    /**
//     * If you want to add any extra HTTP headers to the response,
//     * simply return them in a dictionary in this method.
//     **/
//    @available(iOS 2.0, *)
//    optional public func httpHeaders() -> [NSObject : AnyObject]!
//    
//    /**
//     * If you don't know the content-length in advance,
//     * implement this method in your custom response class and return YES.
//     *
//     * Important: You should read the discussion at the bottom of this header.
//     **/
//    optional public func isChunked() -> Bool
//    
//    /**
//     * This method is called from the HTTPConnection class when the connection is closed,
//     * or when the connection is finished with the response.
//     * If your response is asynchronous, you should implement this method so you know not to
//     * invoke any methods on the HTTPConnection after this method is called (as the connection may be deallocated).
//     **/
//    optional public func connectionDidClose()
//}
