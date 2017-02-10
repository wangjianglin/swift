//
//  md5.h
//  books
//
//  Created by lin on 14-9-21.
//  Copyright (c) 2014年 lin. All rights reserved.
//

#import <Foundation/Foundation.h>

NSString * cryptosHmac(NSString * string,NSString * key,NSString * algorithm);
NSString* cryptosMD5WithPath(NSString* path);

NSString * cryptosDigestWithString(NSString * string,NSString * algorithm);
//NSString * cryptosMD5WithString(NSString * string);
//
//NSString * cryptosSHA1WithString(NSString * string);

//NSString * cryptosSHA1WithString(NSString * string){
//    
//    const char * str = [string cStringUsingEncoding:NSUTF8StringEncoding];
//    
//    NSUInteger strLen = [string lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
//    uint32_t digestLen = CC_SHA1_DIGEST_LENGTH;
//    
//    unsigned char result[digestLen];
//    CC_MD5(str, (CC_LONG)strLen, result);
//    
//    return __cryptos_stringFromResult(result, digestLen);
//    
//}
//
//NSString * cryptosSHA224WithString(NSString * string){
//    
//    const char * str = [string cStringUsingEncoding:NSUTF8StringEncoding];
//    
//    NSUInteger strLen = [string lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
//    uint32_t digestLen = CC_SHA224_DIGEST_LENGTH;
//    
//    unsigned char result[digestLen];
//    CC_MD5(str, (CC_LONG)strLen, result);
//    
//    return __cryptos_stringFromResult(result, digestLen);
//    
//}
//
//
//NSString * cryptosSHA256WithString(NSString * string){
//    
//    const char * str = [string cStringUsingEncoding:NSUTF8StringEncoding];
//    
//    NSUInteger strLen = [string lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
//    uint32_t digestLen = CC_SHA256_DIGEST_LENGTH;
//    
//    unsigned char result[digestLen];
//    CC_MD5(str, (CC_LONG)strLen, result);
//    
//    return __cryptos_stringFromResult(result, digestLen);
//    
//}
//
//
//NSString * cryptosSHA384WithString(NSString * string){
//    
//    const char * str = [string cStringUsingEncoding:NSUTF8StringEncoding];
//    
//    NSUInteger strLen = [string lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
//    uint32_t digestLen = CC_SHA384_DIGEST_LENGTH;
//    
//    unsigned char result[digestLen];
//    CC_MD5(str, (CC_LONG)strLen, result);
//    
//    return __cryptos_stringFromResult(result, digestLen);
//    
//}
//
//
//NSString * cryptosSHA512WithString(NSString * string){
//    
//    const char * str = [string cStringUsingEncoding:NSUTF8StringEncoding];
//    
//    NSUInteger strLen = [string lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
//    uint32_t digestLen = CC_SHA512_DIGEST_LENGTH;
//    
//    unsigned char result[digestLen];
//    CC_MD5(str, (CC_LONG)strLen, result);
//    
//    return __cryptos_stringFromResult(result, digestLen);
//    
//}
