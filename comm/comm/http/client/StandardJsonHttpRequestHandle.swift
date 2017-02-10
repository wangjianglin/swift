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
open class StandardJsonHttpRequestHandle:HttpRequestHandle{
    
    open func preprocess(_ package:HttpPackage,params:HttpCommunicate.Params)->HttpRequestPreprocessResult!{
        
//        package.commParams
        let result = HttpRequestPreprocessResult();
        result.headers[HttpConstants.HTTP_COMM_PROTOCOL] = HttpConstants.HTTP_VERSION;
        if params.isDebug == true {
            result.headers[HttpConstants.HTTP_COMM_PROTOCOL_DEBUG] = "";
        }
        return result;
    }
    
    open func getParams(_ package:HttpPackage)->Dictionary<String,AnyObject>?{
        
        
        if package is HttpUploadPackage {
            var params = Dictionary<String,AnyObject>();
            for (name,value) in package.json.toParams() {
                params[name] = value as NSString?;
            }
            for (name,value) in (package as! HttpUploadPackage).files {
                params[name] = value;
            }
            return params;
        }
        return package.json.toParams() as Dictionary<String, AnyObject>?;
    }
    
    open func response(_ package:HttpPackage,response:AnyObject!,result:((_ obj:AnyObject?,_ warning:[HttpError])->()),fault:((_ error:HttpError)->())){
        var resp:String? = nil;
        
        if response != nil {
            let data = response as! Data
            resp = NSString(data: data, encoding: String.Encoding.utf8.rawValue) as? String;
            //println("response: \(resp)") //prints the HTML of the page
        }
        if let resp = resp{
            let json = Json(string:resp);
            if json.isError{
                //println("resp:"+resp);
//                if let fault = fault{
                let error = HttpError(code:-0x11
                    ,message:"json parser error."
                    ,cause:""
                    ,strackTrace : resp);
//                error.message = "json parser error.";
//                error.cause = "json parser error.";
//                error.strackTrace = resp;
                    fault(error);
//                }
                return;
            }else{
                let code:Int = json["code"].asInt(-0x12);
                if code < 0 {
                    let error = HttpError(code:code
                        ,message:json["message"].asString
                        ,cause:json["cause"].asString
                        ,strackTrace:json["strackTrace"].asString
                    )
//                    error.message = json["message"].asString;
//                    error.strackTrace = json["stackTrace"].asString;
//                    error.cause = json["cause"].asString;
                    
                    fault(error);
                }else{
//                    result(obj:package.getResult(json["result"]),warning:[HttpError]());
                    result(package.getResult(json["result"]),[HttpError]());
                }
            }
        }else{
            let error = HttpError(code:-1
                ,message:"not data."
                ,cause:"not data."
            );
//            error.message = "not data.";
//            error.cause = "not data.";
//            error.strackTrace = "";
            fault(error);
//            fault(error:error);
        }
        
    }
}
