//
//  FileUploadHttpRequestHandle.swift
//  LinClient
//
//  Created by lin on 1/7/15.
//  Copyright (c) 2015 lin. All rights reserved.
//

import Foundation


public class FileUploadHttpRequestHandle:HttpRequestHandle{
    
    public func getParams(request:HttpTask,package:HttpPackage)->Dictionary<String,AnyObject>?{
        //return return package.get
        return package.json.toParams();
    }
    
    public func response(package:HttpPackage,response:AnyObject!,result:((obj:AnyObject!,warning:[HttpError])->()),fault:((error:HttpError)->())){
        var resp:String? = nil;
        
        if response != nil {
            let data = response as! NSData
            resp = NSString(data: data, encoding: NSUTF8StringEncoding) as? String;
            print("response: \(resp)") //prints the HTML of the page
        }
        result(obj: resp, warning: [HttpError]());
    }
}