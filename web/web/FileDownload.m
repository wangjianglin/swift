////
////  FileDownload.m
////  ses
////
////  Created by lin on 14-7-24.
////
////
//#import <Cordova/CDV.h>
//#import "FileDownload.h"
//#import "AppDelegate.h"
//
//
//@interface FileDownload(){
//    dispatch_queue_t taskQueue;//同步队列任务操作
//    NSString * taskKey;
//}
//
//@property(getter = tasks,setter = setTask:) NSMutableDictionary * tasks;
//
//@end
//
//
//
//@implementation FileDownload
//
//
//-(NSMutableDictionary*)tasks{
//    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
//    id v = [defaults valueForKey:taskKey];
//    if(v == nil){
//        v = [[NSMutableDictionary alloc] init];
//        [defaults setValue:v forKey:taskKey];
//    }
//    NSMutableDictionary * newDict = [[NSMutableDictionary alloc] initWithDictionary:v];
//    return newDict;
//}
//
//-(void)setTask:(NSMutableDictionary *)tasks{
//    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setValue:tasks forKey:taskKey];
//}
//
//-(id)initWithWebView:(UIWebView*)theWebView;{
//    self = [super initWithWebView:theWebView];
////    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(applicationWillEnterForeground:) name:@"applicationWillEnterForeground" object:nil];
////    
////    
////    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(applicationWillEnterForeground:) name:@"applicationWillEnterBackground" object:nil];
//    
//    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
//    //[defaults setValue:[CDVAppPlugin getUUID] forKey:@"uuid_preference"];
//    taskQueue = dispatch_queue_create("com.foreveross.filedownload", nil);
//    taskKey = @"com.foreverfoss.filesownload.key";
//    id v = [defaults valueForKey:taskKey];
//    if(v == nil){
//        v = [[NSMutableDictionary alloc] init];
//        [defaults setValue:v forKey:taskKey];
//    }
//    [self backgroundSession];
//    return self;
//}
//
//- (void)start:(CDVInvokedUrlCommand*)command{
//    [self backgroundSession];
//    CDVPluginResult * pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
//    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
//}
//
//- (void)clear:(CDVInvokedUrlCommand*)command{
//    NSMutableDictionary * dict = self.tasks;
//    [dict removeAllObjects];
//    self.tasks = dict;
//    CDVPluginResult * pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
//    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
//}
//
//- (NSURLSession *)backgroundSession
//
//{
//    
//    //Use dispatch_once_t to create only one background session. If you want more than one session, do with different identifier
//    
//    static NSURLSession *session = nil;
//    
//    static dispatch_once_t onceToken;
//    
//    dispatch_once(&onceToken, ^{
//        
//        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfiguration:gen_uuid2()];
//        configuration.allowsCellularAccess = false;
//        configuration.discretionary = YES;
//        
//        session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
//        
//    });
//    
//    //[configDict setObject:session_id forKey:@"session_id"];
//    
//    return session;
//    
//}
//
//NSString * gen_uuid2()
//{
////    CFUUIDRef cfuuid =CFUUIDCreate(kCFAllocatorDefault);
////    NSString *cfuuidString =(NSString*)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, cfuuid));
////    return cfuuidString;
//    UIDevice* device = [UIDevice currentDevice];
//    return [device uniqueAppInstanceIdentifier];
//}
//
//- (void)downFile:(CDVInvokedUrlCommand*)command{
//    if(command == nil || [command.arguments count] == 0){
//        CDVPluginResult * pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
//        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
//        return;
//    }
//    NSString * url = (NSString *)[command.arguments objectAtIndex:0];
//    //url = [[NSString alloc] initWithString:url];
//    //NSMutableString * url = [[NSMutableString alloc] initWithString:@"ok."];//initWithString:[command.arguments objectAtIndex:0]];
//    //[url appendString:[command.arguments objectAtIndex:0]];
//    NSString * cacheDir = nil;
//    if ([command.arguments count] > 1) {
//        cacheDir = [command.arguments objectAtIndex:1];
//    }
//    NSURL *downloadURL = [NSURL URLWithString:url];
//    
//    NSURLRequest *request = [NSURLRequest requestWithURL:downloadURL];
//    
//    //NSString * sessionId = gen_uuid2();
//    NSURLSession * session = [self backgroundSession];
//    
//    
//    dispatch_sync(taskQueue, ^(){
//        NSMutableDictionary * dict = self.tasks;
//        CDVPluginResult * pluginResult = nil;
//        if ([dict valueForKey:url] == nil) {
//            
//            NSURLSessionDownloadTask * downloadTask = [session downloadTaskWithRequest:request];
//            //downloadTask.description = @"cache";
//            
//            [dict setObject:@"false" forKey:url];
//            if(cacheDir!=nil){
//                [dict setObject:cacheDir forKey:[[NSString alloc] initWithFormat:@"%@-%@", url,@"cacheDir"]];
//            }
//            self.tasks = dict;
//            [downloadTask resume];
//            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
//        }else{
//            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"正在下载中。"];
//        }
//        
//        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
//    });
//    
//    
//    //NSMutableArray * tmp = [session mutableArrayValueForKey:url];
//    
//    
//
//}
//
////下载任务完成,这个方法在下载完成时触发，它包含了已经完成下载任务得 Session Task,Download Task和一个指向临时下载文件得文件路径
//- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
//{
//    NSMutableDictionary * dict = self.tasks;
//    //NSURLSessionDownloadTask * downloadTask = (NSURLSessionDownloadTask*)task;
//    NSString * urlString = [[downloadTask.originalRequest URL] absoluteString];
//    NSString * cacheDir = [dict valueForKey:[[NSString alloc] initWithFormat:@"%@-%@", urlString,@"cacheDir"]];
//    
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSArray *URLs = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
//    NSURL *documentsDirectory = [URLs objectAtIndex:0];
//    NSURL *originalURL = [[downloadTask originalRequest] URL];
//    NSURL *destinationURL = nil;
//    if(cacheDir != nil){
//        destinationURL = [documentsDirectory URLByAppendingPathComponent:cacheDir];
//        [fileManager createDirectoryAtURL:destinationURL withIntermediateDirectories:YES attributes:nil error:nil];
//    }
//    destinationURL = [destinationURL URLByAppendingPathComponent:[originalURL lastPathComponent]];
//    NSError *errorCopy;
//    // For the purposes of testing, remove any esisting file at the destination.
//    [fileManager removeItemAtURL:destinationURL error:NULL];
//    BOOL success = [fileManager copyItemAtURL:location toURL:destinationURL error:&errorCopy];
//    if (success) {
////        dispatch_async(dispatch_get_main_queue(), ^{
////            //download finished - open the pdf
////            
////            //原文下载的苹果的pdf，感觉有点慢，自己又没找到比较大一点的pdf，干脆就放了个mp3歌曲在自己服务器上，所以下载完就播放mp3吧
////            //            self.documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:destinationURL];
////            //            // Configure Document Interaction Controller
////            //            [self.documentInteractionController setDelegate:self];
////            //            // Preview PDF
////            //            [self.documentInteractionController presentPreviewAnimated:YES];
////            //            self.progressView.hidden = YES;
////            
////            //播放音乐
////            //self.player = [AVPlayer playerWithURL:destinationURL];
////            //[self.player play];
////            
////            
////        });
//    } else {
////        NSLog(@"复制文件发生错误: %@", [errorCopy localizedDescription]);
//    }
//}
//
//
//-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
//    //[task response].
//    NSURLSessionDownloadTask * downloadTask = (NSURLSessionDownloadTask*)task;
//    NSString * urlString = [[downloadTask.originalRequest URL] absoluteString];
//    NSLog(@"url:%@",urlString);
//    NSMutableDictionary * dict = self.tasks;
////    if (error != nil) {暂不处理错误
////        //error.
////        id v = [error.userInfo objectForKey:@""];
////    }
//    [dict removeObjectForKey:urlString];
//    [dict removeObjectForKey:[[NSString alloc] initWithFormat:@"%@-%@", urlString,@"cacheDir"]];
//    self.tasks = dict;
//}
//
//-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data{
//    NSLog(@"OK.");
//}
//
//-(void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session{
//    NSLog(@"OK.");
////    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
////    if (appDelegate.backgroundSessionCompletionHandler) {
////        void (^completionHandler)() = appDelegate.backgroundSessionCompletionHandler;
////        appDelegate.backgroundSessionCompletionHandler = nil;
////        completionHandler();
////    }
//}
//
//@end
