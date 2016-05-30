//
//  CDVStoragePlugin.m
//  ses
//
//  Created by lin on 14-9-22.
//
//

#import "LinStoragePlugin.h"
#import "ChromeStorage.h"

@implementation LinStoragePlugin


-(Json*)setItem:(Json*)args{
    NSString * item = args[@"item"].asString;
    NSString * value = args[@"value"].asString;
    [ChromeStorage setItem:item value:value];
    return nil;
}
-(NSObject*)getItem:(Json*)args{
    NSString * item = args[@"item"].asString;
    NSString * value = [ChromeStorage getItem:item];
    if(value == nil){
//        return @"{}";
        return [[Json alloc] init];
    }
//    return value;
    return [Json parse:value];
//    return [[Json alloc] initWithObject:value];
}
-(Json*)removeItem:(Json*)args{
    NSString * item = args[@"item"].asString;
    [ChromeStorage removeItem:item];
    return nil;
}
@end
