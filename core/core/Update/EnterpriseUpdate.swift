//
//  EnterpriseUpdate.m
//  LinCore
//
//  Created by lin on 2/15/16.
//  Copyright © 2016 lin. All rights reserved.
//

import UIKit
import LinUtil

public class EnterpriseUpdate{

    public class func update(appUrl:String, versionUrl:String){
    
    let url = NSURL(string:versionUrl);
    let request = NSMutableURLRequest();
    request.URL = url;
    let data = try? NSURLConnection.sendSynchronousRequest(request, returningResponse:nil);
    if let data = data {
        let updateVerString = String(data:data, encoding:NSUTF8StringEncoding);
        
        if updateVerString == nil {
            return;
        }
        
        let versionJson = Json.parse(updateVerString!)
        let updateVersions = parserVersion(versionJson["version"].asString(""));
        if updateVersions == nil {
            return;
        }
        
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
                }
            }
        }
        if (flag == 0) {
            return;
        }
        
        var updateString:String! = nil;
        if (flag == 1) {
            updateString = "应用有新版本，为了正常使用，请更新！";
        }else{
            updateString = "应用有新版本，是否需要更新！";
        }
        updateString = versionJson["message"].asString(updateString);
        Queue.mainQueue(){
            var alert:UIAlertView! = nil;
            if flag == 1 {
                
                alert = UIAlertView(title:"", message:updateString, delegate:nil, cancelButtonTitle:"确定");
                alert.clickedButtonAtIndexAction = {(alertView:UIAlertView, buttonIndex:Int) in
                    
                    if let url = NSURL(string:appUrl) {
                        UIApplication.sharedApplication().openURL(url);
                    }
                    
                };
            }else{
                alert = UIAlertView(title:"", message:updateString, delegate:nil, cancelButtonTitle:"取消", otherButtonTitles:"确定");
                alert.clickedButtonAtIndexAction = {(alertView:UIAlertView, buttonIndex:Int) in
                    if buttonIndex == 1 {
                        
                        if let url = NSURL(string:appUrl) {
                            UIApplication.sharedApplication().openURL(url);
                        }
                        
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
