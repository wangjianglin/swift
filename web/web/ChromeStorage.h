// Copyright (c) 2012 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import <Foundation/Foundation.h>
//#import <Cordova/CDVPlugin.h>

//@interface ChromeStorage : CDVPlugin
//
//- (CDVPlugin*)initWithWebView:(UIWebView*)theWebView;
//
//- (void)get:(CDVInvokedUrlCommand*)command;
//- (void)getBytesInUse:(CDVInvokedUrlCommand*)command;
//- (void)set:(CDVInvokedUrlCommand*)command;
//- (void)remove:(CDVInvokedUrlCommand*)command;
//- (void)clear:(CDVInvokedUrlCommand*)command;

@interface ChromeStorage : NSObject 
+(void)setItem:(NSString*)key value:(NSString*)value;
+(NSString *)getItem:(NSString*)key;
+(void)removeItem:(NSString*)key;
+(void)removeAll;
@end
