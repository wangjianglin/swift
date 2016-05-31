////
////  AppStoreUpdate.m
////  LinCore
////
////  Created by lin on 2/15/16.
////  Copyright © 2016 lin. All rights reserved.
////
//
//
//#import <UIKit/UIKit.h>
//
//#import "AppStoreUpdate.h"
//
//@implementation AppStoreUpdate
//
//
//+(void)update:(NSString *)appId{
//    [Queue asynThread:^{
//        
//        while (true) {
//            [AppStoreUpdate updateImpl:appId];
//            
//            [NSThread sleepForTimeInterval:600.0];
//        }
//    }];
//}
//
//
//+(void)updateImpl:(NSString *)appId{
//
//    NSString * appUrl = [[NSString alloc] initWithFormat:@"https://itunes.apple.com/lookup?id=%@",appId];
//    
//    //    static BOOL isUpdate = false;
//    //    NSURL * url = [[NSURL alloc] initWithString:@"https://www.feicuibaba.com/proxy/proxy.php?version=true&ios=true"];
//    NSURL * url = [[NSURL alloc] initWithString:appUrl];
//    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] init];
//    [request setURL:url];
//    NSData * data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//    if (data != nil) {
//        NSString * updateVersion = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        
//        Json * json = [Json parse:updateVersion];
//        
//        
//        NSArray * updateVersions = [AppStoreUpdate parserVersion:[json[@"results"][0][@"version"] asString:@""]];
//        if (updateVersions == nil) {
//            return;
//        }
//        NSString * appVersion = [NSString stringWithFormat:@"%@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
//        NSArray * appVersions = [AppStoreUpdate parserVersion:appVersion];
//        if (appVersions == nil) {
//            return;
//        }
//        int flag = 0;//0不需要更新，1、必须更新，2、非必须更新
//        
//        
//        if ([updateVersions[0] compare: appVersions[0]] == 1) {
//            flag = 1;
//        }else if([updateVersions[0] isEqualToNumber: appVersions[0]]){
//            if ([updateVersions[1] compare: appVersions[1]] == 1) {
//                flag = 1;
//            }else if([updateVersions[1] isEqualToNumber: appVersions[1]]){
//                if ([updateVersions[2] compare: appVersions[2]] == 1) {
//                    flag = 2;
//                    //                    flag = 1;
//                }
//            }
//        }
//        if (flag == 0) {
//            return;
//        }
//        //        if (flag == 2 && [UserDefaults[@"isupdateofversion"] isEqualToString:@"true"] && [UserDefaults[@"isupdateofversion_version"] isEqualToString:updateVersion]) {
//        //            return;
//        //        }
//        
//        NSString * updateString = nil;
//        if (flag == 1) {
//            updateString = @"应用有新版本，为了正常使用，请更新！";
//        }else{
//            updateString = @"应用有新版本，是否需要更新！";
//        }
//        updateString = [json[@"results"][0][@"releaseNotes"] asString:@"有新版本，请更新！"];
//        [Queue mainQueue:^{
//            UIAlertView * alert = nil;
//            
//            NSString *  urlString = [[NSString alloc] initWithFormat:@"https://itunes.apple.com/cn/app/wei/id%@",appId];
//            
//            NSURL * url = [[NSURL alloc] initWithString:urlString];
//            
//            if (flag == 1) {
//                
//                alert = [[UIAlertView alloc] initWithTitle:@"" message:updateString delegate:nil cancelButtonTitle:@"更新" otherButtonTitles:nil,nil];
//                alert.clickedButtonAtIndexAction = ^(UIAlertView * alertView, NSInteger buttonIndex){
//                    //                    if (buttonIndex == 1) {
//                    
//                    [[UIApplication sharedApplication] openURL:url];
//                    //UserDefaults[@"isupdateofversion"] = @"false";
//                    //                    }else{
//                    //                        UserDefaults[@"isupdateofversion"] = @"true";
//                    //                        UserDefaults[@"isupdateofversion_version"] = updateVersion;
//                    //                    }
//                };
//            }else{
//                alert = [[UIAlertView alloc] initWithTitle:@"" message:updateString delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"更新",nil];
//                alert.clickedButtonAtIndexAction = ^(UIAlertView * alertView, NSInteger buttonIndex){
//                    if (buttonIndex == 1) {
//                        
//                        [[UIApplication sharedApplication] openURL:url];
//                        //UserDefaults[@"isupdateofversion"] = @"false";
//                    }else{
//                        //UserDefaults[@"isupdateofversion"] = @"true";
//                        //UserDefaults[@"isupdateofversion_version"] = updateVersion;
//                    }
//                };
//            }
//            [alert show];
//            
//        }];
//        
//    }
//}
//
//+(NSArray*)parserVersion:(NSString*)version{
//    if (version == nil || [version isEqualToString:@""]) {
//        return nil;
//    }
//    NSMutableArray * arr = [[NSMutableArray alloc] init];
//    NSArray * vs = [version componentsSeparatedByString:@"."];
//    if (vs == nil) {
//        return nil;
//    }
//    
//    for (int n=0; n<3; n++) {
//        if (n < vs.count) {
//            [arr addObject:[[NSNumber alloc] initWithInt:[vs[n] intValue]]];
//        }else{
//            [arr addObject:[[NSNumber alloc] initWithInt:0]];
//        }
//    }
//    return arr;
//}
//
//@end
