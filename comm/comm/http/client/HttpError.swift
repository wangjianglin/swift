//
//  Warning.swift
//  LinClient
//
//  Created by lin on 12/1/14.
//  Copyright (c) 2014 lin. All rights reserved.
//

import Foundation

open class HttpError :NSObject,Error{
    
    public init(code:Int,message:String? = nil,cause:String? = nil,stackTrace:String? = nil){
        super.init();
        self.__code = code;
        self._message = message;
        self._cause = cause;
        self._stackTrace = stackTrace;
    }
    private var __code:Int = -1;
    open var code:Int{
        return __code;
    }
    
    private var _message:String?;
    open var message:String?{
        return _message;
    }
    
    private var _stackTrace:String?;
    open var stackTrace:String?{
        return _stackTrace;
    }
    
    private var _cause:String?;
    open var cause:String?{
        return _cause;
    }

    
    open override var description:String{
//        NSNumberFormatter
//        kCFNumberFormatter;//.PercentStyle
        var desc:String!;
        if self.code < 0 {
            desc = String(format: "-0x%0x", -self.code);
        }else{
            desc = String(format: "0x%0x", self.code);
        }
        desc = (desc as NSString).uppercased;
        if desc.characters.count > (self.code>0 ? 4 : 5) {
            desc.insert("_", at: desc.index(desc.startIndex, offsetBy: desc.characters.count - 4));
        }
        //        println("message:\(message)");
        if let msg = self.message {
            desc = "错误码：\(desc!)\n错误消息：\(msg)！";
        }else{
            desc = "错误码：\(desc!)\n错误消息：无";
        }
        return desc;
    }
}

public extension HttpError{
    
    public func toNSError()->NSError{
        return NSError(domain: self.message ?? "", code: self._code, userInfo: ["cause":self.cause ?? "","stackTrace":self.stackTrace ?? ""]);
    }
}

public extension NSError{
    
    public func toHttpErrorString()->String{
        if self.code == 0{
            return self.domain;
        }
        var desc:String;
        if self.code < 0 {
            desc = String(format: "-0x%0x", -self.code);
        }else{
            desc = String(format: "0x%0x", -self.code);
        }
        desc = (desc as NSString).uppercased;
        if desc.characters.count > (self.code>0 ? 4 : 5) {
            desc.insert("_", at: desc.index(desc.startIndex, offsetBy: desc.characters.count - 4));
        }
        //        println("message:\(message)");
        if self.domain == "" {
            desc = "错误码：\(desc)\n错误消息：无";
        }else{
            desc = "错误码：\(desc)\n错误消息：\(self.domain)！";
        }
        return desc;
    }
}
