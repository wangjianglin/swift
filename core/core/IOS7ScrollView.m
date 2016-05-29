//
//  IOS7ScrollView.m
//  LinCore
//
//  Created by lin on 8/9/15.
//  Copyright (c) 2015 lin. All rights reserved.
//

#import "IOS7ScrollView.h"


@interface IOS7ScrollView()<UIScrollViewDelegate>{
    UIView * _view;
}
@end

@implementation IOS7ScrollView

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _view;
}
-(instancetype)init{
    self = [super init];
    
    if (self) {
        
        _view = [[UIView alloc] init];
        
        [super addSubview:_view];
        
//        [self addConstraints:
//         @[[NSLayoutConstraint constraintWithItem:_view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0],
//           [NSLayoutConstraint constraintWithItem:_view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0],
//           [NSLayoutConstraint constraintWithItem:_view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0],
//           [NSLayoutConstraint constraintWithItem:_view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:1000.0]
//           
//           ]];
        
        self.delegate = self;
        
        _view.userInteractionEnabled = TRUE;
    }
    
    return self;
}

-(void)addSubview:(UIView *)view{
    [_view addSubview:view];
}



-(void)setContentSize:(CGSize)contentSize{
    super.contentSize = contentSize;
    
    _view.frame = CGRectMake(0, 0, contentSize.width, contentSize.height);
}
@end
