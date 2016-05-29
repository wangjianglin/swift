//  Strings.swift
//  LinUtil
//
//  Created by lin on 1/18/15.
//  Copyright (c) 2015 lin. All rights reserved.
//

import Foundation

extension String {
    public var md5 : String{
        return md5WithString(self);
//        let str = self.cStringUsingEncoding(NSUTF8StringEncoding)
//        let strLen = CC_LONG(self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
//        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
//        let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLen);
//        
//        CC_MD5(str!, strLen, result);
//        
//        var hash = NSMutableString();
//        for i in 0 ..< digestLen {
//            hash.appendFormat("%02x", result[i]);
//        }
//        result.destroy();
//        
//        return String(format: hash)
    }
    
    public static func fromBuffer(var buffer:[UInt8],offset:Int = 0,var count:Int = 0,encoding: UInt = NSUTF8StringEncoding)->String!{
        let arrayPtr = UnsafeMutableBufferPointer<UInt8>(start: &buffer, count: buffer.count)
        let basePtr = arrayPtr.baseAddress.advancedBy(offset) as UnsafeMutablePointer<UInt8>
        
        let data = NSData(bytesNoCopy: basePtr, length: count,freeWhenDone:false);
        if(count == 0){
            count = buffer.count;
        }
        let s = NSString(data: data, encoding: encoding) as! String
        return s;
    }
    
    //分割字符
//    func split(s:String)->[String]{
//        if s.isEmpty{
//            var x=[String]()
//            for y in self{
//                x.append(String(y))
//            }
//            return x
//        }
//        return self.componentsSeparatedByString(s)
//    }
    //去掉左右空格
    public func trim()->String{
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    }
    //是否包含字符串
//    public func has(s:String)->Bool{
//        return self.rangeOfString(s) != nil
//    }
//    //是否包含前缀
//    func hasBegin(s:String)->Bool{
//        if self.hasPrefix(s) {
//            return true
//        }else{
//            return false
//        }
//    }
//    //是否包含后缀
//    func hasEnd(s:String)->Bool{
//        if self.hasSuffix(s) {
//            return true
//        }else{
//            return false
//        }
//    }
//    //统计长度
//    func length()->Int{
//        return countElements(self)
//    }
//    //统计长度(别名)
//    func size()->Int{
//        return countElements(self)
//    }
//    //截取字符串
//    func substr(range:Int...)->String{
//        if range[0]==0{
//            return self.substringToIndex(range[1])
//        }else{
//            return self.substringFromIndex(range[0])
//        }
//    }
//    //重复字符串
//    func repeat(times: Int) -> String{
//        var result = ""
//        for i in 0..times {
//            result += self
//        }
//        return result
//    }
//    //反转
//    func reverse()-> String{
//        var s=self.split("").reverse()
//        var x=""
//        for y in s{
//            x+=y
//        }
//        return x
//    }
}