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
    
    public static func fromBuffer(var buffer:[UInt8],var count:Int = 0)->String!{
        let arrayPtr = UnsafeMutableBufferPointer<UInt8>(start: &buffer, count: buffer.count)
        let basePtr = arrayPtr.baseAddress as UnsafeMutablePointer<UInt8>
        
        let data = NSData(bytesNoCopy: basePtr, length: count,freeWhenDone:false);
        if(count == 0){
            count = buffer.count;
        }
        let s = NSString(data: data, encoding: NSUTF8StringEncoding) as! String
        return s;
    }
}