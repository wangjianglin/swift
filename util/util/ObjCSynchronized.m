//
//  NSObject+ObjCSynchronized.m
//  LinUtil
//
//  Created by lin on 1/8/15.
//  Copyright (c) 2015 lin. All rights reserved.
//

#import "ObjCSynchronized.h"

void objc_synchronized(id object, void (^closure)())
{
    @synchronized(object) {
        closure();
    }
}
