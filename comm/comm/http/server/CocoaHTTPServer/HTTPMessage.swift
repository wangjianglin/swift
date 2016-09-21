//#import "HTTPMessage.h"
//
//#if ! __has_feature(objc_arc)
//#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
//#endif
import CFNetwork

open class HTTPMessage {

//- (id)initEmptyRequest
//{
//	if ((self = [super init]))
//	{
//		message = CFHTTPMessageCreateEmpty(NULL, YES);
//	}
//	return self;
//}
    fileprivate let _message:CFHTTPMessage;
    
    public init(){
        _message = CFHTTPMessageCreateEmpty(nil, true).takeRetainedValue();
    }


    public init(method:String, URL url:URL, version:String){
        
		_message = CFHTTPMessageCreateRequest(nil,
		                                    method as CFString,
		                                    url as CFURL,
		                                    version as CFString).takeRetainedValue();
	
    }

    public init(statusCode:Int, description:String?, version:String){
		_message = CFHTTPMessageCreateResponse(nil,
		                                      CFIndex(statusCode),
		                                      description as CFString?,
		                                      version as CFString).takeRetainedValue();
    }

//    deinit{
//	if (message)
//	{
//		CFRelease(message);
//	}
//}

    open func appendData(_ data:Data)->Bool{
        //        data.bytes
//        let dp = [UInt8](UnsafeBufferPointer<UInt8>(
//            start: UnsafePointer<UInt8>((data as NSData).bytes),
//            count: data.count
//        ))
        
        var bs = (data as NSData).bytes;// as UnsafePointer<UInt8>;
        
        return withUnsafeMutablePointer(to: &bs) { (ptr) -> Bool in
            
            return ptr.withMemoryRebound(to: UInt8.self, capacity: data.count, { uptr -> Bool in
                //            for n in 0 ..< 2 {
                //                uptr[1-n] = buffer[n + offset];
                //            }
                return CFHTTPMessageAppendBytes(_message, uptr, CFIndex(data.count));
            })
        }
        
//        bs.withMemoryRebound(to: UInt8.self, capacity: 2, { uptr -> () in
////            for n in 0 ..< 2 {
////                uptr[1-n] = buffer[n + offset];
////            }
//        })
//        
//        let a = UnsafePointer<UInt8>.init(bitPattern: bs);
//        let dp = [UInt8](UnsafeBufferPointer<UInt8>(
//            start: a,
//            count: data.count
//        ))
//        return CFHTTPMessageAppendBytes(_message, dp, CFIndex(data.count));
    }

    open var isHeaderComplete:Bool{
        return CFHTTPMessageIsHeaderComplete(_message);
    }

    open var version:String?{
        let v = CFHTTPMessageCopyVersion(_message)
    
        if v.toOpaque() == nil {
            return nil;
        }
        
        return v.takeRetainedValue() as String;
    }

    open var method:String?{
        if let method = CFHTTPMessageCopyRequestMethod(_message)?.takeRetainedValue() {
            return method as String;
        }
        return nil;
    }

    open var url:URL? {
        if let url = CFHTTPMessageCopyRequestURL(_message)?.takeRetainedValue() {
            return url as URL;
        }
        return nil;
    }

    open var statusCode:Int{
        return CFHTTPMessageGetResponseStatusCode(_message);
    }

    open func allHeaderFields()->[AnyHashable: Any]!{
        return CFHTTPMessageCopyAllHeaderFields(_message)?.takeRetainedValue() as! [AnyHashable: Any]!;
    }

    open func headerField(_ header:String)->String?{
        if let v = CFHTTPMessageCopyHeaderFieldValue(_message, header as CFString)?.takeRetainedValue(){
            return v as String;
        }
        return nil;
    }

    open func setHeaderField(_ header:String, value:String){
        CFHTTPMessageSetHeaderFieldValue(_message,
                                         header as CFString,
                                         value as CFString?);
    }

    open var messageData:Data?{
        if let v = CFHTTPMessageCopySerializedMessage(_message)?.takeRetainedValue(){
            return v as Data;
        }
        return nil;
    }

    open var body:Data?{
        if let v = CFHTTPMessageCopyBody(_message)?.takeRetainedValue(){
            return v as Data;
        }
        return nil;
    }

    open func setBody(_ body:Data){
        CFHTTPMessageSetBody(_message, body as CFData);
    }
}
