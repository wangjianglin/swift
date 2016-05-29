//#import "HTTPMessage.h"
//
//#if ! __has_feature(objc_arc)
//#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
//#endif
import CFNetwork

public class HTTPMessage {

//- (id)initEmptyRequest
//{
//	if ((self = [super init]))
//	{
//		message = CFHTTPMessageCreateEmpty(NULL, YES);
//	}
//	return self;
//}
    private let _message:CFHTTPMessage;
    
    public init(){
        _message = CFHTTPMessageCreateEmpty(nil, true).takeRetainedValue();
    }


    public init(method:String, URL url:NSURL, version:String){
        
		_message = CFHTTPMessageCreateRequest(nil,
		                                    method,
		                                    url,
		                                    version).takeRetainedValue();
	
    }

    public init(statusCode:Int, description:String?, version:String){
		_message = CFHTTPMessageCreateResponse(nil,
		                                      CFIndex(statusCode),
		                                      description,
		                                      version).takeRetainedValue();
    }

//    deinit{
//	if (message)
//	{
//		CFRelease(message);
//	}
//}

    public func appendData(data:NSData)->Bool{
//        data.bytes
        let dp = [UInt8](UnsafeBufferPointer<UInt8>(
            start: UnsafePointer<UInt8>(data.bytes),
            count: data.length
            ))
        return CFHTTPMessageAppendBytes(_message, dp, CFIndex(data.length));
    }

    public var isHeaderComplete:Bool{
        return CFHTTPMessageIsHeaderComplete(_message);
    }

    public var version:String?{
        let v = CFHTTPMessageCopyVersion(_message)
    
        if v.toOpaque() == nil {
            return nil;
        }
        
        return v.takeRetainedValue() as String;
    }

    public var method:String?{
        if let method = CFHTTPMessageCopyRequestMethod(_message)?.takeRetainedValue() {
            return method as String;
        }
        return nil;
    }

    public var url:NSURL? {
        if let url = CFHTTPMessageCopyRequestURL(_message)?.takeRetainedValue() {
            return url;
        }
        return nil;
    }

    public var statusCode:Int{
        return CFHTTPMessageGetResponseStatusCode(_message);
    }

    public func allHeaderFields()->[NSObject : AnyObject]!{
        return CFHTTPMessageCopyAllHeaderFields(_message)?.takeRetainedValue() as [NSObject : AnyObject]!;
    }

    public func headerField(header:String)->String?{
        if let v = CFHTTPMessageCopyHeaderFieldValue(_message, header)?.takeRetainedValue(){
            return v as String;
        }
        return nil;
    }

    public func setHeaderField(header:String, value:String){
        CFHTTPMessageSetHeaderFieldValue(_message,
                                         header,
                                         value);
    }

    public var messageData:NSData?{
        if let v = CFHTTPMessageCopySerializedMessage(_message)?.takeRetainedValue(){
            return v;
        }
        return nil;
    }

    public var body:NSData?{
        if let v = CFHTTPMessageCopyBody(_message)?.takeRetainedValue(){
            return v;
        }
        return nil;
    }

    public func setBody(body:NSData){
        CFHTTPMessageSetBody(_message, body);
    }
}
