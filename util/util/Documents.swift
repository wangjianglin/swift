//
//  Documents.swift
//  LinUtil
//
//  Created by lin on 1/18/15.
//  Copyright (c) 2015 lin. All rights reserved.
//

import Foundation

public enum Documents{
    case Document,Tmp,Cache,Library,Bundle
}

public func pathFor(documents:Documents,path:String)->String?{

    var filePath:String?;
    switch(documents){

    case .Document:
        filePath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory,NSSearchPathDomainMask.UserDomainMask,true)[0];

    case .Cache:
        filePath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory,NSSearchPathDomainMask.UserDomainMask,true)[0];

    case .Tmp:
        filePath = NSTemporaryDirectory();

    case .Library:
        filePath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.LibraryDirectory,NSSearchPathDomainMask.UserDomainMask,true)[0];
    case .Bundle:
        let mainBundle:NSBundle = NSBundle.mainBundle();
        return mainBundle.pathForResource(path, ofType: nil);
//    default:
//        break;
    }
    if var fPath = filePath {
        if !fPath.hasSuffix("/") {
            fPath = "\(fPath)/";
        }
        
        if path.hasPrefix("/") {
            filePath = "\(fPath)\((path as NSString).substringFromIndex(1))";
        }else{
            filePath = "\(fPath)\(path)";
        }
    }
    return filePath;
}