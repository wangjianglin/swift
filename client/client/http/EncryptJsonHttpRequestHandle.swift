//
//  JsonHttpRequestHandle.swift
//  LinClient
//
//  Created by lin on 12/2/14.
//  Copyright (c) 2014 lin. All rights reserved.
//

import Foundation


public class EncryptJsonHttpRequestHandle:HttpRequestHandle{
    
    public func getParams(request:HttpTask,package:HttpPackage)->Dictionary<String,String>?{
        request.requestSerializer.headers[HttpConstants.HTTP_COMM_PROTOCOL] = HttpConstants.HTTP_VERSION;
        var params = Dictionary<String,String>();
        
        let jsonParams = "{\"timestamp\":\(HttpUtils.timestamp),\"sequeueid\":\(HttpUtils.sequeue),\"data\":\(package.json.toString())}";
        
//        let decodedData = NSData(base64EncodedString: jsonParams, options: NSDataBase64DecodingOptions(0))
//        
//        jsonParams = NSString(data: decodedData, encoding: NSUTF8StringEncoding)
        
        let plainData:NSData? = (jsonParams as NSString).dataUsingEncoding(NSUTF8StringEncoding)
        
        let jsonParams2 = plainData?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
        
        //println(base64String) // Zm9v
        
        //println(decodedString) // foo
        params[HttpConstants.HTTP_JSON_PARAM] = jsonParams2!;
        params[HttpConstants.HTTP_REQUEST_CODING] = "utf-8";
        return params;
    }
    
    public func response(package:HttpPackage,response:AnyObject!,result:((obj:AnyObject!,warning:[HttpError])->()),fault:((error:HttpError)->())){
        print("response ok.");
      
        var resp:String?;
        
        if response != nil {
            let data = response as! NSData
            resp = NSString(data: data, encoding: NSUTF8StringEncoding) as? String;
//            data.
            
            //println("response: \(resp)") //prints the HTML of the page
        }
        
        let decodedData = NSData(base64EncodedString: resp!, options: NSDataBase64DecodingOptions(rawValue: 0))
        //
        let result = NSString(data: decodedData!, encoding: NSUTF8StringEncoding)
        
        print("result:\(result)");
        
    }
}