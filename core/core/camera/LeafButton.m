//
//  LeafButton.m
//  LeafButton
//
//  Created by Wang on 14-7-16.
//  Copyright (c) 2014年 Wang. All rights reserved.
//

#import "LeafButton.h"
//#define LINEWIDTHRATE 0.06f

@interface LeafButton(){
    BOOL _enable;
    //边框
    CAShapeLayer * _circleBorder;
    CAShapeLayer * _inCircleLayer;
    CGFloat _lineWidth;
}
//@property (nonatomic,strong) CAShapeLayer *inCircleLayer;
//@property (nonatomic,assign) CGFloat lineWidth;
@end
@implementation LeafButton

-(BOOL)enable{
    return _enable;
}

-(void)setEnable:(BOOL)enable{
    if (_enable == enable) {
        return;
    }
    _enable = enable;
    [self setTypeImpl:_type];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _enable = TRUE;
        _lineWidth = frame.size.width * 0.06f;
        //边框
        _circleBorder = [CAShapeLayer layer];
        _circleBorder.frame = self.bounds;
//        circleBorder.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(frame.size.width/2, frame.size.height/2) radius:frame.size.width/2 startAngle:0 endAngle:M_PI*2 clockwise:NO].CGPath;
        _circleBorder.borderWidth = _lineWidth;
        _circleBorder.borderColor = [UIColor whiteColor].CGColor;
        _circleBorder.cornerRadius = frame.size.width/2;
        [self.layer addSublayer:_circleBorder];
        
        //内部圆形
        _inCircleLayer = [CAShapeLayer layer];
//        _inCircleLayer.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(frame.size.width/2, frame.size.height/2) radius:(frame.size.width-lineWidth)/2-2 startAngle:0 endAngle:M_PI*2 clockwise:NO].CGPath;
        _inCircleLayer.frame = CGRectMake(_lineWidth+2, _lineWidth+2, frame.size.width-(_lineWidth+2)*2, frame.size.height-(_lineWidth+2)*2);
        _inCircleLayer.cornerRadius = _inCircleLayer.frame.size.width/2;
        _inCircleLayer.backgroundColor = [UIColor whiteColor].CGColor;
        [self.layer addSublayer:_inCircleLayer];
        
        _type = LeafButtonTypeCamera;
        _state = LeafButtonStateNormal;
    }
    return self;
}
-(void)setType:(LeafButtonType)type{
    
    if(_type != type){
        _type =  type;
    
        [self setTypeImpl:type];
        [self setState:LeafButtonStateNormal];
        
    }
}

-(void)setTypeImpl:(LeafButtonType)type{
    
    //    if(_type != type){
    _type =  type;
    
    [_inCircleLayer removeAllAnimations];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    animation.duration = 0.3f;
    animation.fromValue = (id)_inCircleLayer.backgroundColor;
    if(type == LeafButtonTypeCamera){
        
        
        animation.toValue = (id)[UIColor whiteColor].CGColor;
        [_inCircleLayer addAnimation:animation forKey:@"backgroundColor"];
        _inCircleLayer.backgroundColor = [UIColor whiteColor].CGColor;
        
        if (_enable) {
            _inCircleLayer.opacity = 1.0;
            _circleBorder.opacity = 1.0;
        }else{
            _inCircleLayer.opacity = 0.2;
            _circleBorder.opacity = 0.2;
        }
        
    }else if(type == LeafButtonTypeVideo){
        
        animation.toValue = (id)[UIColor redColor].CGColor;
        [_inCircleLayer addAnimation:animation forKey:@"backgroundColor"];
        _inCircleLayer.backgroundColor = [UIColor redColor].CGColor;
        
        if (_enable) {
            _inCircleLayer.opacity = 1.0;
            _circleBorder.opacity = 1.0;
        }else{
            _inCircleLayer.opacity = 0.2;
            _circleBorder.opacity = 0.2;
        }
    }
    
    //    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    _inCircleLayer.opacity = 0.5;
}
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"%@",NSStringFromSelector(_cmd));
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if (!_enable) {
        return;
    }
    _inCircleLayer.opacity = 1.0f;

    
    if(self.type==LeafButtonTypeVideo){
        [self setState:(self.state+1)%2];
        if(self.clickedBlock){
            self.clickedBlock(self);
        }
    }else if(self.type == LeafButtonTypeCamera){
        if(self.clickedBlock){
            self.clickedBlock(self);
        }
    }
}
-(void)setState:(LeafButtonState)state{
    if(_state != state){
        if(self.type == LeafButtonTypeVideo){
            
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
            CABasicAnimation *animationBounds = [CABasicAnimation animationWithKeyPath:@"bounds"];
            animation.duration = animationBounds.duration = 0.2f;
            animation.fromValue = @(_inCircleLayer.cornerRadius);
            CGRect bounds = _inCircleLayer.bounds;
            animationBounds.fromValue = [NSValue valueWithCGRect:bounds];
            if(state == LeafButtonStateSelected){
                animation.toValue = @(5);
                bounds.size.width = self.bounds.size.width*0.5;
                bounds.size.height = self.bounds.size.height*0.5;
                animationBounds.toValue = [NSValue valueWithCGRect:bounds];
                _inCircleLayer.cornerRadius = 5.0f;
                _inCircleLayer.bounds = bounds;
            }else if(state == LeafButtonStateNormal){
                
                bounds.size.width = self.frame.size.width-(_lineWidth+2)*2;
                bounds.size.height = self.frame.size.height-(_lineWidth+2)*2;
                animationBounds.toValue = [NSValue valueWithCGRect:bounds];
                animation.toValue = @(bounds.size.width/2);
                _inCircleLayer.cornerRadius = bounds.size.width/2;
                _inCircleLayer.bounds = bounds;
            }
            [_inCircleLayer addAnimation:animation forKey:@"cornerRadius"];
            [_inCircleLayer addAnimation:animationBounds forKey:@"bounds"];
            CAAnimationGroup *group = [CAAnimationGroup animation];
            group.duration = 0.2f;
            group.delegate = self;
            group.removedOnCompletion = YES;
            group.animations = @[animationBounds,animation];
            [_inCircleLayer addAnimation:group forKey:@"group"];
        }
        _state = state;
    }
}
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
//    if(flag && self.clickedBlock){
//        self.clickedBlock(self);
//    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
