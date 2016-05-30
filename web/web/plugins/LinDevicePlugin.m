//
//  DeviceInfoPlugin.m
//  LinWeb
//
//  Created by lin on 4/10/15.
//  Copyright (c) 2015 lin. All rights reserved.
//

#import "LinDevicePlugin.h"

@implementation LinDevicePlugin
-(Json*)productName:(Json*)args{
    return [[Json alloc] initWithObject:@"iPhone"];
}
@end
