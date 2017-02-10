//  Strings.swift
//  LinUtil
//
//  Created by lin on 1/18/15.
//  Copyright (c) 2015 lin. All rights reserved.
//

import Foundation

extension String {
    
    public static func fromBuffer(_ buffer:[UInt8],offset:Int = 0,count:Int = 0,encoding: String.Encoding = String.Encoding.utf8)->String!{
        var buffer = buffer, count = count
        let arrayPtr = UnsafeMutableBufferPointer<UInt8>(start: &buffer, count: buffer.count)
        let basePtr = (arrayPtr.baseAddress?.advanced(by: offset))! as UnsafeMutablePointer<UInt8>
        
        let data = Data(bytesNoCopy: UnsafeMutablePointer<UInt8>(basePtr), count: count,deallocator: .none);
        if(count == 0){
            count = buffer.count;
        }
        let s = NSString(data: data, encoding: encoding.rawValue) as! String
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
        return self.trimmingCharacters(in: CharacterSet.whitespaces)
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

public enum CryptoAlgorithm:String {
    case MD5, SHA1, SHA224, SHA256, SHA384, SHA512
    
//    var str: String {
//        var result: String = "";
//        switch self {
//        case .MD5:      result = "MD5";
//        case .SHA1:     result = "SHA1";
//        case .SHA224:   result = "SHA224";
//        case .SHA256:   result = "SHA256";
//        case .SHA384:   result = "SHA384";
//        case .SHA512:   result = "SHA512";
//        }
//        return result;
//    }
}
extension String {
    
    public func hmac(key:String,algorithm:CryptoAlgorithm = CryptoAlgorithm.MD5)->String{
        return cryptosHmac(self, key, algorithm.rawValue);
    }
    
    public var md2 : String{
        return cryptosDigestWithString(self,"MD2");
    }
    
    public var md4 : String{
        return cryptosDigestWithString(self,"MD4");
    }
    
    public var md5 : String{
        return cryptosDigestWithString(self,"MD5");
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
    
    
    public var sha1:String{
        return cryptosDigestWithString(self, "SHA1");
    }
    public var sha224:String{
        return cryptosDigestWithString(self, "SHA224");
    }
    public var sha256:String{
        return cryptosDigestWithString(self, "SHA256");
    }
    public var sha384:String{
        return cryptosDigestWithString(self, "SHA384");
    }
    public var sha512:String{
        return cryptosDigestWithString(self, "SHA512");
    }
}
