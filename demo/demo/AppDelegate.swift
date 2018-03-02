//
//  AppDelegate.swift
//  demo
//
//  Created by lin on 1/19/16.
//  Copyright © 2016 lin. All rights reserved.
//

import UIKit
import LinComm
import Foundation
import LinUtil
import LinCore

func httpMock(){
    let arr = [String]();
    HttpCommunicate.http.mock(cls: TestPackage.self, result: nil);
    
    HttpCommunicate.http.error { (pack) -> HttpError? in
        switch pack{
        case let pack as TestPackage:
            if pack.data == "123" {
                return HttpError.init(code: -3);
            }
            break
            
        default:
            break
        }
        
        return nil;
    }
    
    HttpCommunicate.http.result { (pack) -> Any? in
        switch pack{
        case let pack as TestPackage:
            return mockTestPackage(pack);
            
        default:
            break
        }
        
        return nil;
    }
}

func mockTestPackage(_ page:TestPackage)->Any?{
    return nil;
}


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
//        LinComm.HttpCommunicate.commUrl = "http://s.feicuibaba.com";
        LinComm.HttpCommunicate.commUrl = "https://api-t.fcbb.io"
        HttpCommunicate.httpDns = AliHttpDNS(account: "172280");
        HttpCommunicate.httpDns?.setDelegateForDegradationFilter({ (hostName) -> Bool in
            if hostName.hasSuffix("feicuibaba.com"){
                return false;
            }
            
            return true;
        })
        
        HttpCommunicate.httpDns?.setPreResolveHosts("s.feicuibaba.com","s.feicuibaba.com");
    LocalStorage["v"] = "name";
        print(LocalStorage["v"])

        LocalStorage["v"] = 5.0;
        print(LocalStorage["v"] as! Double)
        crashHandle { (infoStr) in
            print("infoStr:------------>:\(infoStr)")
        }
        
        //https://api-t.fcbb.io/shorturl/a
        let auth = OAuth2Authentication(tokenUrl:"https://api-t.fcbb.io/oauth/token");
        auth.clientId = "web_app"
        auth.secret = "123456"
        auth.username = "admin"
        auth.password = "admin"
        
        auth.grantType = .password
//        auth.grantType = .client
        
        auth.tokenStore = LocaleOAuth2TokenStore(name:"token_store")
        
        HttpCommunicate.authentication = auth;
        
        let p = OAuth2Package();
        
//        HttpCommunicate.request(p,())
        HttpCommunicate.request(p, result: { (obj, warning) in
            print(obj);
        }) { (error) in
            print(error);
        }
//        httpMock();
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    public func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Swift.Void){
////        print("ok.....");
////        
//////        UIAlertView.show(<#T##UIAlertView#>)
//        Queue.mainQueue {
//            UIAlertView.show("ok.");
//        }
        
        flag = true;
        if identifier1 == nil {
            identifier1 = identifier;
        }else{
            identifier2 = identifier;
        }
        
//        HttpCommunicate.addHandleEventsForBackgroundURLSession(identifier:identifier,completionHandler:completionHandler);
    
//        URLSession().getTasksWithCompletionHandler { (task, upload, down) in
//            print("task:\(task)\tupload:\(upload)\t\(down)")
//        }
////        completionHandler();
    }

}


class OAuth2Package : HttpPackage {
    public init(){
        super.init(url:"/shorturl/a");
    }
}
