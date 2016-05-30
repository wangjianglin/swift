//
//  HttpDNSPlugin.m
//  LinWeb
//
//  Created by lin on 5/4/16.
//  Copyright © 2016 lin. All rights reserved.
//

#import "LinHttpDNSPlugin.h"

@implementation LinHttpDNSPlugin

-(Json *)proxy{
    NSDictionary *proxySettings = CFBridgingRelease(CFNetworkCopySystemProxySettings());
    
    NSArray *proxies = nil;
    
    NSURL *url = [[NSURL alloc] initWithString:@"http://api.m.taobao.com"];
    
    proxies = CFBridgingRelease(CFNetworkCopyProxiesForURL((__bridge CFURLRef)url,
                                                           (__bridge CFDictionaryRef)proxySettings));
    
    Boolean isProxy = NO;
    if (proxies > 0)
    {
        NSDictionary *settings = [proxies objectAtIndex:0];
        NSString* host = [settings objectForKey:(NSString *)kCFProxyHostNameKey];
        NSString* port = [settings objectForKey:(NSString *)kCFProxyPortNumberKey];
        
        if (host || port)
        {
            isProxy = YES;
        }
    }
    return [[Json alloc] initWithObject:[[NSNumber alloc] initWithBool:isProxy]];
}
@end
