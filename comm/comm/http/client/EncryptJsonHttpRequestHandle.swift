//
//  JsonHttpRequestHandle.swift
//  LinClient
//
//  Created by lin on 12/2/14.
//  Copyright (c) 2014 lin. All rights reserved.
//

import Foundation


open class EncryptJsonHttpRequestHandle:HttpRequestHandle{
    
    open func getParams(_ request:HttpTask,package:HttpPackage)->Dictionary<String,AnyObject>?{
        request.requestSerializer.headers[HttpConstants.HTTP_COMM_PROTOCOL] = HttpConstants.HTTP_VERSION;
        var params = Dictionary<String,String>();
        
        let jsonParams = "{\"timestamp\":\(HttpUtils.timestamp),\"sequeueid\":\(HttpUtils.sequeue),\"data\":\(package.json.toString())}";
        
//        let decodedData = NSData(base64EncodedString: jsonParams, options: NSDataBase64DecodingOptions(0))
//        
//        jsonParams = NSString(data: decodedData, encoding: NSUTF8StringEncoding)
        
        let plainData:Data? = (jsonParams as NSString).data(using: String.Encoding.utf8.rawValue)
        
        let jsonParams2 = plainData?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
        
        //println(base64String) // Zm9v
        
        //println(decodedString) // foo
        params[HttpConstants.HTTP_JSON_PARAM] = jsonParams2!;
        params[HttpConstants.HTTP_REQUEST_CODING] = "utf-8";
        return params as Dictionary<String, AnyObject>?;
    }
    
    open func response(_ package:HttpPackage,response:AnyObject!,result:((_ obj:AnyObject?,_ warning:[HttpError])->()),fault:((_ error:HttpError)->())){
        print("response ok.");
      
        var resp:String?;
        
        if response != nil {
            let data = response as! Data
            resp = NSString(data: data, encoding: String.Encoding.utf8.rawValue) as? String;
//            data.
            
            //println("response: \(resp)") //prints the HTML of the page
        }
        
        let decodedData = Data(base64Encoded: resp!, options: Data.Base64DecodingOptions(rawValue: 0))
        //
        let result = NSString(data: decodedData!, encoding: String.Encoding.utf8.rawValue)
        
        print("result:\(result)");
        
    }
}
