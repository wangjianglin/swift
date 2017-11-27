//
//  AppStoreUpdate.m
//  LinCore
//
//  Created by lin on 2/15/16.
//  Copyright © 2016 lin. All rights reserved.
//


import UIKit
import LinUtil

open class AppStoreUpdate{
    
    struct YRSignal{
        static var TIME_INTERVAL = 600.0;
    }
    
    open class var interval:Double{
        get{
            return YRSignal.TIME_INTERVAL;
        }
        set{
            YRSignal.TIME_INTERVAL = newValue;
            if YRSignal.TIME_INTERVAL < 60.0 {
                YRSignal.TIME_INTERVAL = 60.0;
            }
        }
    }
    
    
    open class func update(){
        update(appId: nil, bundleId: nil);
    }
    
    open class func update(appId:String){
        update(appId:appId,bundleId:nil)
    }
    
    open class func update(bundleId:String){
        update(appId:nil,bundleId:bundleId)
    }
    
    private class func update(appId:String?,bundleId:String?){
        Queue.asynThread {
            while(true){
                updateImpl(appId:appId,bundleId:bundleId);
                Thread.sleep(forTimeInterval: YRSignal.TIME_INTERVAL);
            }
        }
    }
    
    
    private class func updateImpl(appId:String?,bundleId:String?){
        
        let infoDic = Bundle.main.infoDictionary;
        
        var url:URL!;
        if let appId = appId {
            url = URL(string:"https://itunes.apple.com/cn/lookup?id=\(appId)");
        }else if let bundleId = bundleId {
            url = URL(string:"https://itunes.apple.com/lookup?bundleId=\(bundleId)&country=cn")
        }else{
            let currentBundleId = infoDic?[kCFBundleIdentifierKey as String] ?? "";
            url = URL(string:"https://itunes.apple.com/lookup?bundleId=\(currentBundleId)&country=cn")
        }
        let  request = NSMutableURLRequest();
        request.url = url;
        let data = try? NSURLConnection.sendSynchronousRequest(request as URLRequest, returning:nil);
        if let data = data {
            let updateVersion = String(data:data, encoding:String.Encoding.utf8);
            
            if updateVersion == nil {
                return;
            }
            let json = Json.parse(updateVersion!);
            
            if json.isError {
                return;
            }
            
            var result = json["results"];
            if result.count < 1{
                return;
            }
            result = result[0];
            
            let bundleId = result["bundleId"].asString("");
            
            if Bundle.main.object(forInfoDictionaryKey: kCFBundleIdentifierKey as String) as? String ?? "" != bundleId{
                return;
            }
            
            let minimumOsVersion = result["minimumOsVersion"].asString("0.0");
            
            let systemVersion = UIDevice.current.systemVersion;
            
            if compareVersion(systemVersion,minimumOsVersion) < 0 {
                return;
            }
            
            
            let flag = compareVersion(result["version"].asString("0.0.0"), Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "100000.0.0")
            
            if (flag <= 0) {
                return;
            }
            
            
            var updateString:String!;
            if flag == 1 || flag == 2 {
                updateString = "应用有新版本，为了正常使用，请更新！";
            }else{
                updateString = "应用有新版本，是否需要更新！";
            }
            updateString = result["releaseNotes"].asString(updateString);
            
            let artistId = result["artistId"].asString("");
            
            Queue.mainQueue{
                
                var alert:UIAlertView! = nil;
                
                let trackViewUrl = result["trackViewUrl"].asString("https://itunes.apple.com/us/app/id\(artistId)?ls=1&mt=8");
                
                if flag == 1 || flag == 2 {
                    
                    alert = UIAlertView(title:"", message:updateString, delegate:nil, cancelButtonTitle:"更新");
                    alert.clickedButtonAtIndexAction = {(alertView:UIAlertView, buttonIndex:Int) in
                        if let url = URL(string:trackViewUrl) {
                            UIApplication.shared.openURL(url);
                        }
                    };
                }else{
                    alert = UIAlertView(title:"", message:updateString, delegate:nil, cancelButtonTitle:"取消", otherButtonTitles:"更新");
                    alert.clickedButtonAtIndexAction = {(alertView:UIAlertView, buttonIndex:Int) in
                        if (buttonIndex == 1) {
                            
                            if let url = URL(string:trackViewUrl) {
                                UIApplication.shared.openURL(url);
                            }
                        }
                    };
                }
                
                alert.willPresentAlertViewAction = {(alert:UIAlertView) in
                    for view in alert.subviews {
                        
                        if view is UILabel {
                            (view as! UILabel).textAlignment = NSTextAlignment.left;
                        }
                    }
                }
                
                alert.show();
                
            };
            
        }
    }
    
    private class func compareVersion(_ ver1:String,_ ver2:String)->Int{
        
        
        let vers1 = parserVersion(ver1);
        if vers1 == nil {
            return -2;
        }
        
        
        let vers2 = parserVersion(ver2);
        
        if vers2 == nil {
            return -2;
        }
        
        var flag = -1;//0不需要更新，1/2、必须更新，3、非必须更新
        
        
        if vers1![0] > vers2![0] {
            flag = 1;
        }else if vers1![0] == vers2![0] {
            if vers1![1] > vers2![1] {
                flag = 2;
            }else if vers1![1] == vers2![1] {
                if vers1![2] > vers2![2] {
                    flag = 3;
                }else if vers1![2] == vers2![2] {
                    flag = 0;
                }
            }
        }
        return flag;
    }
    
    fileprivate class func parserVersion(_ version:String!)->[Int]!{
        if version == nil || version == "" {
            return nil;
        }
        let vs = version.components(separatedBy: ".");
        
        var arr = [Int](repeating: 0,count: 3);
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

