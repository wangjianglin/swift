//
//  NSObject_volatile_void_exceptionHandler_NSException__exception___UncaughtExceptionHandler.h
//  LinCore
//
//  Created by lin on 2/2/15.
//  Copyright (c) 2015 lin. All rights reserved.
//

#import <Foundation/Foundation.h>


//void exceptionHandler(NSException *exception);
//extern NSUncaughtExceptionHandler *exceptionHandlerPtr;


@interface UncaughtExceptionHandler : NSObject

+(void)setExceptionHandler:(void(^)(NSException * )) handle;
@end