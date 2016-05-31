////
////  EnterpriseUpdate.m
////  LinCore
////
////  Created by lin on 2/15/16.
////  Copyright © 2016 lin. All rights reserved.
////
//
//#import "EnterpriseUpdate.h"
//
//#import <UIKit/UIKit.h>
//
//@implementation EnterpriseUpdate
//
//+(void)update:(NSString *)appUrl versionUrl:(NSString *)versionUrl{
//    
//    //    static BOOL isUpdate = false;
////    NSURL * url = [[NSURL alloc] initWithString:@"https://www.feicuibaba.com/proxy/proxy.php?version=true&ios=true"];
//    NSURL * url = [[NSURL alloc] initWithString:versionUrl];
//    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] init];
//    [request setURL:url];
//    NSData * data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//    if (data != nil) {
//        NSString * updateVersion = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        
//        
//        NSArray * updateVersions = [EnterpriseUpdate parserVersion:updateVersion];
//        if (updateVersion == nil) {
//            return;
//        }
//        NSString * appVersion = [NSString stringWithFormat:@"%@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
//        NSArray * appVersions = [EnterpriseUpdate parserVersion:appVersion];
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
////        if (flag == 2 && [UserDefaults[@"isupdateofversion"] isEqualToString:@"true"] && [UserDefaults[@"isupdateofversion_version"] isEqualToString:updateVersion]) {
////            return;
////        }
//        
//        NSString * updateString = nil;
//        if (flag == 1) {
//            updateString = @"应用有新版本，为了正常使用，请更新！";
//        }else{
//            updateString = @"应用有新版本，是否需要更新！";
//        }
//        [Queue mainQueue:^{
//            UIAlertView * alert = NULL;
//            if (flag == 1) {
//                
//                alert = [[UIAlertView alloc] initWithTitle:@"" message:updateString delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
//                alert.clickedButtonAtIndexAction = ^(UIAlertView * alertView, NSInteger buttonIndex){
//                    //                    if (buttonIndex == 1) {
//                    NSURL * url = [[NSURL alloc] initWithString:@"itms-services://?action=download-manifest&url=https://www.feicuibaba.com/buyers/buyers.plist.php"];
//                    [[UIApplication sharedApplication] openURL:url];
//                    //UserDefaults[@"isupdateofversion"] = @"false";
//                    //                    }else{
//                    //                        UserDefaults[@"isupdateofversion"] = @"true";
//                    //                        UserDefaults[@"isupdateofversion_version"] = updateVersion;
//                    //                    }
//                };
//            }else{
//                alert = [[UIAlertView alloc] initWithTitle:@"" message:updateString delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
//                alert.clickedButtonAtIndexAction = ^(UIAlertView * alertView, NSInteger buttonIndex){
//                    if (buttonIndex == 1) {
//                        NSURL * url = [[NSURL alloc] initWithString:@"itms-services://?action=download-manifest&url=https://www.feicuibaba.com/buyers/buyers.plist.php"];
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
//    if (vs == nil || vs.count < 3) {
//        return nil;
//    }
//    
//    for (int n=0; n<3; n++) {
//        [arr addObject:[[NSNumber alloc] initWithInt:[vs[n] intValue]]];
//    }
//    return arr;
//}
//
//@end
