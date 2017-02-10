//
//  ServerHttpResponse.swift
//  LinComm
//
//  Created by lin on 17/10/2016.
//  Copyright © 2016 lin. All rights reserved.
//

import Foundation


public protocol ServerHttpResponse : HttpResponse{
    //@property(readonly) UInt64 contentLength;
    //
    ///**
    // * The HTTP server supports range requests in order to allow things like
    // * file download resumption and optimized streaming on mobile devices.
    //**/
    ////- (UInt64)offset;
    ////- (void)setOffset:(UInt64)offset;
    //@property UInt64 offset;
    var offset:UInt64{get set}
    //
    ///**
    // * Returns the data for the response.
    // * You do not have to return data of the exact length that is given.
    // * You may optionally return data of a lesser length.
    // * However, you must never return data of a greater length than requested.
    // * Doing so could disrupt proper support for range requests.
    // *
    // * To support asynchronous responses, read the discussion at the bottom of this header.
    //**/
    //- (NSData *)readDataOfLength:(NSUInteger)length;
    func readData(ofLength:UInt)->Data?;
    //
    ///**
    // * Should only return YES after the HTTPConnection has read all available data.
    // * That is, all data for the response has been returned to the HTTPConnection via the readDataOfLength method.
    //**/
    ////- (BOOL)isDone;
    //@property(readonly) BOOL isDone;
    var isDone:Bool{get};
    //
    //@optional
    //
    ///**
    // * If you need time to calculate any part of the HTTP response headers (status code or header fields),
    // * this method allows you to delay sending the headers so that you may asynchronously execute the calculations.
    // * Simply implement this method and return YES until you have everything you need concerning the headers.
    // *
    // * This method ties into the asynchronous response architecture of the HTTPConnection.
    // * You should read the full discussion at the bottom of this header.
    // *
    // * If you return YES from this method,
    // * the HTTPConnection will wait for you to invoke the responseHasAvailableData method.
    // * After you do, the HTTPConnection will again invoke this method to see if the response is ready to send the headers.
    // *
    // * You should only delay sending the headers until you have everything you need concerning just the headers.
    // * Asynchronously generating the body of the response is not an excuse to delay sending the headers.
    // * Instead you should tie into the asynchronous response architecture, and use techniques such as the isChunked method.
    // *
    // * Important: You should read the discussion at the bottom of this header.
    //**/
    //- (BOOL)delayResponseHeaders;
    var delayResponseHeaders:Bool{get};
    //
    ///**
    // * Status code for response.
    // * Allows for responses such as redirect (301), etc.
    //**/
    //- (NSInteger)status;
    //
    ///**
    // * If you want to add any extra HTTP headers to the response,
    // * simply return them in a dictionary in this method.
    //**/
    //- (NSDictionary *)httpHeaders;
    //
    ///**
    // * If you don't know the content-length in advance,
    // * implement this method in your custom response class and return YES.
    // *
    // * Important: You should read the discussion at the bottom of this header.
    //**/
    //- (BOOL)isChunked;
    var isChunked:Bool{get};
    //
    ///**
    // * This method is called from the HTTPConnection class when the connection is closed,
    // * or when the connection is finished with the response.
    // * If your response is asynchronous, you should implement this method so you know not to
    // * invoke any methods on the HTTPConnection after this method is called (as the connection may be deallocated).
    //**/
    //- (void)connectionDidClose;
    func connectionDidClose();
}

//open class ServerHttpResponse : AbstractHttpResponse{
//    //@property(readonly) UInt64 contentLength;
//    //
//    ///**
//    // * The HTTP server supports range requests in order to allow things like
//    // * file download resumption and optimized streaming on mobile devices.
//    //**/
//    ////- (UInt64)offset;
//    ////- (void)setOffset:(UInt64)offset;
//    //@property UInt64 offset;
//    open var offset:UInt64 = 0;
//    //
//    ///**
//    // * Returns the data for the response.
//    // * You do not have to return data of the exact length that is given.
//    // * You may optionally return data of a lesser length.
//    // * However, you must never return data of a greater length than requested.
//    // * Doing so could disrupt proper support for range requests.
//    // *
//    // * To support asynchronous responses, read the discussion at the bottom of this header.
//    //**/
//    //- (NSData *)readDataOfLength:(NSUInteger)length;
//    open func readData(ofLength:UInt)->Data?{
//        return nil;
//    }
//    //
//    ///**
//    // * Should only return YES after the HTTPConnection has read all available data.
//    // * That is, all data for the response has been returned to the HTTPConnection via the readDataOfLength method.
//    //**/
//    ////- (BOOL)isDone;
//    //@property(readonly) BOOL isDone;
//    open var isDone:Bool = false;
//    //
//    //@optional
//    //
//    ///**
//    // * If you need time to calculate any part of the HTTP response headers (status code or header fields),
//    // * this method allows you to delay sending the headers so that you may asynchronously execute the calculations.
//    // * Simply implement this method and return YES until you have everything you need concerning the headers.
//    // *
//    // * This method ties into the asynchronous response architecture of the HTTPConnection.
//    // * You should read the full discussion at the bottom of this header.
//    // *
//    // * If you return YES from this method,
//    // * the HTTPConnection will wait for you to invoke the responseHasAvailableData method.
//    // * After you do, the HTTPConnection will again invoke this method to see if the response is ready to send the headers.
//    // *
//    // * You should only delay sending the headers until you have everything you need concerning just the headers.
//    // * Asynchronously generating the body of the response is not an excuse to delay sending the headers.
//    // * Instead you should tie into the asynchronous response architecture, and use techniques such as the isChunked method.
//    // *
//    // * Important: You should read the discussion at the bottom of this header.
//    //**/
//    //- (BOOL)delayResponseHeaders;
//    open var delayResponseHeaders:Bool = false;
//    //
//    ///**
//    // * Status code for response.
//    // * Allows for responses such as redirect (301), etc.
//    //**/
//    //- (NSInteger)status;
//    //
//    ///**
//    // * If you want to add any extra HTTP headers to the response,
//    // * simply return them in a dictionary in this method.
//    //**/
//    //- (NSDictionary *)httpHeaders;
//    //
//    ///**
//    // * If you don't know the content-length in advance,
//    // * implement this method in your custom response class and return YES.
//    // *
//    // * Important: You should read the discussion at the bottom of this header.
//    //**/
//    //- (BOOL)isChunked;
//    open var isChunked:Bool = false;
//    //
//    ///**
//    // * This method is called from the HTTPConnection class when the connection is closed,
//    // * or when the connection is finished with the response.
//    // * If your response is asynchronous, you should implement this method so you know not to
//    // * invoke any methods on the HTTPConnection after this method is called (as the connection may be deallocated).
//    //**/
//    //- (void)connectionDidClose;
//    open func connectionDidClose(){}
//}
