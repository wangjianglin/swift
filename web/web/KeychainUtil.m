//
//  KeychainUtil.m
//  ses
//
//  Created by lin on 14-7-7.
//
//

#import "KeychainUtil.h"

@implementation KeychainUtil

-(id)initWithService:(NSString *)service{
    self = [super init];
    if(self != nil){
        self.service = service;
    }
    return  self;
}
- (NSMutableDictionary *)getKeychainQuery {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (__bridge_transfer id)kSecClassGenericPassword,(__bridge_transfer id)kSecClass,
            self.service, (__bridge_transfer id)kSecAttrService,
            self.service, (__bridge_transfer id)kSecAttrAccount,
            (__bridge_transfer id)kSecAttrAccessibleAfterFirstUnlock,(__bridge_transfer id)kSecAttrAccessible,
            nil];
}

- (void)save:(NSString *)key data:(id)value {
    
    NSMutableDictionary *keychainQuery = [self getKeychainQuery];
    //Delete old item before add new item
    SecItemDelete((__bridge_retained CFDictionaryRef)keychainQuery);
    //Add new object to search dictionary(Attention:the data format)
    NSMutableDictionary * tmpData = [self loadAll];
    if(tmpData == nil){
        tmpData = [[NSMutableDictionary alloc] init];
    }
    [tmpData setObject:value forKey:key];
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:tmpData] forKey:(__bridge_transfer id)kSecValueData];
    //Add item to keychain with the search dictionary
    OSStatus s = SecItemAdd((__bridge_retained CFDictionaryRef)keychainQuery, NULL);
    
}

- (id)loadAll {
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery];
    //Configure the search setting
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(__bridge_transfer id)kSecReturnData];
    [keychainQuery setObject:(__bridge_transfer id)kSecMatchLimitOne forKey:(__bridge_transfer id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((__bridge_retained CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge_transfer NSData *)keyData];
        } @catch (NSException *e) {
            NSLog(@"Unarchive of %@ failed: %@", self.service, e);
        } @finally {
        }
    }
    return ret;
}
- (id)load:(NSString *)key {
    NSMutableDictionary * data = [self loadAll];
    if(data == nil){
        return  nil;
    }
    return  [data objectForKey:key];
}

- (void)delete:(NSString *)key {
    NSMutableDictionary *keychainQuery = [self getKeychainQuery];
    SecItemDelete((__bridge_retained CFDictionaryRef)keychainQuery);
}

@end
