//
//  LinWebController.m
//  LinWeb
//
//  Created by lin on 3/13/15.
//  Copyright (c) 2015 lin. All rights reserved.
//

#import "LinWebController.h"
#import "LinUtil/util.h"
#import <UIKit/UIKit.h>
#import "LinWebPlugin.h"
#import "LinConfigParser.h"
#import <objc/message.h>
#import "LinCore/core.h"
#import "AsynResult.h"
#import <JavaScriptCore/JavaScriptCore.h>

//#if DEBUG
//
//@interface WebCache : NSObject
//+(void)empty;
//+(void)setDisabled:(BOOL)arg1;
//@end
//
//#endif


@interface LinWebController()<UIWebViewDelegate>{
@private
    UIWebView * _webView;
    NSURLRequestCachePolicy cachePolicy;//
    NSMutableDictionary * pluginObjects;
    dispatch_once_t _plugin_objects_once_t;// = 0;
}
-(NSString*)pluginAction:(NSString*)name action:(NSString*)action params:(NSString*)params;
@end


///##################################################################################

@interface LinWebURLProtocol : NSURLProtocol

- (void)sendResponseText:(NSString*)result;

@end


@interface LinWebURLResponse : NSHTTPURLResponse
@property NSInteger statusCode;
@end




@implementation LinWebURLResponse
@synthesize statusCode;

- (NSDictionary*)allHeaderFields
{
    return nil;
}

@end

@interface LinWebURLProtocol(){
    UIWebView * webView;
}

@end

@implementation LinWebURLProtocol


+(NSMutableArray *)webs{
    
    static NSMutableArray * _webs;
    static dispatch_once_t _webs_once_t = 0;
    static LinConfigParser * configParser;
    dispatch_once(&_webs_once_t, ^{
        _webs = [[NSMutableArray alloc] init];
        configParser = [[LinConfigParser alloc] init];
    });
    return _webs;
}

+(LinWebController*)webView:(int)flag{
    for (LinWebController * item in LinWebURLProtocol.webs) {
        if (item != nil && item.view.tag == flag) {
            return item;
        }
    }
    return nil;
}


+ (void)registerURLProtocol:(LinWebController*)webView
{
    __weak UIWebView * _webView = webView;
    [LinWebURLProtocol.webs addObject:_webView];
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
    return request;
}

+ (BOOL)canInitWithRequest:(NSURLRequest*)theRequest
{
    NSURL* theUrl = [theRequest URL];
    
    NSString * absoluteString = [theUrl absoluteString];
    
    if([absoluteString rangeOfString:@":0000/"].length != 0){
        return YES;
    }
    return NO;
}

-(void)startLoading{
    
    int flag = [[self.request valueForHTTPHeaderField:@"web-flag"] intValue];
    NSString * name = [self.request valueForHTTPHeaderField:@"plugin"];
    NSString * action = [self.request valueForHTTPHeaderField:@"action"];
    
    NSString * params = [[NSString alloc] initWithData:self.request.HTTPBody encoding:NSUTF8StringEncoding];
    
    
    LinWebController * web = [LinWebURLProtocol webView:flag];
    
    [self sendResponseText:[web pluginAction:name action:action params:params]];
}


- (void)sendResponseText:(NSString*)result
{
    NSData * data = [result dataUsingEncoding:NSUTF8StringEncoding];
    LinWebURLResponse * response = [[LinWebURLResponse alloc] initWithURL:[[self request] URL] MIMEType:@"application/json" expectedContentLength:[data length] textEncodingName:@"UTF-8"];
    response.statusCode = 200;
    
    [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    [[self client] URLProtocol:self didLoadData:data];
    [[self client] URLProtocolDidFinishLoading:self];
}
-(void)stopLoading{
    
}
@end





///##################################################################################

@interface AsynResult(){
    Json * _result;
    //    NSLock * lock;
    AutoResetEvent * set;
}

-(void)setWeb:(LinWebURLProtocol*)web;
-(NSString*)waitResult;

@end

@implementation AsynResult

-(instancetype)init{
    self = [super init];
    if(self){
        //        lock = [[NSLock alloc] init];
        set = [[AutoResetEvent alloc] init];
    }
    return self;
}

-(NSString*)waitResult{
    [set waitOne];
    if (_result != nil) {
        return [_result description];
    }
    return nil;
}

-(void)setResult:(Json *)result{
    _result = result;
    [set set];
}

@end



@implementation LinWebController

-(void)testAlert{
    UIApplication * app =[UIApplication sharedApplication];
    UIWindow * window = app.windows[0];
    
    //    UIScrollView * scrollView = [[UIScrollView alloc] init];
    //    scrollView.backgroundColor = [[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:0.8];
    ////    scrollView.frame = [UIScreen mainScreen].bounds;
    //    scrollView.frame = CGRectMake(0, 0, 300, 300);
    //    scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    //    scrollView.maximumZoomScale = 8;
    //    scrollView.scrollEnabled = TRUE;
    ////    scrollView.delegate = self;
    //    scrollView.backgroundColor = [UIColor blackColor];
    //
    //    UIImageView * imageView = [[UIImageView alloc] init];
    //    imageView.frame = [UIScreen mainScreen].bounds;
    ////    imageView.image = [self waterMark:[UIImage imageWithURLString:images[0]] text:sn];
    //    [scrollView addSubview:imageView];
    ////    _imageView = imageView;
    //
    //    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithAction:^(NSObject * obj) {
    //        [scrollView removeFromSuperview];
    //    }];
    //    [tap setNumberOfTapsRequired:2];
    //    [scrollView addGestureRecognizer:tap];
    
    UIView * view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, 300, 300);
    view.backgroundColor = [UIColor blackColor];
    [window addSubview:view];
}

-(NSString*)actions:(NSString*)action{
    if ([action isEqualToString:@"platform"]) {
        return @"ios";
    }else if ([action isEqualToString:@"productName"]){
        UIDevice * device = [UIDevice currentDevice];
        return device.name;
    }else if ([action isEqualToString:@"versionName"]){
        UIDevice * device = [UIDevice currentDevice];
        return device.systemVersion;
    }else if ([action isEqualToString:@"version"]){
        UIDevice * device = [UIDevice currentDevice];
        return [[NSString alloc] initWithFormat:@"%f",[device.systemVersion floatValue]];
    }else if ([action isEqualToString:@"model"]){
        UIDevice * device = [UIDevice currentDevice];
        return [[NSString alloc] initWithFormat:@"%@",device.model];
    }else if ([action isEqualToString:@"uuid"]){
        //        UIDevice * device = [UIDevice currentDevice];
        //        [self sendResponseText:[[NSString alloc] initWithFormat:@"\"%@\"",@"------------"]];
        return @"------------";
    }
    return nil;
}
+(LinConfigParser *)plugins{
    static dispatch_once_t _plugins_once_t = 0;
    static LinConfigParser * configParser;
    dispatch_once(&_plugins_once_t, ^{
        configParser = [[LinConfigParser alloc] init];
    });
    return configParser;
}
- (LinWebPlugin*)plugin:(NSString*)name{
    if(name == nil){
        return nil;
    }
    name = [name lowercaseString];
    
    dispatch_once(&_plugin_objects_once_t, ^{
        pluginObjects = [[NSMutableDictionary alloc] init];
    });
    
    
    LinWebPlugin * obj = [pluginObjects objectForKey:name];
    if(obj == nil){
        
        LinConfigParser * parser = [LinWebController plugins];
        NSString * className = [parser.plugins objectForKey:name];
        if (className != nil) {
            obj = [[NSClassFromString(className) alloc] initWithWebView:self->_webView];
            if (obj != nil) {
                [pluginObjects setValue:obj forKey:name];
            }
        }
    }
    return obj;
}
-(NSString*)pluginAction:(NSString*)name action:(NSString*)action params:(NSString*)params{
    
    if (name == nil || [name isEqualToString:@""]) {
        return [self actions:action];
    }
    LinWebPlugin * plugin = [self plugin:name];
    id r = nil;
    SEL actionSel = NSSelectorFromString([[NSString alloc] initWithFormat:@"%@:",action]);
    
    NSMethodSignature *signature = [plugin methodSignatureForSelector:actionSel];
    
    if (!signature) {
        actionSel = NSSelectorFromString([[NSString alloc] initWithFormat:@"%@",action]);
        signature = [plugin methodSignatureForSelector:actionSel];
    }
    if (signature) {
        Json * arg = nil;
        if(signature.numberOfArguments > 0) {
            arg = [Json parse:params];
        }
        if(signature.methodReturnLength > 0){
            r = [plugin performSelector:actionSel withObject:arg];
        }else{
            [plugin performSelector:actionSel withObject:arg];
        }
    }
    
    NSString * rString = nil;
    if ([r isKindOfClass:[Json class]]) {
        rString = [r description];
    }else if ([r isKindOfClass:[AsynResult class]]){
        AsynResult * asynResult = (AsynResult*)r;
        rString = [asynResult waitResult];
    }else if(r != nil){
        rString = [[[Json alloc] initWithObject:r] description];
    }else{
        rString = @"{}";
    }
    
    if (rString == nil) {
        rString = @"{}";
    }
    
    return rString;
}

-(void)loadView{
    _webView = [[UIWebView alloc] init];
    _webView.dataDetectorTypes = 0;
    //    let context = self.webView.valueForKeyPath("documentView.webView.mainFrame.javaScriptContext") as! JSContext
    //    JSContext * context = [_webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    //
    //    context[@"IOSBridge"] = ^(JSValue * name,JSValue * action,JSValue * params){
    //        //      return "ok.";
    //        //        NSString * value = @"000";//[[JSValue alloc] init];
    //        ////        [value s]
    //        //        return value;
    //
    //        return [self pluginAction:[name toString] action:[action toString] params:[params toString]];
    //    };
    
    //    context[@"IOSBridge"] = ^() {
    //        NSArray *args = [JSContext currentArguments];
    //        for (id obj in args) {
    //            NSLog(@"%@",obj);
    //        }
    //    };
    
    //     [context objectForKeyedSubscript:@"IOSBridge"] setObject:<#(id)#> forKeyedSubscript:<#(NSObject<NSCopying> *)#>
    
    ////    let logFunction : @convention(block) (String) -> Void =
    ////    {
    ////        (msg: String) in
    ////
    ////        NSLog("Console: %@", msg)
    ////    }
    ////    context.objectForKeyedSubscript("console").setObject(unsafeBitCast(logFunction, AnyObject.self),
    ////                                                         forKeyedSubscript: "log")
    //    context[@"console"][@"log"] = ^(JSValue * msg) {
    //        NSLog(@"JavaScript %@ log message: %@", [JSContext currentContext], msg);
    //    };
    //
    //    context[@"console"][@"error"] = ^(JSValue * msg) {
    //        NSLog(@"JavaScript %@ error message: %@", [JSContext currentContext], msg);
    //    };
    //
    //    context[@"console"][@"trace"] = ^(JSValue * msg) {
    //        NSLog(@"JavaScript %@ trace message: %@", [JSContext currentContext], msg);
    //    };
    //
    //
    //    context.exceptionHandler = ^(JSContext *context, JSValue *exception){
    //        NSLog(@"exception message:%@",exception);
    //    };
    
    
    
    
    self.view = _webView;
    _webView.mediaPlaybackRequiresUserAction = NO;
    
    static int globalWebFlag = 0;
    _webView.tag = ++globalWebFlag;
    
    _webView.delegate = self;
    
    [LinURLCacheProtocol cache:@""];
    
    [NSURLProtocol registerClass:[LinWebURLProtocol class]];
    
    static dispatch_once_t _register_url_protocol = 0;
    dispatch_once(&_register_url_protocol, ^{
        [LinWebURLProtocol registerURLProtocol:self];
    });
    
    
    //    _webView.
    //    cachePolicy = NSURLRequestReturnCacheDataElseLoad;
    
#if DEBUG
    cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    //    [WebCache setDisabled:YES];
    //    [WebCache empty];
    
    //    清除cookies
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        [storage deleteCookie:cookie];
    }
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
#endif
}

-(void)viewDidLoad{
    
    //ios6不支持
    //self.automaticallyAdjustsScrollViewInsets = FALSE;
    UIView * backgroundView = [[UIView alloc] init];
    backgroundView.frame = CGRectMake(0, 0, self.view.bounds.size.width,self.view.bounds.size.height);
    backgroundView.backgroundColor = [[UIColor alloc] initWithRed:0.9 green:0.9 blue:0.9 alpha:0.6];
    backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_webView addSubview:backgroundView];
    [_webView sendSubviewToBack:backgroundView];
    
    UILabel * lable = [[UILabel alloc] init];
    lable.frame = CGRectMake(0, 18, backgroundView.frame.size.width, 40);
    lable.textColor = [[UIColor alloc] initWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    lable.text = @"翡翠吧吧";
    lable.backgroundColor = [UIColor clearColor];
    [backgroundView addSubview:lable];
    
    
    UILabel * copyInfo = [[UILabel alloc] init];
    copyInfo.frame = CGRectMake(0, self.view.bounds.size.height + self.view.bounds.origin.y - 45, backgroundView.frame.size.width, 40);
    copyInfo.textColor = [[UIColor alloc] initWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    copyInfo.textAlignment = NSTextAlignmentCenter;
    copyInfo.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    copyInfo.text = @"Copyright 2014-2015 翡翠吧吧 All rights reserved";
    copyInfo.font = [UIFont fontWithName:@"STHeitiSC-Light" size: 12.0];
    copyInfo.backgroundColor = [UIColor clearColor];
    [backgroundView addSubview:copyInfo];
}


-(void)loadUrl:(NSString *)url{
    if (url == nil) {
        [_webView loadHTMLString:@"error." baseURL:nil];
        return;
    }
    NSURLRequest* appReq = nil;
    if ([url hasPrefix:@"http://"]) {
        appReq = [NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:cachePolicy timeoutInterval:20.0];
    }else{
        
        NSURL * startURL = [NSURL URLWithString:url];
        NSString * startFilePath = pathFor(DocumentsBundle, [startURL path]);
        
        NSURL * appURL = [NSURL fileURLWithPath:startFilePath];
        NSRange r = [url rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"?#"] options:0];
        if(r.location != NSNotFound){
            NSString * queryAndOrFragment = [url substringFromIndex:r.location];
            appURL = [NSURL URLWithString:queryAndOrFragment relativeToURL:appURL];
        }
        appReq = [NSURLRequest requestWithURL:appURL cachePolicy:cachePolicy timeoutInterval:15.0];
    }
    
    [_webView loadRequest:appReq];
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return TRUE;
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    
    NSString * js = [[NSString alloc] initWithFormat:@"window.sessionStorage.setItem(\"__ios-web-flag\",\"%d\");",(int)self.view.tag];
    
    
    [webView stringByEvaluatingJavaScriptFromString:js];
    
    js = [[NSString alloc] initWithFormat:@"window.Object.defineProperty(window,'IOSWebFlag',{value:%d,writable:false,configurable:false,enumerable:false})",(int)self.view.tag];
    
    
    [webView stringByEvaluatingJavaScriptFromString:js];
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
}

@end



@implementation LinWebPlugin

- (instancetype)initWithWebView:(UIWebView *)webView{
    self = [super init];
    if(self){
        self->_webView = webView;
    }
    return self;
}

- (void)handleOpenURL:(NSNotification*)notification{
    
}
- (void)onAppTerminate{
    
}
- (void)onMemoryWarning{
    
}
- (void)onReset{
    
}
- (void)dispose{
    
}

- (id)appDelegate{
    return [UIApplication sharedApplication];
}


@end












/////////////////////////////////////////////////////////////////////////////////////////////
//
//
//
//
/////////////////////////////////////////////////////////////////////////////////////////////


//@implementation LinWebURLProtocol
//
//
//+(NSMutableArray *)webs{
//
//    static NSMutableArray * _webs;
//    static dispatch_once_t _webs_once_t = 0;
//    static LinConfigParser * configParser;
//    dispatch_once(&_webs_once_t, ^{
//        _webs = [[NSMutableArray alloc] init];
//        //[NSURLProtocol registerClass:[LinWebURLProtocol class]];
//        configParser = [[LinConfigParser alloc] init];
//    });
//    return _webs;
//}
//+(LinConfigParser *)plugins{
//    static dispatch_once_t _plugins_once_t = 0;
//    static LinConfigParser * configParser;
//    dispatch_once(&_plugins_once_t, ^{
//        configParser = [[LinConfigParser alloc] init];
//    });
//    return configParser;
//}
//
//+(UIWebView*)webView:(int)flag{
//    for (UIWebView * item in LinWebURLProtocol.webs) {
//        if (item != nil && item.tag == flag) {
//            return item;
//        }
//    }
//    return nil;
//}
//+ (LinWebPlugin*)plugin:(NSString*)name flag:(int)flag{
//    if(name == nil){
//        return nil;
//    }
//    name = [name lowercaseString];
//    static dispatch_once_t _plugin_objects_once_t = 0;
//    static NSMutableDictionary * pluginObjects;
//    dispatch_once(&_plugin_objects_once_t, ^{
//        pluginObjects = [[NSMutableDictionary alloc] init];
//    });
//    NSString * flagObj = [[NSString alloc] initWithFormat:@"%d",flag];
//    NSMutableDictionary * item = [pluginObjects objectForKey:flagObj];
//    if(item == nil){
//        item = [[NSMutableDictionary alloc] init];
//        [pluginObjects setValue:item forKey:flagObj];
//    }
//    LinWebPlugin * obj = [pluginObjects objectForKey:name];
//    if(obj == nil){
//        LinConfigParser * parser = [LinWebURLProtocol plugins];
//        NSString * className = [parser.plugins objectForKey:name];
//        obj = [[NSClassFromString(className) alloc] initWithWebView:[LinWebURLProtocol webView:flag]];
//        [pluginObjects setValue:obj forKey:name];
//    }
//    return obj;
//}
//
//+ (void)registerURLProtocol:(UIWebView*)webView
//{
//    __weak UIWebView * _webView = webView;
//    [LinWebURLProtocol.webs addObject:_webView];
//}
//
//+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
//{
//    return request;
//}
//
//+ (BOOL)canInitWithRequest:(NSURLRequest*)theRequest
//{
//    NSURL* theUrl = [theRequest URL];
//
//    NSString * absoluteString = [theUrl absoluteString];
//    //#if DEBUG
//    //    if ([absoluteString rangeOfString:@"http://init.icloud-analysis.com"].length != 0) {
//    //        return YES;
//    //    }
//    //#endif
//
//    if([absoluteString rangeOfString:@":0000/"].length != 0){
//        return YES;
//    }
//    return NO;
//}
//+(NSString*)actions:(NSString*)action{
//    if ([action isEqualToString:@"platform"]) {
//        //        [self sendResponseText:@"\"ios\""];
//        return @"ios";
//    }else if ([action isEqualToString:@"productName"]){
//        UIDevice * device = [UIDevice currentDevice];
//        //        [self sendResponseText:[[NSString alloc] initWithFormat:@"\"%@\"",device.name]];
//        return device.name;
//    }else if ([action isEqualToString:@"versionName"]){
//        UIDevice * device = [UIDevice currentDevice];
//        //        [self sendResponseText:[[NSString alloc] initWithFormat:@"\"%@\"",device.systemVersion]];
//        return device.systemVersion;
//    }else if ([action isEqualToString:@"version"]){
//        UIDevice * device = [UIDevice currentDevice];
//        //        [self sendResponseText:[[NSString alloc] initWithFormat:@"\"%f\"",[device.systemVersion floatValue]]];
//        return [[NSString alloc] initWithFormat:@"%f",[device.systemVersion floatValue]];
//    }else if ([action isEqualToString:@"model"]){
//        UIDevice * device = [UIDevice currentDevice];
//        //        [self sendResponseText:[[NSString alloc] initWithFormat:@"\"%@\"",device.model]];
//        return [[NSString alloc] initWithFormat:@"%@",device.model];
//    }else if ([action isEqualToString:@"uuid"]){
//        //        UIDevice * device = [UIDevice currentDevice];
//        //        [self sendResponseText:[[NSString alloc] initWithFormat:@"\"%@\"",@"------------"]];
//        return @"------------";
//    }
//    return nil;
//}
//-(void)startLoading{
//    //    __weak LinWebURLProtocol *wself = self;
//    //    [Queue asynQueue:^{
//    //        [wself startLoadingImpl];
//    //    }];
//    //}
//    //
//    //-(void)startLoadingImpl{
//
//    //#if DEBUG
//    //    NSString * absoluteString = [[self.request URL] absoluteString];
//    //    if ([absoluteString rangeOfString:@"http://init.icloud-analysis.com"].length != 0) {
//    //        return;
//    //    }
//    //#endif
//
//    int flag = [[self.request valueForHTTPHeaderField:@"web-flag"] intValue];
//    NSString * name = [self.request valueForHTTPHeaderField:@"plugin"];
//    NSString * action = [self.request valueForHTTPHeaderField:@"action"];
//
//    NSString * params = [[NSString alloc] initWithData:self.request.HTTPBody encoding:NSUTF8StringEncoding];
//
//    [self sendResponseText:[LinWebURLProtocol pluginAction:name action:action params:params flag:flag]];
//}
//
//+(NSString*)pluginAction:(NSString*)name action:(NSString*)action params:(NSString*)params flag:(int)flag{
//
//    if (name == nil || [name isEqualToString:@""]) {
//        return [LinWebURLProtocol actions:action];
//    }
//    LinWebPlugin * plugin = [LinWebURLProtocol plugin:name flag:flag];
//    id r = nil;
//    SEL actionSel = NSSelectorFromString([[NSString alloc] initWithFormat:@"%@:",action]);
//    if([plugin respondsToSelector:actionSel]){
//
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "w"
//        r = [plugin performSelector:actionSel withObject:[Json parse:params]];
//#pragma clang diagnostic pop
//
//    }else{
//        actionSel = NSSelectorFromString([[NSString alloc] initWithFormat:@"%@",action]);
//        if([plugin respondsToSelector:actionSel]){
//            //            NSString * params = [[NSString alloc] initWithData:self.request.HTTPBody encoding:NSUTF8StringEncoding];
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "w"
//            r = [plugin performSelector:actionSel withObject:nil];
//#pragma clang diagnostic pop
//        }else{
//            //            [self sendResponseText:@""];
//            return @"";
//        }
//    }
//
//    //    if ([r isKindOfClass:[NSString class]]) {
//    //        [self sendResponseText:[[[Json alloc] initWithObject:r] description]];
//    //    }
//    //    else
//    NSString * rString = nil;
//    if ([r isKindOfClass:[Json class]]) {
//        //        [self sendResponseText:[r description]];
//        rString = [r description];
//    }else if ([r isKindOfClass:[AsynResult class]]){
//        AsynResult * asynResult = (AsynResult*)r;
//        //[asynResult setWeb:self];
//        rString = [asynResult waitResult];
//    }else if(r != nil){
//        //        [self sendResponseText:[[[Json alloc] initWithObject:r] description]];
//        rString = [[[Json alloc] initWithObject:r] description];
//    }else{
//        //        [self sendResponseText:@"{}"];
//        rString = @"{}";
//    }
//
//    if (rString == nil) {
//        rString = @"{}";
//    }
//
//    return rString;
//}
//
//- (void)sendResponseText:(NSString*)result
//{
//    NSData * data = [result dataUsingEncoding:NSUTF8StringEncoding];
//    LinWebURLResponse * response = [[LinWebURLResponse alloc] initWithURL:[[self request] URL] MIMEType:@"application/json" expectedContentLength:[data length] textEncodingName:@"UTF-8"];
//    response.statusCode = 200;
//
//    [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
//    [[self client] URLProtocol:self didLoadData:data];
//    [[self client] URLProtocolDidFinishLoading:self];
//}
//-(void)stopLoading{
//
//}
//@end


//@interface LinWebURLProtocol : NSURLProtocol
////+ (void)registerURLProtocol;
//
//- (void)sendResponseText:(NSString*)result;
//
//@end
//
//
//@interface LinWebURLResponse : NSHTTPURLResponse
//@property NSInteger statusCode;
//@end
//
//
//
//
//@implementation LinWebURLResponse
//@synthesize statusCode;
//
//- (NSDictionary*)allHeaderFields
//{
//    return nil;
//}
//
//@end
//
//@interface LinWebURLProtocol(){
//    UIWebView * webView;
//}
//
//@end
