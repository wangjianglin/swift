//
//  md5.m
//  books
//
//  Created by lin on 14-9-21.
//  Copyright (c) 2014年 lin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CommonCrypto/CommonCrypto.h"
#import "cryptos.h"

#define FileHashDefaultChunkSizeForReadingData 1024*8



CCHmacAlgorithm __cryptos_HMACAlgorithm(NSString * str){
    
    if ([@"MD5" isEqualToString:str]) {
        return kCCHmacAlgMD5;
    }else if ([@"SHA1" isEqualToString:str]) {
        return kCCHmacAlgSHA1;
    }else if ([@"SHA224" isEqualToString:str]) {
        return kCCHmacAlgSHA224;
    }else if ([@"SHA256" isEqualToString:str]) {
        return kCCHmacAlgSHA256;
    }else if ([@"SHA384" isEqualToString:str]) {
        return kCCHmacAlgSHA384;
    }else if ([@"SHA512" isEqualToString:str]) {
        return kCCHmacAlgSHA512;
    }
    return 0;
}


int __cryptos_digestLength(NSString * str){
    
    if ([@"MD2" isEqualToString:str]) {
        return CC_MD2_DIGEST_LENGTH;
    }else if ([@"MD4" isEqualToString:str]) {
        return CC_MD4_DIGEST_LENGTH;
    }else if ([@"MD5" isEqualToString:str]) {
        return CC_MD5_DIGEST_LENGTH;
    }else if ([@"SHA1" isEqualToString:str]) {
        return CC_SHA1_DIGEST_LENGTH;
    }else if ([@"SHA224" isEqualToString:str]) {
        return CC_SHA224_DIGEST_LENGTH;
    }else if ([@"SHA256" isEqualToString:str]) {
        return CC_SHA256_DIGEST_LENGTH;
    }else if ([@"SHA384" isEqualToString:str]) {
        return CC_SHA384_DIGEST_LENGTH;
    }else if ([@"SHA512" isEqualToString:str]) {
        return CC_SHA512_DIGEST_LENGTH;
    }
    return 0;
}

NSString * __cryptos_stringFromResult(unsigned char * result, int length) {
    NSMutableString * hash = [[NSMutableString alloc] initWithCapacity:length * 2];
    for(int i =0;i<length;i++) {
        [hash appendFormat:@"%02x",result[i]];
    }
    return hash;
}

NSString * cryptosHmac(NSString * string,NSString * key,NSString * algorithm) {
    
    const char * str = [string cStringUsingEncoding:NSUTF8StringEncoding];
    
    NSUInteger strLen = [string lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    
    
    const char * keyStr = [key cStringUsingEncoding:NSUTF8StringEncoding];
    
    NSUInteger keyLen = [key lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    
    int len = __cryptos_digestLength(algorithm);
    unsigned char result[len];
    
    CCHmac(__cryptos_HMACAlgorithm(algorithm), keyStr, keyLen, str, strLen, result);
    
    return __cryptos_stringFromResult(result, len);
}


typedef unsigned char * (* __CryptosFun)(const void *data, CC_LONG len, unsigned char *md);

__CryptosFun __cryptos_digestFun(NSString * str){
    
    if ([@"MD2" isEqualToString:str]) {
        return CC_MD2;
    }else if ([@"MD4" isEqualToString:str]) {
        return CC_MD4;
    }else if ([@"MD5" isEqualToString:str]) {
        return CC_MD5;
    }else if ([@"SHA1" isEqualToString:str]) {
        return CC_SHA1;
    }else if ([@"SHA224" isEqualToString:str]) {
        return CC_SHA224;
    }else if ([@"SHA256" isEqualToString:str]) {
        return CC_SHA256;
    }else if ([@"SHA384" isEqualToString:str]) {
        return CC_SHA384;
    }else if ([@"SHA512" isEqualToString:str]) {
        return CC_SHA512;
    }
    return 0;
}

NSString * cryptosDigestWithString(NSString * string,NSString * algorithm){
    const char * str = [string cStringUsingEncoding:NSUTF8StringEncoding];
    
    NSUInteger strLen = [string lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    int digestLen = __cryptos_digestLength(algorithm);
    
    unsigned char result[digestLen];
    __cryptos_digestFun(algorithm)(str, (CC_LONG)strLen, result);
    
    return __cryptos_stringFromResult(result, digestLen);
}

CFStringRef __cryptos_FileMD5HashCreateWithPath(CFStringRef filePath,size_t chunkSizeForReadingData) {
    
    // Declare needed variables
    
    CFStringRef result = NULL;
    
    CFReadStreamRef readStream = NULL;
    
    // Get the file URL
    
    CFURLRef fileURL =
    
    CFURLCreateWithFileSystemPath(kCFAllocatorDefault,
                                  
                                  (CFStringRef)filePath,
                                  
                                  kCFURLPOSIXPathStyle,
                                  
                                  (Boolean)false);
    
    if (!fileURL) goto done;
    
    // Create and open the read stream
    
    readStream = CFReadStreamCreateWithFile(kCFAllocatorDefault,
                                            
                                            (CFURLRef)fileURL);
    
    if (!readStream) goto done;
    
    bool didSucceed = (bool)CFReadStreamOpen(readStream);
    
    if (!didSucceed) goto done;
    
    // Initialize the hash object
    
    CC_MD5_CTX hashObject;
    
    CC_MD5_Init(&hashObject);
    
    // Make sure chunkSizeForReadingData is valid
    
    if (!chunkSizeForReadingData) {
        
        chunkSizeForReadingData = FileHashDefaultChunkSizeForReadingData;
        
    }
    
    // Feed the data to the hash object
    
    bool hasMoreData = true;
    
    while (hasMoreData) {
        
        uint8_t buffer[chunkSizeForReadingData];
        
        CFIndex readBytesCount = CFReadStreamRead(readStream,(UInt8 *)buffer,(CFIndex)sizeof(buffer));
        
        if (readBytesCount == -1) break;
        
        if (readBytesCount == 0) {
            
            hasMoreData = false;
            
            continue;
            
        }
        
        CC_MD5_Update(&hashObject,(const void *)buffer,(CC_LONG)readBytesCount);
        
    }
    
    // Check if the read operation succeeded
    
    didSucceed = !hasMoreData;
    
    // Compute the hash digest
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5_Final(digest, &hashObject);
    
    // Abort if the read operation failed
    
    if (!didSucceed) goto done;
    
    // Compute the string result
    
    char hash[2 * sizeof(digest) + 1];
    
    for (size_t i = 0; i < sizeof(digest); ++i) {
        
        snprintf(hash + (2 * i), 3, "%02x", (int)(digest[i]));
        
    }
    
    result = CFStringCreateWithCString(kCFAllocatorDefault,(const char *)hash,kCFStringEncodingUTF8);
    
    
    
done:
    
    if (readStream) {
        
        CFReadStreamClose(readStream);
        
        CFRelease(readStream);
        
    }
    
    if (fileURL) {
        
        CFRelease(fileURL);
        
    }
    
    return result;
    
}

NSString* cryptosMD5WithPath(NSString* path)
{
    return (__bridge_transfer NSString *)__cryptos_FileMD5HashCreateWithPath((__bridge CFStringRef)path, FileHashDefaultChunkSizeForReadingData);
    
}
