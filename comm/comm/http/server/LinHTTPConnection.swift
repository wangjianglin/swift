//
//  LinHTTPConnection.swift
//  LinServer
//
//  Created by lin on 6/5/15.
//  Copyright (c) 2015 lin. All rights reserved.
//

import Foundation


extension HTTPConnection{
    
    private class var lock:NSLock{
        struct YRSingleton{
            static var lock:NSLock = NSLock();
        }
        return YRSingleton.lock;
    }
    
    struct actions{
        static var instance = Dictionary<String, ((connection:HTTPConnection,method:String,path:String)->protocol<NSObjectProtocol, HTTPResponse>!)>();
    }
    
//    private class var pathsAction:Dictionary<String,((connection:HTTPConnection,method:String,path:String)->protocol<NSObjectProtocol, HTTPResponse>!)>{
//        
//        struct YRSingleton{
//            static var predicate:dispatch_once_t = 0
//            static var instance:Dictionary<String, ((connection:HTTPConnection,method:String,path:String)->protocol<NSObjectProtocol, HTTPResponse>!)>? = nil
//        }
//        dispatch_once(&YRSingleton.predicate,{
//            YRSingleton.instance = Dictionary<String,((connection:HTTPConnection,method:String,path:String)->protocol<NSObjectProtocol, HTTPResponse>!)>()
//        })
//        
//        return YRSingleton.instance!;
//    }
    
    public class func register(method:HttpMethod!,path:String,action:((connection:HTTPConnection,method:String,path:String)->protocol<NSObjectProtocol, HTTPResponse>!)){
        lock.lock();
//        var tmp = LinHTTPConnection.pathsAction;
        if(method == nil){
//            tmp.updateValue(action, forKey: "GET:" + path);
//            tmp.updateValue(action, forKey: "POST:" + path);
//            tmp.updateValue(action, forKey: "HEAD:" + path);
            actions.instance["GET:" + path] = action;
            actions.instance["POST:" + path] = action;
//            tmp["HEAD:" + path] = action;
//            YRSingleton.instance = tmp;

        }else{
            actions.instance[method.rawValue.uppercaseString + ":" + path] = action;
        }
        lock.unlock();
    }
    
    public class func remove(method:HttpMethod!,path:String){
        lock.lock();
//        var tmp = LinHTTPConnection.pathsAction;
        if(method == nil){
            actions.instance.removeValueForKey("GET:" + path);
            actions.instance.removeValueForKey("POST:" + path);
//            tmp.removeValueForKey("HEAD:" + path);
        }else{
            actions.instance.removeValueForKey(method.rawValue.uppercaseString + ":" + path);
        }
        lock.unlock();
    }
}

public class LinHTTPConnection : HTTPConnection{
    
//    override public func httpResponseForMethod(method: String!, URI path: String!) -> protocol<NSObjectProtocol, HTTPResponse>! {
    public override func httpResponseForMethod(method:String, URI path:String)->HTTPResponse? {
//    <#code#>
//    }
//        <#code#>
//    }
//    
//    public override func httpResponseForMethod(method: String!, URI path: String!) -> NSObject! {
        
        
//        var filePath = self.filePathForURI(path);
        print("method:\(method)");
        print("path:\(path)");
        
        
        
//        print("body\(super.request.body())");
//        print("body\(super.request.url().path)");
//        
//        print(method+":"+super.request.url().path!);
        if let action = actions.instance[method+":"+super.request.url!.path!] {
            return action(connection: self,method: method,path: path);
        }
        return super.httpResponseForMethod(method, URI: path);
    }
//    - (NSObject<HTTPResponse> *)httpResponseForMethod:(NSString *)method URI:(NSString *)path
//    {
//    // Use HTTPConnection's filePathForURI method.
//    // This method takes the given path (which comes directly from the HTTP request),
//    // and converts it to a full path by combining it with the configured document root.
//    //
//    // It also does cool things for us like support for converting "/" to "/index.html",
//    // and security restrictions (ensuring we don't serve documents outside configured document root folder).
//    
//    NSString *filePath = [self filePathForURI:path];
//    
//    // Convert to relative path
//    
//    NSString *documentRoot = [config documentRoot];
//    
//    if (![filePath hasPrefix:documentRoot])
//    {
//    // Uh oh.
//    // HTTPConnection's filePathForURI was supposed to take care of this for us.
//    return nil;
//    }
//    
//    NSString *relativePath = [filePath substringFromIndex:[documentRoot length]];
//    
//    if ([relativePath isEqualToString:@"/index.html"])
//    {
//    HTTPLogVerbose(@"%@[%p]: Serving up dynamic content", THIS_FILE, self);
//    
//    // The index.html file contains several dynamic fields that need to be completed.
//    // For example:
//    //
//    // Computer name: %%COMPUTER_NAME%%
//    //
//    // We need to replace "%%COMPUTER_NAME%%" with whatever the computer name is.
//    // We can accomplish this easily with the HTTPDynamicFileResponse class,
//    // which takes a dictionary of replacement key-value pairs,
//    // and performs replacements on the fly as it uploads the file.
//    
//    NSString *computerName = [[NSHost currentHost] localizedName];
//    NSString *currentTime = [[NSDate date] description];
//    
//    NSString *story = @"<br/><br/>"
//    "I'll tell you a story     <br/>" \
//    "About Jack a Nory;        <br/>" \
//    "And now my story's begun; <br/>" \
//    "I'll tell you another     <br/>" \
//    "Of Jack and his brother,  <br/>" \
//    "And now my story is done. <br/>";
//    
//    NSMutableDictionary *replacementDict = [NSMutableDictionary dictionaryWithCapacity:5];
//    
//    [replacementDict setObject:computerName forKey:@"COMPUTER_NAME"];
//    [replacementDict setObject:currentTime  forKey:@"TIME"];
//    [replacementDict setObject:story        forKey:@"STORY"];
//    [replacementDict setObject:@"A"         forKey:@"ALPHABET"];
//    [replacementDict setObject:@"  QUACK  " forKey:@"QUACK"];
//    
//    HTTPLogVerbose(@"%@[%p]: replacementDict = \n%@", THIS_FILE, self, replacementDict);
//    
//    return [[HTTPDynamicFileResponse alloc] initWithFilePath:[self filePathForURI:path]
//    forConnection:self
//    separator:@"%%"
//    replacementDictionary:replacementDict];
//}
//else if ([relativePath isEqualToString:@"/unittest.html"])
//{
//    HTTPLogVerbose(@"%@[%p]: Serving up HTTPResponseTest (unit testing)", THIS_FILE, self);
//    
//    return [[HTTPResponseTest alloc] initWithConnection:self];
//}
//
//return [super httpResponseForMethod:method URI:path];
//}
}