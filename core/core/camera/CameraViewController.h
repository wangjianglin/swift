//
//  CameraViewController.h
//  LinCore
//
//  Created by lin on 7/20/15.
//  Copyright (c) 2015 lin. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "SCRecorder/SCRecorder.h"
#import "SCRecorder.h"

//#import "SCRecorder/SCRecorder.h"

@protocol CameraViewDelegate <NSObject>

@optional
- (void)cameraViewResponse:(NSURL*)file;


@end

@interface CameraViewController : UIViewController

@property(nonatomic, assign) id<CameraViewDelegate> delegate;

- (instancetype)initWithMaxInterval:(NSTimeInterval)interval;
//+(NSURL*)coverVedio:(NSURL*)url;

@end

//@interface CameraViewController(DelegateAction)
//
//-(void)setResult:(void(^)(NSURL * file))result;
//
//@end
