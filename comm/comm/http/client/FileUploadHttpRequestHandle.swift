//
//  FileUploadHttpRequestHandle.swift
//  LinClient
//
//  Created by lin on 1/7/15.
//  Copyright (c) 2015 lin. All rights reserved.
//

import Foundation


//open class FileUploadHttpRequestHandle:AbstractHttpRequestHandle{
//    
//    open func getParams(_ request:HttpTask,package:HttpPackage)->Dictionary<String,AnyObject>?{
//        //return return package.get
//        return package.json.toParams() as Dictionary<String, AnyObject>?;
//    }
//    
//    open override func response(_ package:HttpPackage,response:AnyObject!,result:((_ obj:AnyObject?,_ warning:[HttpError])->()),fault:((_ error:HttpError)->())){
//        var resp:String? = nil;
//        
//        if response != nil {
//            let data = response as! Data
//            resp = NSString(data: data, encoding: String.Encoding.utf8.rawValue) as? String;
//            print("response: \(resp)") //prints the HTML of the page
//        }
//        result(resp as AnyObject?, [HttpError]());
//    }
//}
