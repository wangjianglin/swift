//
//  LinAppPlugin.m
//  web
//
//  Created by lin on 14-6-27.
//
//

#import "LinAppPlugin.h"
#import <UIKit/UIKit.h>
#import <Security/Security.h>
#import "KeychainUtil.h"
#import <EventKit/EventKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "LinCore/core.h"
#import "LinUtil/util.h"
#import "AsynResult.h"

@interface LinAppPlugin(){
    //    UIImageView * _imageView;
    UILabel * _label;
    UIColor * _color;
    UIFont * _font;
}

@end

@implementation LinAppPlugin

-(instancetype)initWithWebView:(UIWebView *)webView{
    self = [super initWithWebView:webView];
    if(self){
        _label = [[UILabel alloc] init];
        _color = [[UIColor alloc] initWithRed:0.5 green:0.5 blue:0.5 alpha:1];
        //_color = [UIColor redColor];
        //_font = [UIFont systemFontOfSize:22];
        _font = [UIFont boldSystemFontOfSize:22];
        _label.font = _font;
    }
    return self;
}

-(void) drawRight:(UIView*)_logoView text:(NSString*)text
{
    CGFloat Logo_Size = 35.0;
//    [self logoInit];
    
    CGFloat marginLeft = 10.0;
    CGFloat marginTop = 20.0;
    UIColor * color = [[UIColor alloc] initWithRed:0.4 green:0.7 blue:0.4 alpha:0.9];
    //自绘制图标中心点
    CGPoint pathCenter = CGPointMake(_logoView.frame.size.width/2, _logoView.frame.size.height/2 - 50 + marginTop);
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:pathCenter radius:Logo_Size startAngle:0 endAngle:M_PI*2 clockwise:YES];
    
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineCapRound;
    
    
    CGFloat x = _logoView.frame.size.width/2.5 + 5;
    CGFloat y = _logoView.frame.size.height/2 - 45 + marginTop;
    //勾的起点
    [path moveToPoint:CGPointMake(x + marginLeft, y)];
    //勾的最底端
    CGPoint p1 = CGPointMake(x+10 + marginLeft, y+ 10);
    [path addLineToPoint:p1];
    //勾的最上端
    CGPoint p2 = CGPointMake(x+35 + marginLeft,y-20);
    [path addLineToPoint:p2];
    //新建图层——绘制上面的圆圈和勾
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.fillColor = [UIColor clearColor].CGColor;
//    layer.strokeColor = [UIColor greenColor].CGColor;
    layer.strokeColor = color.CGColor;
    layer.lineWidth = 5;
    layer.path = path.CGPath;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:NSStringFromSelector(@selector(strokeEnd))];
    animation.fromValue = @0;
    animation.toValue = @1;
    animation.duration = 0.5;
    [layer addAnimation:animation forKey:NSStringFromSelector(@selector(strokeEnd))];
    
    [_logoView.layer addSublayer:layer];
    
    if (text == nil || [text isEqualToString:@""]) {
        return;
    }
    UILabel * label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = color;
    label.text = text;
//    [label setTintColor:color];
    label.font = [UIFont boldSystemFontOfSize:20];
    
//    CGFloat oy = _logoView.frame.size.height / 2.0 + 20;
    CGFloat oy = 50;
    label.frame = CGRectMake(0, oy, _logoView.frame.size.width, _logoView.frame.size.height - oy);
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewContentModeTop;
    label.textAlignment = NSTextAlignmentCenter;
    [_logoView addSubview:label];
}

-(Json*)info:(Json *)args{
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
    view.frame = [UIScreen mainScreen].bounds;
    view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    view.backgroundColor = [UIColor clearColor];
    [window addSubview:view];
    [self drawRight:view text:args[@"text"].asString];
    
    
    __weak UIView * remvoeView = view;
    [Queue asynThread:^{
        [NSThread sleepForTimeInterval:1];
        [remvoeView removeFromSuperview];
    }];
    return [[Json alloc] initWithObject:@""];
}

-(Json *)version:(Json *)args{
    //    NSString * ver = [NSString stringWithFormat:@"%@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
    NSString * ver = [NSString stringWithFormat:@"%@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
    
    
    return [[Json alloc] initWithObject:ver];
}

-(Json *)identifier:(Json *)args{
    NSString * ver = [NSString stringWithFormat:@"%@",[[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleIdentifierKey]];
    return [[Json alloc] initWithObject:ver];
}

-(Json *)bulid:(Json *)args{
    NSString * ver = [NSString stringWithFormat:@"%@",[[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey]];
    return [[Json alloc] initWithObject:ver];
}


-(Json *)saveImage:(Json *)args{

    NSString * sn = args[@"sn"].asString;
    NSString * imageString = args[@"image"].asString;
    
//    __block Json * result = nil;
    
        ALAssetsLibrary * libray = [[ALAssetsLibrary alloc] init];
        
    UIImage * image = [self waterMark:[UIImage imageWithURLString:imageString] text:sn];
        
//        AutoResetEvent * set = [[AutoResetEvent alloc] init];
    
        [Queue asynQueue:^{
            [libray writeImageToSavedPhotosAlbum:image.CGImage albumName:@"翡翠吧吧" metadata:nil completion:^(NSURL *url, NSError *error) {
            
//                if (error != nil) {
//                    result = [Json parse:@"false"];
//                }else{
//                    result = [Json parse:@"true"];
//                }
//                [set set];
            }];
        }];
        
        //[set waitOne];
    return nil;
}
-(UIImage *)waterMark:(UIImage *)image text:(NSString*)text{
    
    
    UIGraphicsBeginImageContext(image.size);
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(contextRef, 0, image.size.height);  //画布的高度
    CGContextScaleCTM(contextRef, 1.0, -1.0);  //画布翻转
    
    [_color set];
    CGContextTranslateCTM(contextRef, 0, image.size.height);
    CGContextScaleCTM(contextRef, 1.0, -1.0);
    
    _label.text = text;
    CGContextSetBlendMode(contextRef,kCGBlendModeColorBurn);
    CGSize textSize = [_label sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
    
    [text drawInRect:CGRectMake(image.size.width - textSize.width - 20, image.size.height - textSize.height - 10, textSize.width, textSize.height) withFont:_font];
    
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(Json *)copy:(Json *)args{
    UIPasteboard * pasateboard = [UIPasteboard generalPasteboard];
    pasateboard.persistent = TRUE;
    pasateboard.string = args[@"content"].asString;
//        [pasteboard setData:[content dataUsingEncoding:NSUTF8StringEncoding] forPasteboardType:@"public.text"];//kUTTypePNG
    return [[Json alloc] initWithObject:[[NSNumber alloc] initWithBool:TRUE]];
    
}
-(Json*)alert:(Json*)args{
    
    AutoResetEvent * set = [[AutoResetEvent alloc] init];
    __block __weak AutoResetEvent * _set = set;
    __block __weak Json* _args = args;
    [Queue mainQueue:^{
        
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:_args[@"title"].asString message:_args[@"message"].asString delegate:nil cancelButtonTitle:[_args[@"button"] asString:@"确认"] otherButtonTitles:nil];
        alertView.clickedButtonAtIndexAction = ^(UIAlertView * alertView, NSInteger buttonIndex){
            [_set set];
        };
        [alertView show];
    }];
    [set waitOne];
    return nil;
}

-(AsynResult*)confirm:(Json*)args{
//-(Json*)confirm:(Json*)args{
//    NSLog(@"%@",[NSThread currentThread]);
    
//    __block AutoResetEvent * are = [[AutoResetEvent alloc] init];
//    
//    __block BOOL result = FALSE;
    __block AsynResult * asynResult = [[AsynResult alloc] init];
//    NSLog(@"222 %@",[NSThread currentThread]);
    [Queue mainQueue:^{
//        NSLog(@"111 %@",[NSThread currentThread]);
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:[args[@"message"] asString:@"" ] delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
        alert.clickedButtonAtIndexAction = ^(UIAlertView * alertView, NSInteger buttonIndex){
            
            if (buttonIndex == 1){
//                result = TRUE;
                [asynResult setResult:[[Json alloc] initWithObject:[[NSNumber alloc] initWithBool:TRUE]]];
            }else{
                [asynResult setResult:[[Json alloc] initWithObject:[[NSNumber alloc] initWithBool:FALSE]]];
            }
//            [are set];
        };
        [alert show];
    }];
    

//    [are waitOne];
    
//    return [[Json alloc] initWithObject:[[NSNumber alloc] initWithBool:FALSE]];
    return asynResult;
}

-(Json*)openUrl:(Json*)args{
    
    NSString * url = args[@"url"].asString;
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    
    return nil;
}
//-(id)initWithWebView:(UIWebView*)theWebView;{
//    self = [super initWithWebView:theWebView];
//    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(applicationWillEnterForeground:) name:@"applicationWillEnterForeground" object:nil];
//    
//    
//    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(applicationWillEnterForeground:) name:@"applicationWillEnterBackground" object:nil];
//    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setValue:[CDVAppPlugin getUUID] forKey:@"uuid_preference"];
//    
//    return self;
//}
//
//-(void)applicationWillEnterForeground:(NSNotification*) notification{
//    [self.commandDelegate evalJs:@"App.fireEnterForegroundListener();"];
//}
//
//-(void)applicationWillEnterBackground:(NSNotification*) notification{
//    [self.commandDelegate evalJs:@"App.fireEnterBackgroundListener();"];
//}
//
//- (void)createDocumentDir:(CDVInvokedUrlCommand*)command{
//    CDVPluginResult * pluginResult = nil;
//    if([command.arguments count] == 0){
//        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_IO_EXCEPTION];
//        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
//        return;
//    }
//    
//    NSString * dir = [command.arguments objectAtIndex:0];
//    NSString * dirString = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    
//    dirString = [[NSString alloc] initWithFormat:@"%@/%@",dirString,dir];
//    
//    [[NSFileManager defaultManager] createDirectoryAtPath:dirString withIntermediateDirectories:YES attributes:nil error:nil];
//    
//    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
//    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
//    return;
//    
//}
//- (void)applicationIconBadgeNumber:(CDVInvokedUrlCommand*)command{
//    CDVPluginResult * pluginResult = nil;
//    if([command.arguments count] == 0){
//        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_IO_EXCEPTION];
//        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
//        return;
//    }
//    
//    //NSInteger * number = [command.arguments objectAtIndex:0];
//    NSString * numberString = [command.arguments objectAtIndex:0];
//    NSInteger number = [numberString intValue];
////    NSString * dir = [command.arguments objectAtIndex:0];
////    NSString * dirString = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
////    
////    dirString = [[NSString alloc] initWithFormat:@"%@/%@",dirString,dir];
////    
////    [[NSFileManager defaultManager] createDirectoryAtPath:dirString withIntermediateDirectories:YES attributes:nil error:nil];
//    [UIApplication sharedApplication].applicationIconBadgeNumber = number;
//    
//    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
//    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
//    return;
//    
//}
//
//
//- (void)openURL:(CDVInvokedUrlCommand*)command{
//    CDVPluginResult * pluginResult = nil;
//    if([command.arguments count] > 0){
//        NSString * url = [command.arguments objectAtIndex:0];
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
//        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
//        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
//        return;
//    }
//    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_IO_EXCEPTION];
//    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
//}
//
//- (void)getDocumentFiles:(CDVInvokedUrlCommand*)command{
//    //NSString * dirString = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    //[NSFileManager defaultManager]
//    if([command.arguments count] == 0){
//        
//    }
//    NSString * path = [command.arguments objectAtIndex:0];
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    //在这里获取应用程序Documents文件夹里的文件及文件夹列表
//    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentDir = [[NSString alloc] initWithFormat:@"%@/%@" ,[documentPaths objectAtIndex:0],path];
//    
//    NSError *error = nil;
//    NSArray *fileList = [[NSArray alloc] init];
//    //fileList便是包含有该文件夹下所有文件的文件名及文件夹名的数组
//    fileList = [fileManager contentsOfDirectoryAtPath:documentDir error:&error];
//    //以下这段代码则可以列出给定一个文件夹里的所有子文件夹名
//    NSMutableArray *dirArray = [[NSMutableArray alloc] init];
////    BOOL isDir = NO;
//    //在上面那段程序中获得的fileList中列出文件夹名
//    NSMutableString * fileString =  [[NSMutableString alloc] init];
//    [fileString appendString:@"["];
//    for (NSString *file in fileList) {
//        [fileString appendString:@"'"];
//        NSRange range = NSMakeRange(0, [file length]);
//        NSMutableString * tmpFile = [[NSMutableString alloc] initWithString:file];
//        [tmpFile replaceOccurrencesOfString:@"'" withString:@"\\'" options:NSLiteralSearch range:range];
//        [fileString appendString:tmpFile];
//        [fileString appendString:@"',"];
//    }
//    [fileString appendString:@"'']"];
//    NSLog(@"Every Thing in the dir:%@",fileList);
//    NSLog(@"All folders:%@",dirArray);
//    CDVPluginResult * pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:fileString];
//    //pluginResult.message = dirString;
//    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
//}
//- (void)getDir:(CDVInvokedUrlCommand*)command{
//    CDVPluginResult * pluginResult = nil;
//    if([command.arguments count] == 0){
//        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_IO_EXCEPTION];
//        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
//        return;
//    }
//    NSString * dir = [command.arguments objectAtIndex:0];
//    //NSString * callback = [command.arguments objectAtIndex:1];
//    NSString * dirString = nil;
//    if([dir compare:@"library"] == NSOrderedSame){
//        dirString = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    }else if([dir compare:@"tmp"] == NSOrderedSame){
//        dirString = NSTemporaryDirectory();
//    }else if([dir compare:@"cache"] == NSOrderedSame){
//        dirString = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    }else if([dir compare:@"document"] == NSOrderedSame){
//        dirString = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    }
//
//    if(dirString == nil){
//        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_IO_EXCEPTION];
//        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
//        return;
//    }
//    
//    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:dirString];
//    //pluginResult.message = dirString;
//    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
//    //[self.commandDelegate sendPluginResult:pluginResult callbackId:callback];
//    return;
//    //if([dir compare:@"document"]
//}
//
//+ (NSString*)getUUID{
//    KeychainUtil * keychain = [[KeychainUtil alloc] initWithService:@"com.foreveross.App"];
//    NSString * uuid = [keychain load:@"uuid"];
//    if(uuid == nil){
//        uuid = gen_uuid();
//        [keychain save:@"uuid" data:uuid];
//    }
//    return uuid;
//}
//
////得到设备的UUID
//- (void)uuid:(CDVInvokedUrlCommand*)command{
//    NSString * uuid = [CDVAppPlugin getUUID];
//    CDVPluginResult * plauginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:uuid];
//    [self.commandDelegate sendPluginResult:plauginResult callbackId:command.callbackId];
//}
//
//NSString * gen_uuid()
//{
//    CFUUIDRef cfuuid =CFUUIDCreate(kCFAllocatorDefault);
//    NSString *cfuuidString =(NSString*)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, cfuuid));
//    return cfuuidString;
//}
//
//- (void)notification:(CDVInvokedUrlCommand*)command{
//    //int hm=20;
//    CDVPluginResult * pluginResult = nil;
//    if([command.arguments count] == 0){
//        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
//        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
//        return;
//    }
//    NSString * info = [command.arguments objectAtIndex:0];
//    
//    //建立后台消息对象
//    UILocalNotification *notification=[[UILocalNotification alloc] init];
//    if (notification!=nil)
//    {
//        //notification.repeatCalendar
//        //notification.repeatInterval=NSDayCalendarUnit;
//        notification.repeatInterval=0;
//        //notification.fireDate=[now1 dateByAddingTimeInterval:hm];//距现在多久后触发代理方法
//        notification.timeZone=[NSTimeZone defaultTimeZone];
//        //notification.soundName = @"tap.aif";
//        notification.soundName = UILocalNotificationDefaultSoundName;
//        //notification.alertBody = [NSString stringWithFormat:NSLocalizedString(@"你设置的时间是：%i ： %i .",nil),hm ,hm];
//        notification.alertBody = info;
//        if([command.arguments count]>1){
//            NSString * time = [command.arguments objectAtIndex:1];
//            double interval = [time doubleValue]/1000;
//            NSDate * date = [[NSDate alloc] initWithTimeIntervalSince1970:interval];
//            notification.fireDate = date;
//            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
//        }else{
//            [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
//        }
//        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
//        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
//    }else{
//        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
//        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
//    }
//}
//
//- (void)cancelAllLocalNotifications:(CDVInvokedUrlCommand*)command{
//    [[UIApplication sharedApplication] cancelAllLocalNotifications];
//    CDVPluginResult * plugResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
//    [self.commandDelegate sendPluginResult:plugResult callbackId:command.callbackId];
//}
//
//
//- (void)version:(CDVInvokedUrlCommand*)command{
//    NSString * ver = [NSString stringWithFormat:@"%@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
//    CDVPluginResult * plugResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:ver];
//    [self.commandDelegate sendPluginResult:plugResult callbackId:command.callbackId];
//}
@end
