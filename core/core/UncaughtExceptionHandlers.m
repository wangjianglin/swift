//
//  NSObject_volatile_void_exceptionHandler_NSException__exception___UncaughtExceptionHandler.h
//  LinCore
//
//  Created by lin on 2/2/15.
//  Copyright (c) 2015 lin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UncaughtExceptionHandlers.h"
//@interface NSUncaughtExceptionHandler : NSObject ()
//volatile void exceptionHandler(NSException *exception);
//extern NSUncaughtExceptionHandler *exceptionHandlerPtr;
//@end
//volatile void exceptionHandler(NSException *exception);
//extern NSUncaughtExceptionHandler *exceptionHandlerPtr;
//(void (^)())callback
//void setUncaughtExceptionHandler((void (^)(id)) * action);
//void setUncaughtExceptionHandler((void (^action)(NSException *exception))){
//    
//}


//void exceptionHandler(NSException *exception) {
//    //    [[RavenClient sharedClient] captureException:exception];
//    NSLog(@"ok.");
//}
//
//NSUncaughtExceptionHandler *exceptionHandlerPtr = &exceptionHandler;


void(^exceptionHandlerAction)(NSException * );

void exceptionHandler(NSException *exception){
    //NSLog(@"ok.");
    exceptionHandlerAction(exception);
}


@implementation UncaughtExceptionHandler

+(void)setExceptionHandler:(void(^)(NSException * )) handle{
    exceptionHandlerAction = handle;
    NSSetUncaughtExceptionHandler(exceptionHandler);
}


@end

//volatile void exceptionHandler(NSException *exception) {
//    // Do stuff
//    NSLog(@"ok.");
//}
//NSUncaughtExceptionHandler *exceptionHandlerPtr = &exceptionHander;