//
//  Documents.swift
//  LinUtil
//
//  Created by lin on 1/18/15.
//  Copyright (c) 2015 lin. All rights reserved.
//

import Foundation

public enum Documents{
    case document,tmp,cache,library,bundle
}

public func pathFor(_ documents:Documents,path:String)->String?{

    var filePath:String?;
    switch(documents){

    case .document:
        filePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,FileManager.SearchPathDomainMask.userDomainMask,true)[0];

    case .cache:
        filePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory,FileManager.SearchPathDomainMask.userDomainMask,true)[0];

    case .tmp:
        filePath = NSTemporaryDirectory();

    case .library:
        filePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory,FileManager.SearchPathDomainMask.userDomainMask,true)[0];
    case .bundle:
        let mainBundle:Bundle = Bundle.main;
        return mainBundle.path(forResource: path, ofType: nil);
//    default:
//        break;
    }
    if var fPath = filePath {
        if !fPath.hasSuffix("/") {
            fPath = "\(fPath)/";
        }
        
        if path.hasPrefix("/") {
            filePath = "\(fPath)\((path as NSString).substring(from: 1))";
        }else{
            filePath = "\(fPath)\(path)";
        }
    }
    return filePath;
}
