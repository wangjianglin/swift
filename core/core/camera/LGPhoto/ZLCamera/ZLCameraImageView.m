//
//  BQImageView.m
//  BQCommunity
//
//  Created by TJQ on 14-8-5.
//  Copyright (c) 2014年 beiqing. All rights reserved.
//

#import "ZLCameraImageView.h"
#import "UIView+Layout.h"
//#import "UIImage+ZLPhotoLib.h"

@interface ZLCameraImageView ()

@end

@implementation ZLCameraImageView


- (UIImageView *)deleBjView{
    if (!_deleBjView) {
        _deleBjView = [[UIImageView alloc] init];
        _deleBjView.hidden = YES;
        _deleBjView.contentMode = UIViewContentModeScaleAspectFit;
        _deleBjView.userInteractionEnabled = YES;
          UISwipeGestureRecognizer *_swipe;
         _swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(deleImage:)];
         _swipe.direction = UISwipeGestureRecognizerDirectionUp;
        [_deleBjView addGestureRecognizer:_swipe];
        [self addSubview:_deleBjView];
    }
    return _deleBjView;
}

- (void)setEdit:(BOOL)edit{
    self.deleBjView.hidden = NO;
}

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
    }
    return self;
}

#pragma mark 删除图片
- (void) deleImage : ( UISwipeGestureRecognizer *) tap{
    if ([self.delegatge respondsToSelector:@selector(deleteImageView:)]) {
        [self.delegatge deleteImageView:self];
    }
}

@end
