//
//  Warning.swift
//  LinClient
//
//  Created by lin on 12/1/14.
//  Copyright (c) 2014 lin. All rights reserved.
//

import Foundation

open class HttpError :NSObject{
    
    public init(code:Int){
        super.init();
        self._code = code;
    }
    fileprivate var _code:Int = -1;
    open var code:Int{
        return _code;
    }
    
    open var message:String?;
    
    open var strackTrace:String?;
    
    open var cause:String?;

    
    open override var description:String{
//        NSNumberFormatter
//        kCFNumberFormatter;//.PercentStyle
        var desc:String!;
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
        if let msg = self.message {
            desc = "错误码：\(desc)\n错误消息：\(msg)！";
        }else{
            desc = "错误码：\(desc)\n错误消息：无";
        }
        return desc;
    }
}

public extension HttpError{
    
    public func toNSError()->NSError{
        return NSError(domain: self.message ?? "", code: self._code, userInfo: ["cause":self.cause ?? "","strackTrace":self.strackTrace ?? ""]);
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
