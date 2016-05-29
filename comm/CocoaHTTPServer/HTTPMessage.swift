////#import "HTTPMessage.h"
////
////#if ! __has_feature(objc_arc)
////#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
////#endif
//
//
////@implementation HTTPMessage
//
//import Foundation
//import CFNetwork
//
//public class HTTPMessage{
////- (id)initEmptyRequest
////{
////	if ((self = [super init]))
////	{
////		message = CFHTTPMessageCreateEmpty(NULL, YES);
////	}
////	return self;
////}
//    private var message:CFHTTPMessage;
//    public init(){
//        message = CFHTTPMessageCreateEmpty(nil, true);
//    }
//
////- (id)initRequestWithMethod:(NSString *)method URL:(NSURL *)url version:(NSString *)version
////{
////	if ((self = [super init]))
////	{
////		message = CFHTTPMessageCreateRequest(NULL,
////		                                    (__bridge CFStringRef)method,
////		                                    (__bridge CFURLRef)url,
////		                                    (__bridge CFStringRef)version);
////	}
////	return self;
////}
//    public init(method:String,URL url:NSURL,version:String){
//        message = CFHTTPMessageCreateRequest(nil, method, url, version);
//    }
//
////- (id)initResponseWithStatusCode:(NSInteger)code description:(NSString *)description version:(NSString *)version
////{
////	if ((self = [super init]))
////	{
////		message = CFHTTPMessageCreateResponse(NULL,
////		                                      (CFIndex)code,
////		                                      (__bridge CFStringRef)description,
////		                                      (__bridge CFStringRef)version);
////	}
////	return self;
////}
//    public init(statusCode code:Int,description:String,version:String){
//        message = CFHTTPMessageCreateResponse(nil, code, description, version);
//    }
//
////- (void)dealloc
////{
////	if (message)
////	{
////		CFRelease(message);
////	}
////}
//    deinit{
//        CFRelease(message);
//    }
//
////- (BOOL)appendData:(NSData *)data
////{
////	return CFHTTPMessageAppendBytes(message, [data bytes], [data length]);
////}
//    public func appendData(data:NSData)->Bool{
//        return CFHTTPMessageAppendBytes(message, data.bytes, data.length);
//    }
//
////- (BOOL)isHeaderComplete
////{
////	return CFHTTPMessageIsHeaderComplete(message);
////}
//    public var isHeaderComplete:Bool{
//        return CFHTTPMessageIsHeaderComplete(message);
//    }
////
////- (NSString *)version
////{
////	return (__bridge_transfer NSString *)CFHTTPMessageCopyVersion(message);
////}
//    public var version:String{
//        return CFHTTPMessageCopyVersion(message);
//    }
////
////- (NSString *)method
////{
////	return (__bridge_transfer NSString *)CFHTTPMessageCopyRequestMethod(message);
////}
//    public var method:String{
//        return CFHTTPMessageCopyRequestMethod(message);
//    }
////
////- (NSURL *)url
////{
////	return (__bridge_transfer NSURL *)CFHTTPMessageCopyRequestURL(message);
////}
//    public var url:NSURL{
//        return CFHTTPMessageCopyRequestURL(message);
//    }
////
////- (NSInteger)statusCode
////{
////	return (NSInteger)CFHTTPMessageGetResponseStatusCode(message);
////}
//    public var statusCode:Int{
//        return CFHTTPMessageGetResponseStatusCode(message);
//    }
////
////- (NSDictionary *)allHeaderFields
////{
////	return (__bridge_transfer NSDictionary *)CFHTTPMessageCopyAllHeaderFields(message);
////}
//    public var allHeaderFields:NSDictionary{
//        return CFHTTPMessageCopyAllHeaderFields(message);
//    }
////
////- (NSString *)headerField:(NSString *)headerField
////{
////	return (__bridge_transfer NSString *)CFHTTPMessageCopyHeaderFieldValue(message, (__bridge CFStringRef)headerField);
////}
//    public func headerField(header:String)->String!{
//        return CFHTTPMessageCopyHeaderFieldValue(message, header);
//    }
////
////- (void)setHeaderField:(NSString *)headerField value:(NSString *)headerFieldValue
////{
////	CFHTTPMessageSetHeaderFieldValue(message,
////	                                 (__bridge CFStringRef)headerField,
////	                                 (__bridge CFStringRef)headerFieldValue);
////}
////
//    public func setHeaderField(header:String,value:String){
//        CFHTTPMessageSetHeaderFieldValue(message, header, value);
//    }
////- (NSData *)messageData
////{
////	return (__bridge_transfer NSData *)CFHTTPMessageCopySerializedMessage(message);
////}
//    public var messageData:NSData{
//        return CFHTTPMessageCopySerializedMessage(message);
//    }
////
////- (NSData *)body
////{
////	return (__bridge_transfer NSData *)CFHTTPMessageCopyBody(message);
////}
//    public var body:NSData{
//        get{return CFHTTPMessageCopyBody(message);}
//        set{
//            CFHTTPMessageSetBody(message, newValue);
//        }
//    }
////
////- (void)setBody:(NSData *)body
////{
////	CFHTTPMessageSetBody(message, (__bridge CFDataRef)body);
////}
//}
