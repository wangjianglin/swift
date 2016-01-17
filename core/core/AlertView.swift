//
//  AlertView.swift
//  LinControls
//
//  Created by lin on 1/8/15.
//  Copyright (c) 2015 lin. All rights reserved.
//

import UIKit
#if !iOS7
//import LinClient
#endif

public class AlertView{
    
    public class func show(titie:String,message:String,buttonTitle:String){
        UIAlertView(title: titie, message: message, delegate: nil, cancelButtonTitle: buttonTitle).show();
    }
    
    public class func show(message:String){
        UIAlertView(title: "", message: message, delegate: nil, cancelButtonTitle: "确定").show();
    }
    
//    public class func show(error:HttpError){
//        
//////        var message = "\(error.code) \(error.message)";
////        var message = String(format: "%0x", error.code);
////        if message.utf16Count > (error.code>0 ? 4 : 5) {
////            message.insert("_", atIndex: advance(message.startIndex, message.utf16Count - 4));
////        }
//////        println("message:\(message)");
////        if let msg = error.message {
////            message = "错误码：\(message) 错误消息：\(msg)";
////        }else{
////            message = "错误码：\(message) 错误消息：无";
////        }
//        UIAlertView(title: "", message: "\(error)", delegate: nil, cancelButtonTitle: "确定").show();
//    }
}
