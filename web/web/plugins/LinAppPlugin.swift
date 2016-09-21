//
//  LinAppPlugin.swift
//  LinWeb
//
//  Created by lin on 9/19/16.
//  Copyright © 2016 lin. All rights reserved.
//

import UIKit
import LinUtil
import AssetsLibrary;


private class __LinAppPlugin_UIAlertView : UIAlertView,UIAlertViewDelegate{
    fileprivate var alertCompletionHandler: (() -> Void)!;
    fileprivate var confirmCompletionHandler: ((Bool) -> Void)!;
    
    fileprivate var type:Int = 0;
    
    public func alertView(_ alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int){
//        let alert = alertView as! __LineWKWebView_UIAlertView;
        if self.type == 0 {
            self.alertCompletionHandler();
            return;
        }
        
        if self.type == 1{
            if buttonIndex == 0 {
                self.confirmCompletionHandler(false);
            }else{
                self.confirmCompletionHandler(true);
            }
        }
    }
}

public class LinAppPlugin : LinAbstractWebPlugin {
   
    
    public func copy(_ args:Json){
        let pasateboard = UIPasteboard.general;
        pasateboard.setPersistent(true);
        pasateboard.string = args["content"].asString;
    }
    

    private func drawInfo(logoView:UIView,text:String?){
        
        let logo_size:CGFloat = 35.0;
        let marginLeft:CGFloat = 10.0;
        let marginTop:CGFloat = 20.0;
        let color = UIColor(red: 0.4, green: 0.7, blue: 0.4, alpha: 0.9);
        //自绘制图标中心点
        let pathCenter = CGPoint(x: logoView.frame.size.width/2, y: logoView.frame.size.height/2 - 50 + marginTop);
        let path = UIBezierPath(arcCenter: pathCenter, radius: logo_size, startAngle: 0, endAngle: CGFloat(M_PI * 2.0), clockwise: true);
        
        path.lineCapStyle = CGLineCap.round;
        path.lineJoinStyle = CGLineJoin.round;
    
        
        let x = logoView.frame.size.width / 2.5 + 5;
        let y = logoView.frame.size.height / 2 - 45 + marginTop;
        
        //勾的起点
        path.move(to: CGPoint(x: x+marginLeft, y: y));
        //勾的最底端
        path.addLine(to: CGPoint(x: x+10+marginLeft, y: y+10));
        //勾的最上端
        path.addLine(to: CGPoint(x: x+35+marginLeft, y: y-20));
        
        //新建图层——绘制上面的圆圈和勾
        let layer = CAShapeLayer();
        layer.fillColor = UIColor.clear.cgColor;
        layer.strokeColor = color.cgColor;
        layer.lineWidth = 5;
        layer.path = path.cgPath;
        
        let animation = CABasicAnimation(keyPath: NSStringFromSelector(#selector(getter: CAShapeLayer.strokeEnd)));
        animation.fromValue = 0;
        animation.toValue = 1;
        animation.duration = 0.5;
        layer.add(animation, forKey: NSStringFromSelector(#selector(getter: CAShapeLayer.strokeEnd)));
        
        logoView.layer .addSublayer(layer);
        
        if let text = text {
            let label = UILabel();
            label.backgroundColor =  UIColor.clear;
            label.textColor = color;
            label.text = text;
            label.font = UIFont.boldSystemFont(ofSize: 20);
            label.frame = CGRect(x: 0, y: 50, width: logoView.frame.size.width, height: logoView.frame.size.height - 50);
            label.autoresizingMask = UIViewAutoresizing(rawValue: UIViewAutoresizing.flexibleWidth.rawValue | UIViewAutoresizing.flexibleTopMargin.rawValue);
            label.textAlignment = NSTextAlignment.center;
            logoView.addSubview(label);
        }
    }
    
    public func info(_ args:Json){
        
        Queue.mainQueue {
            self.infoImpl(args);
        }
    }
    
    
    private func infoImpl(_ args:Json){
    //    UIApplication * app =[UIApplication sharedApplication];
    //    UIWindow * window = app.windows[0];
        let app = UIApplication.shared;
        let window = app.windows[0];
    
    //    UIView * view = [[UIView alloc] init];
        let view = UIView();
        view.frame = UIScreen.main.bounds;
        view.autoresizingMask = UIViewAutoresizing.init(rawValue: UIViewAutoresizing.flexibleWidth.rawValue | UIViewAutoresizing.flexibleHeight.rawValue);
        view.backgroundColor = UIColor.clear;
        
        window.addSubview(view);
        
        
        
        self.drawInfo(logoView: view, text: args["text"].asString);
        
        Queue.asynQueue {
            Thread.sleep(forTimeInterval: 1);
            Queue.mainQueue {
                view.removeFromSuperview();
            }
            
        }
    
    }

    
    public func version()->String{
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String;
    }
    
    public func identifier()->String{
        return Bundle.main.object(forInfoDictionaryKey: kCFBundleIdentifierKey as String) as! String;
    }
    
    public func build()->String{
        return Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as! String;
    }
    
    
    public func saveImage(_ args:Json){
        
        let imageString = args["image"].asString;
        
        let libray = ALAssetsLibrary();
//        let image = UIImage.in
    //
    //    //    __block Json * result = nil;
    //
    //    ALAssetsLibrary * libray = [[ALAssetsLibrary alloc] init];
    //
    //    UIImage * image = [self waterMark:[UIImage imageWithURLString:imageString] text:sn];
    //
    //    //        AutoResetEvent * set = [[AutoResetEvent alloc] init];
    //
    //    [Queue asynQueue:^{
    //    [libray writeImageToSavedPhotosAlbum:image.CGImage albumName:@"翡翠吧吧" metadata:nil completion:^(NSURL *url, NSError *error) {
    //
    //    //                if (error != nil) {
    //    //                    result = [Json parse:@"false"];
    //    //                }else{
    //    //                    result = [Json parse:@"true"];
    //    //                }
    //    //                [set set];
    //    }];
    //    }];
    //    
    //    //[set waitOne];
    //    return nil;
    }
    
    
    public func alert(_ args:Json)->AsynResult{
        let result = AsynResult();
        Queue.mainQueue {
            let alertView = __LinAppPlugin_UIAlertView.init(title: args["title"].asString, message: args["message"].asString, delegate: nil, cancelButtonTitle: args["ok"].asString("确认"));
            alertView.delegate = alertView;
            alertView.type = 0;
            alertView.alertCompletionHandler = {
                result.setResult();
            }
            alertView.show();
        }
        return result;
    }
    
    public func confirm(_ args:Json)->AsynResult{
        let result = AsynResult();
        Queue.mainQueue {
            let alertView = __LinAppPlugin_UIAlertView.init(title: args["title"].asString(""), message: args["message"].asString(""), delegate: nil, cancelButtonTitle: args["cancel"].asString("取消"), otherButtonTitles: args["ok"].asString("确认"));
            alertView.delegate = alertView;
            alertView.type = 1;
            alertView.confirmCompletionHandler = {(r) in
                result.setResult(r);
            }
            alertView.show();
        }
        return result;
    }
    
    public func openUrl(_ args:Json){
        if let url = URL.init(string: args["url"].asString("")){
            UIApplication.shared.openURL(url)
        }
    }
}


//
//-(instancetype)initWithWebView:(UIWebView *)webView{
//    self = [super initWithWebView:webView];
//    if(self){
//        _label = [[UILabel alloc] init];
//        _color = [[UIColor alloc] initWithRed:0.5 green:0.5 blue:0.5 alpha:1];
//        //_color = [UIColor redColor];
//        //_font = [UIFont systemFontOfSize:22];
//        _font = [UIFont boldSystemFontOfSize:22];
//        _label.font = _font;
//    }
//    return self;
//}
//
//

//
//

//-(UIImage *)waterMark:(UIImage *)image text:(NSString*)text{
//    
//    
//    UIGraphicsBeginImageContext(image.size);
//    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
//    
//    CGContextRef contextRef = UIGraphicsGetCurrentContext();
//    
//    CGContextTranslateCTM(contextRef, 0, image.size.height);  //画布的高度
//    CGContextScaleCTM(contextRef, 1.0, -1.0);  //画布翻转
//    
//    [_color set];
//    CGContextTranslateCTM(contextRef, 0, image.size.height);
//    CGContextScaleCTM(contextRef, 1.0, -1.0);
//    
//    _label.text = text;
//    CGContextSetBlendMode(contextRef,kCGBlendModeColorBurn);
//    CGSize textSize = [_label sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
//    
//    [text drawInRect:CGRectMake(image.size.width - textSize.width - 20, image.size.height - textSize.height - 10, textSize.width, textSize.height) withFont:_font];
//    
//    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return newImage;
//}
//

////-(id)initWithWebView:(UIWebView*)theWebView;{
////    self = [super initWithWebView:theWebView];
////    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(applicationWillEnterForeground:) name:@"applicationWillEnterForeground" object:nil];
////
////
////    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(applicationWillEnterForeground:) name:@"applicationWillEnterBackground" object:nil];
////
////    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
////    [defaults setValue:[CDVAppPlugin getUUID] forKey:@"uuid_preference"];
////
////    return self;
////}
////
////-(void)applicationWillEnterForeground:(NSNotification*) notification{
////    [self.commandDelegate evalJs:@"App.fireEnterForegroundListener();"];
////}
////
////-(void)applicationWillEnterBackground:(NSNotification*) notification{
////    [self.commandDelegate evalJs:@"App.fireEnterBackgroundListener();"];
////}
////
////- (void)createDocumentDir:(CDVInvokedUrlCommand*)command{
////    CDVPluginResult * pluginResult = nil;
////    if([command.arguments count] == 0){
////        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_IO_EXCEPTION];
////        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
////        return;
////    }
////
////    NSString * dir = [command.arguments objectAtIndex:0];
////    NSString * dirString = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
////
////    dirString = [[NSString alloc] initWithFormat:@"%@/%@",dirString,dir];
////
////    [[NSFileManager defaultManager] createDirectoryAtPath:dirString withIntermediateDirectories:YES attributes:nil error:nil];
////
////    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
////    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
////    return;
////
////}
////- (void)applicationIconBadgeNumber:(CDVInvokedUrlCommand*)command{
////    CDVPluginResult * pluginResult = nil;
////    if([command.arguments count] == 0){
////        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_IO_EXCEPTION];
////        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
////        return;
////    }
////
////    //NSInteger * number = [command.arguments objectAtIndex:0];
////    NSString * numberString = [command.arguments objectAtIndex:0];
////    NSInteger number = [numberString intValue];
//////    NSString * dir = [command.arguments objectAtIndex:0];
//////    NSString * dirString = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//////
//////    dirString = [[NSString alloc] initWithFormat:@"%@/%@",dirString,dir];
//////
//////    [[NSFileManager defaultManager] createDirectoryAtPath:dirString withIntermediateDirectories:YES attributes:nil error:nil];
////    [UIApplication sharedApplication].applicationIconBadgeNumber = number;
////
////    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
////    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
////    return;
////
////}
////
////
////- (void)openURL:(CDVInvokedUrlCommand*)command{
////    CDVPluginResult * pluginResult = nil;
////    if([command.arguments count] > 0){
////        NSString * url = [command.arguments objectAtIndex:0];
////        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
////        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
////        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
////        return;
////    }
////    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_IO_EXCEPTION];
////    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
////}
////
////- (void)getDocumentFiles:(CDVInvokedUrlCommand*)command{
////    //NSString * dirString = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
////    //[NSFileManager defaultManager]
////    if([command.arguments count] == 0){
////
////    }
////    NSString * path = [command.arguments objectAtIndex:0];
////    NSFileManager *fileManager = [NSFileManager defaultManager];
////    //在这里获取应用程序Documents文件夹里的文件及文件夹列表
////    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
////    NSString *documentDir = [[NSString alloc] initWithFormat:@"%@/%@" ,[documentPaths objectAtIndex:0],path];
////
////    NSError *error = nil;
////    NSArray *fileList = [[NSArray alloc] init];
////    //fileList便是包含有该文件夹下所有文件的文件名及文件夹名的数组
////    fileList = [fileManager contentsOfDirectoryAtPath:documentDir error:&error];
////    //以下这段代码则可以列出给定一个文件夹里的所有子文件夹名
////    NSMutableArray *dirArray = [[NSMutableArray alloc] init];
//////    BOOL isDir = NO;
////    //在上面那段程序中获得的fileList中列出文件夹名
////    NSMutableString * fileString =  [[NSMutableString alloc] init];
////    [fileString appendString:@"["];
////    for (NSString *file in fileList) {
////        [fileString appendString:@"'"];
////        NSRange range = NSMakeRange(0, [file length]);
////        NSMutableString * tmpFile = [[NSMutableString alloc] initWithString:file];
////        [tmpFile replaceOccurrencesOfString:@"'" withString:@"\\'" options:NSLiteralSearch range:range];
////        [fileString appendString:tmpFile];
////        [fileString appendString:@"',"];
////    }
////    [fileString appendString:@"'']"];
////    NSLog(@"Every Thing in the dir:%@",fileList);
////    NSLog(@"All folders:%@",dirArray);
////    CDVPluginResult * pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:fileString];
////    //pluginResult.message = dirString;
////    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
////}
////- (void)getDir:(CDVInvokedUrlCommand*)command{
////    CDVPluginResult * pluginResult = nil;
////    if([command.arguments count] == 0){
////        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_IO_EXCEPTION];
////        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
////        return;
////    }
////    NSString * dir = [command.arguments objectAtIndex:0];
////    //NSString * callback = [command.arguments objectAtIndex:1];
////    NSString * dirString = nil;
////    if([dir compare:@"library"] == NSOrderedSame){
////        dirString = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
////    }else if([dir compare:@"tmp"] == NSOrderedSame){
////        dirString = NSTemporaryDirectory();
////    }else if([dir compare:@"cache"] == NSOrderedSame){
////        dirString = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
////    }else if([dir compare:@"document"] == NSOrderedSame){
////        dirString = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
////    }
////
////    if(dirString == nil){
////        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_IO_EXCEPTION];
////        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
////        return;
////    }
////
////    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:dirString];
////    //pluginResult.message = dirString;
////    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
////    //[self.commandDelegate sendPluginResult:pluginResult callbackId:callback];
////    return;
////    //if([dir compare:@"document"]
////}
////
////+ (NSString*)getUUID{
////    KeychainUtil * keychain = [[KeychainUtil alloc] initWithService:@"com.foreveross.App"];
////    NSString * uuid = [keychain load:@"uuid"];
////    if(uuid == nil){
////        uuid = gen_uuid();
////        [keychain save:@"uuid" data:uuid];
////    }
////    return uuid;
////}
////
//////得到设备的UUID
////- (void)uuid:(CDVInvokedUrlCommand*)command{
////    NSString * uuid = [CDVAppPlugin getUUID];
////    CDVPluginResult * plauginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:uuid];
////    [self.commandDelegate sendPluginResult:plauginResult callbackId:command.callbackId];
////}
////
////NSString * gen_uuid()
////{
////    CFUUIDRef cfuuid =CFUUIDCreate(kCFAllocatorDefault);
////    NSString *cfuuidString =(NSString*)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, cfuuid));
////    return cfuuidString;
////}
////
////- (void)notification:(CDVInvokedUrlCommand*)command{
////    //int hm=20;
////    CDVPluginResult * pluginResult = nil;
////    if([command.arguments count] == 0){
////        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
////        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
////        return;
////    }
////    NSString * info = [command.arguments objectAtIndex:0];
////
////    //建立后台消息对象
////    UILocalNotification *notification=[[UILocalNotification alloc] init];
////    if (notification!=nil)
////    {
////        //notification.repeatCalendar
////        //notification.repeatInterval=NSDayCalendarUnit;
////        notification.repeatInterval=0;
////        //notification.fireDate=[now1 dateByAddingTimeInterval:hm];//距现在多久后触发代理方法
////        notification.timeZone=[NSTimeZone defaultTimeZone];
////        //notification.soundName = @"tap.aif";
////        notification.soundName = UILocalNotificationDefaultSoundName;
////        //notification.alertBody = [NSString stringWithFormat:NSLocalizedString(@"你设置的时间是：%i ： %i .",nil),hm ,hm];
////        notification.alertBody = info;
////        if([command.arguments count]>1){
////            NSString * time = [command.arguments objectAtIndex:1];
////            double interval = [time doubleValue]/1000;
////            NSDate * date = [[NSDate alloc] initWithTimeIntervalSince1970:interval];
////            notification.fireDate = date;
////            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
////        }else{
////            [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
////        }
////        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
////        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
////    }else{
////        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
////        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
////    }
////}
////
////- (void)cancelAllLocalNotifications:(CDVInvokedUrlCommand*)command{
////    [[UIApplication sharedApplication] cancelAllLocalNotifications];
////    CDVPluginResult * plugResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
////    [self.commandDelegate sendPluginResult:plugResult callbackId:command.callbackId];
////}
////
////
////- (void)version:(CDVInvokedUrlCommand*)command{
////    NSString * ver = [NSString stringWithFormat:@"%@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
////    CDVPluginResult * plugResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:ver];
////    [self.commandDelegate sendPluginResult:plugResult callbackId:command.callbackId];
////}
//@end
