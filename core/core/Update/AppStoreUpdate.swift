//
//  AppStoreUpdate.m
//  LinCore
//
//  Created by lin on 2/15/16.
//  Copyright © 2016 lin. All rights reserved.
//


import UIKit
import LinUtil

public class AppStoreUpdate{


    public class func update(appId:String){
        Queue.asynThread { 
            while(true){
                updateImpl(appId);
                NSThread.sleepForTimeInterval(600.0);
            }
        }
//    [Queue asynThread:^{
//        
//        while (true) {
//            [AppStoreUpdate updateImpl:appId];
//            
//            [NSThread sleepForTimeInterval:600.0];
//        }
//    }];
}


    private class func updateImpl(appId:String){

//    let appUrl = "https://itunes.apple.com/lookup?id=\(appId)";
    
    let url = NSURL(string:"https://itunes.apple.com/lookup?id=\(appId)");
    let  request = NSMutableURLRequest();
    request.URL = url;
    let data = try? NSURLConnection.sendSynchronousRequest(request, returningResponse:nil);
    if let data = data {
        let updateVersion = String(data:data, encoding:NSUTF8StringEncoding);
        
        if updateVersion == nil {
            return;
        }
        let json = Json.parse(updateVersion!);
        
        
        let updateVersions = parserVersion(json["results"][0]["version"].asString(""));
        if updateVersions == nil {
            return;
        }
//        NSString * appVersion = [NSString stringWithFormat:@"%@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
        let appVersions = parserVersion(NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as? String);
        if appVersions == nil {
            return;
        }
        
        var flag = 0;//0不需要更新，1、必须更新，2、非必须更新
        
        
        if updateVersions[0] > appVersions[0] {
            flag = 1;
        }else if updateVersions[0] == appVersions[0] {
            if updateVersions[1] > appVersions[1] {
                flag = 1;
            }else if updateVersions[1] == appVersions[1] {
                if updateVersions[2] > appVersions[2] {
                    flag = 2;
                    //                    flag = 1;
                }
            }
        }
        if (flag == 0) {
            return;
        }
        //        if (flag == 2 && [UserDefaults[@"isupdateofversion"] isEqualToString:@"true"] && [UserDefaults[@"isupdateofversion_version"] isEqualToString:updateVersion]) {
        //            return;
        //        }
        
        var updateString:String!;
        if (flag == 1) {
            updateString = "应用有新版本，为了正常使用，请更新！";
        }else{
            updateString = "应用有新版本，是否需要更新！";
        }
        updateString = json["results"][0]["releaseNotes"].asString(updateString);
        
        Queue.mainQueue{ 
            
            var alert:UIAlertView! = nil;
            
//            NSString *  urlString = [[NSString alloc] initWithFormat:@"https://itunes.apple.com/cn/app/wei/id%@",appId];
            
//            let url = NSURL(string:"https://itunes.apple.com/cn/app/wei/id\(appId)");
            
            if flag == 1 {
                
                alert = UIAlertView(title:"", message:updateString, delegate:nil, cancelButtonTitle:"更新");
                alert.clickedButtonAtIndexAction = {(alertView:UIAlertView, buttonIndex:Int) in
                    //                    if (buttonIndex == 1) {
                    if let url = NSURL(string:"https://itunes.apple.com/cn/app/wei/id\(appId)") {
                        UIApplication.sharedApplication().openURL(url);
                    }
                    //UserDefaults[@"isupdateofversion"] = @"false";
                    //                    }else{
                    //                        UserDefaults[@"isupdateofversion"] = @"true";
                    //                        UserDefaults[@"isupdateofversion_version"] = updateVersion;
                    //                    }
                };
            }else{
                alert = UIAlertView(title:"", message:updateString, delegate:nil, cancelButtonTitle:"取消", otherButtonTitles:"更新");
                alert.clickedButtonAtIndexAction = {(alertView:UIAlertView, buttonIndex:Int) in
                    if (buttonIndex == 1) {
                        
                        if let url = NSURL(string:"https://itunes.apple.com/cn/app/wei/id\(appId)") {
                            UIApplication.sharedApplication().openURL(url);
                        }
                        //UserDefaults[@"isupdateofversion"] = @"false";
                    }
                };
            }
            alert.show();
            
        };
        
    }
}

    private class func parserVersion(version:String!)->[Int]!{
    if version == nil || version == "" {
        return nil;
    }
    let vs = version.componentsSeparatedByString(".");
//    if (vs == nil) {
//        return nil;
//    }
        
    var arr = [Int](count:3,repeatedValue:0);
    for n in 0 ..< 3 {
        if n < vs.count {
            arr[n] = (vs[n] as NSString).integerValue;
        }else{
            arr[n] = 0;
        }
    }
    return arr;
}

}
