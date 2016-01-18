//
//  md5.m
//  books
//
//  Created by lin on 14-9-21.
//  Copyright (c) 2014年 lin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CommonCrypto/CommonDigest.h"
#import "md5.h"

#define FileHashDefaultChunkSizeForReadingData 1024*8




CFStringRef FileMD5HashCreateWithPath(CFStringRef filePath,size_t chunkSizeForReadingData) {
    
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

NSString* md5WithPath(NSString* path)
{
    return (__bridge_transfer NSString *)FileMD5HashCreateWithPath((__bridge CFStringRef)path, FileHashDefaultChunkSizeForReadingData);
    
}

NSString * md5WithString(NSString * string){
    //let str = self.cStringUsingEncoding(NSUTF8StringEncoding)
    const char * str = [string cStringUsingEncoding:NSUTF8StringEncoding];
    
    //let strLen = CC_LONG(self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
    uint32_t strLen = [string lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
//    let digestLen = Int(CC_MD5_DIGEST_LENGTH)
    int digestLen = CC_MD5_DIGEST_LENGTH;
//    let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLen);
    
    char result[digestLen];
    CC_MD5(str, strLen, result);
    
    //CC_MD5(str!, strLen, result);
    
//    var hash = NSMutableString();
    NSMutableString * hash = [[NSMutableString alloc] init];
    //for i in 0 ..< digestLen {
    for(int i = 0;i<digestLen;i++){
        //hash.appendFormat("%02x", result[i]);
        [hash appendFormat:@"%02x", result[i] ];
    }
//    result.destroy();
    
//    return String(format: hash)
     return [[NSString alloc] initWithFormat:hash];
    //return [NSString alloc] initW
}

