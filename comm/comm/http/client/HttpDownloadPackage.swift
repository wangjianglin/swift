//
//  HttpDownloadPackage.swift
//  LinComm
//
//  Created by lin on 19/10/2016.
//  Copyright © 2016 lin. All rights reserved.
//

import Foundation


open class HttpDownloadPackage : HttpPackage{
    
    
//    struct YRSingleton{
//        static var predicate:Int = 0
//        static var instance:FileUploadHttpRequestHandle? = nil
//    }
//    
//    fileprivate static var __once: () = {
//        
//        YRSingleton.instance = FileUploadHttpRequestHandle()
//        
//    }()
    
    public enum DownMode{
        case Background
        case Normal
    }
    
    private struct DownModeValue{
        static var value:DownMode = DownMode.Background;
    }
    
    open class var defaultDownMode:DownMode{
        get { return DownModeValue.value;}
        set { DownModeValue.value = newValue;}
    }
    
    private var _downMode:DownMode?;
    open var downMode:DownMode{
        get{
            if let v = _downMode {
                return v;
            }
            return DownModeValue.value;
        }
        set { _downMode = newValue; }
    }
    
    open var identifier:String!;
    
    open override var enableCache:Bool{
        get{
        return false;
        }
        set{}
    }
    
    public init(url:String){
        super.init(url: url, method: HttpMethod.POST);
    }
    
    
//    open var progress:((_ down: Int64, _ expected: Int64, _ bytes: Int64) -> Void)!;

}

