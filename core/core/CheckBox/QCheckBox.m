//
//  EICheckBox.m
//  EInsure
//
//  Created by ivan on 13-7-9.
//  Copyright (c) 2013年 ivan. All rights reserved.
//

#import "QCheckBox.h"

#define Q_CHECK_ICON_WH                    (15.0)
#define Q_ICON_TITLE_MARGIN                (5.0)

@implementation QCheckBox
    
    @synthesize delegate = _delegate;
    @synthesize checked = _checked;
    @synthesize userInfo = _userInfo;
    @synthesize type = _type;
    
- (id)initWithDelegate:(id)delegate {
    self = [super init];
    if (self) {
        _delegate = delegate;
    }
    return self;
}
    
- (id)init{
    self = [super init];
    if (self) {
        
        self.exclusiveTouch = YES;
        self.type = Check;
        [self addTarget:self action:@selector(checkboxBtnChecked) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
    
- (void)setType:(QCheckBoxType)type{
    
    NSBundle * b = [NSBundle bundleForClass:[QCheckBox class]];
    _type = type;
    if ( _type == Check ){
        //#if iOS7
        //        [self setImage:[UIImage imageNamed:@"LinCore.bundle/check/checkbox1_unchecked.png"] forState:UIControlStateNormal];
        //        [self setImage:[UIImage imageNamed:@"LinCore.bundle/check/checkbox1_checked.png"] forState:UIControlStateSelected];
        //#else
        //        [self setImage:[UIImage imageNamed:@"Frameworks/LinCore.framework/LinCore.bundle/check/checkbox1_unchecked.png"] forState:UIControlStateNormal];
        //        [self setImage:[UIImage imageNamed:@"Frameworks/LinControls.framework/LinCore.bundle/check/checkbox1_checked.png"] forState:UIControlStateSelected];
        [self setImage:[UIImage imageNamed:@"LinCore.bundle/check/checkbox1_unchecked.png" inBundle:b compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"LinCore.bundle/check/checkbox1_checked.png" inBundle:b compatibleWithTraitCollection:nil] forState:UIControlStateSelected];
        //#endif
    }else{
        //#if iOS7
        //        //
        //        [self setImage:[UIImage imageNamed:@"LinCore.bundle/check/uncheck_icon.png"] forState:UIControlStateNormal];
        //        [self setImage:[UIImage imageNamed:@"LinCore.bundle/check/check_icon.png"] forState:UIControlStateSelected];
        //#else
        //        [self setImage:[UIImage imageNamed:@"Frameworks/LinControls.framework/LinCore.bundle/check/uncheck_icon.png"] forState:UIControlStateNormal];
        //        [self setImage:[UIImage imageNamed:@"Frameworks/LinControls.framework/LinCore.bundle/check/check_icon.png"] forState:UIControlStateSelected];
        
        [self setImage:[UIImage imageNamed:@"LinCore.bundle/check/uncheck_icon.png" inBundle:b compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"LinCore.bundle/check/check_icon.png" inBundle:b compatibleWithTraitCollection:nil] forState:UIControlStateSelected];
        //#endif
    }
}
    
- (void)setChecked:(BOOL)checked {
    if (_checked == checked) {
        return;
    }
    
    _checked = checked;
    self.selected = checked;
    
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectedCheckBox:checked:)]) {
        [_delegate didSelectedCheckBox:self checked:self.selected];
    }
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}
    
- (void)checkboxBtnChecked {
    self.selected = !self.selected;
    _checked = self.selected;
    
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectedCheckBox:checked:)]) {
        [_delegate didSelectedCheckBox:self checked:self.selected];
    }
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}
    
- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    return CGRectMake(0, (CGRectGetHeight(contentRect) - Q_CHECK_ICON_WH)/2.0, Q_CHECK_ICON_WH, Q_CHECK_ICON_WH);
}
    
- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    return CGRectMake(Q_CHECK_ICON_WH + Q_ICON_TITLE_MARGIN, 0,
                      CGRectGetWidth(contentRect) - Q_CHECK_ICON_WH - Q_ICON_TITLE_MARGIN,
                      CGRectGetHeight(contentRect));
}
    
- (void)dealloc {
    //    [_userInfo release];
    //    _delegate = nil;
    //    [super dealloc];
}
    
    @end
