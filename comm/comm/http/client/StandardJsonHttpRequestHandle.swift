//
//  StandardJsonHttpRequestHandle.swift
//  LinClient
//
//  Created by lin on 12/3/14.
//  Copyright (c) 2014 lin. All rights reserved.
//

import Foundation
import LinUtil

//
// 采用标准HTTP请求方式传递请求参数，但返回的是json格式的数据
//
public class StandardJsonHttpRequestHandle:HttpRequestHandle{
    public func getParams(request:HttpTask,package:HttpPackage)->Dictionary<String,String>?{
        return package.json.toParams();
    }
    
    public func response(package:HttpPackage,response:AnyObject!,result:((obj:AnyObject!,warning:[HttpError])->()),fault:((error:HttpError)->())){
        var resp:String? = nil;
        
        if response != nil {
            let data = response as! NSData
            resp = NSString(data: data, encoding: NSUTF8StringEncoding) as? String;
            //println("response: \(resp)") //prints the HTML of the page
        }
        if let resp = resp{
            let json = Json(string:resp);
            if json.isError{
                //println("resp:"+resp);
//                if let fault = fault{
                let error = HttpError(code:-0x11);
                error.message = "json parser error.";
                error.cause = "json parser error.";
                error.strackTrace = resp;
                    fault(error:error);
//                }
                return;
            }else{
                let code:Int = json["code"].asInt(-0x12);
                if code < 0 {
                    let error = HttpError(code:code)
                    error.message = json["message"].asString;
                    error.strackTrace = json["stackTrace"].asString;
                    error.cause = json["cause"].asString;
                                        
                    fault(error:error);
                }else{
                    result(obj:package.getResult(json["result"]),warning:[HttpError]());
                }
            }
        }else{
            let error = HttpError(code:-1);
            error.message = "not data.";
            error.cause = "not data.";
            error.strackTrace = "";
            fault(error:error);
//            fault(error:error);
        }
        
    }
}