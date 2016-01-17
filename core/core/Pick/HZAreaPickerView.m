//
//  HZAreaPickerView.m
//  areapicker
//
//  Created by Cloud Dai on 12-9-9.
//  Copyright (c) 2012年 clouddai.com. All rights reserved.
//

#import "HZAreaPickerView.h"
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
//#import <LinCore/LinCore-Swift.h>

#define kDuration 0.3


//@interface HZAreaPickerDelegateImpl : DelegateAction<HZAreaPickerDelegate>
//- (void)pickerDidChaneStatus:(HZAreaPickerView *)picker;
//@end

//@implementation HZAreaPickerDelegateImpl
//
//
//
//- (void)pickerDidChaneStatus:(HZAreaPickerView *)picker{
//    
//}
//
//@end


@interface HZAreaPickerView ()
{
    NSArray *provinces, *cities, *areas;
    
    
}

-(IBAction)okClick:(id)sender;

-(IBAction)cancelClick:(id)sender;
@end


@implementation HZAreaPickerView

@synthesize target=_target;
@synthesize pickerStyle=_pickerStyle;
@synthesize locate=_locate;
@synthesize locatePicker = _locatePicker;

//- (void)dealloc
//{
//    [_locate release];
//    [_locatePicker release];
//    [provinces release];
//    [super dealloc];
//}

-(HZLocation *)locate
{
    if (_locate == nil) {
        _locate = [[HZLocation alloc] init];
    }
    
    return _locate;
}

-(IBAction)okClick:(id)sender{
    [self cancelPicker];
//    if([self.delegate respondsToSelector:@selector(pickerDidChaneStatus:)]) {
//        //        [self.delegate pickerDidChaneStatus:self];
//        //    }
    if([self.target respondsToSelector:self.action]){
        //self.delegate performSelector(
        NSObject * targetObj = (NSObject *)self.target;
        [targetObj performSelector:self.action withObject:self];
        
    }
}

-(IBAction)cancelClick:(id)sender{
    [self cancelPicker];
}
//- (id)initWithStyle:(HZAreaPickerStyle)pickerStyle delegate:(id<HZAreaPickerDelegate>)delegate
- (id)initWithStyle:(HZAreaPickerStyle)pickerStyle data:(NSArray *)data
{
    
#if iOS7
    self = [[[NSBundle mainBundle] loadNibNamed:@"HZAreaPickerView" owner:self options:nil] objectAtIndex:0];
#else
    self = [[[NSBundle mainBundle] loadNibNamed:@"Frameworks/LinControls.framework/HZAreaPickerView" owner:self options:nil] objectAtIndex:0];
#endif
    if (self) {
        self.backgroundColor = [[UIColor alloc] initWithRed:0.8 green:0.8 blue:0.8 alpha:0.97];
//        self.delegate = delegate;
        self.pickerStyle = pickerStyle;
        self.locatePicker.dataSource = self;
        self.locatePicker.delegate = self;
        
        provinces = data;
        //加载数据
        if (self.pickerStyle == HZAreaPickerWithStateAndCityAndDistrict) {
//            provinces = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"area.plist" ofType:nil]];
            cities = [[provinces objectAtIndex:0] objectForKey:@"cities"];
            
            self.locate.state = [[provinces objectAtIndex:0] objectForKey:@"state"];
            self.locate.city = [[cities objectAtIndex:0] objectForKey:@"city"];
            
            areas = [[cities objectAtIndex:0] objectForKey:@"areas"];
            if (areas.count > 0) {
                self.locate.district = [areas objectAtIndex:0];
            } else{
                self.locate.district = @"";
            }
            
        } else{
//            provinces = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"city.plist" ofType:nil]];
            cities = [[provinces objectAtIndex:0] objectForKey:@"cities"];
            self.locate.state = [[provinces objectAtIndex:0] objectForKey:@"state"];
            self.locate.city = [cities objectAtIndex:0];
        }
    }
        
    return self;
    
}



#pragma mark - PickerView lifecycle

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (self.pickerStyle == HZAreaPickerWithStateAndCityAndDistrict) {
        return 3;
    } else{
        return 2;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return [provinces count];
            break;
        case 1:
            return [cities count];
            break;
        case 2:
            if (self.pickerStyle == HZAreaPickerWithStateAndCityAndDistrict) {
                return [areas count];
                break;
            }
        default:
            return 0;
            break;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (self.pickerStyle == HZAreaPickerWithStateAndCityAndDistrict) {
        switch (component) {
            case 0:
                return [[provinces objectAtIndex:row] objectForKey:@"state"];
                break;
            case 1:
                return [[cities objectAtIndex:row] objectForKey:@"city"];
                break;
            case 2:
                if ([areas count] > 0) {
                    return [areas objectAtIndex:row];
                    break;
                }
            default:
                return  @"";
                break;
        }
    } else{
        switch (component) {
            case 0:
                return [[provinces objectAtIndex:row] objectForKey:@"state"];
                break;
            case 1:
                return [cities objectAtIndex:row];
                break;
            default:
                return @"";
                break;
        }
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (self.pickerStyle == HZAreaPickerWithStateAndCityAndDistrict) {
        switch (component) {
            case 0:
                cities = [[provinces objectAtIndex:row] objectForKey:@"cities"];
                [self.locatePicker selectRow:0 inComponent:1 animated:YES];
                [self.locatePicker reloadComponent:1];
                
                areas = [[cities objectAtIndex:0] objectForKey:@"areas"];
                [self.locatePicker selectRow:0 inComponent:2 animated:YES];
                [self.locatePicker reloadComponent:2];
                
                self.locate.state = [[provinces objectAtIndex:row] objectForKey:@"state"];
                self.locate.city = [[cities objectAtIndex:0] objectForKey:@"city"];
                if ([areas count] > 0) {
                    self.locate.district = [areas objectAtIndex:0];
                } else{
                    self.locate.district = @"";
                }
                break;
            case 1:
                areas = [[cities objectAtIndex:row] objectForKey:@"areas"];
                [self.locatePicker selectRow:0 inComponent:2 animated:YES];
                [self.locatePicker reloadComponent:2];
                
                self.locate.city = [[cities objectAtIndex:row] objectForKey:@"city"];
                if ([areas count] > 0) {
                    self.locate.district = [areas objectAtIndex:0];
                } else{
                    self.locate.district = @"";
                }
                break;
            case 2:
                if ([areas count] > 0) {
                    self.locate.district = [areas objectAtIndex:row];
                } else{
                    self.locate.district = @"";
                }
                break;
            default:
                break;
        }
    } else{
        switch (component) {
            case 0:
                cities = [[provinces objectAtIndex:row] objectForKey:@"cities"];
                [self.locatePicker selectRow:0 inComponent:1 animated:YES];
                [self.locatePicker reloadComponent:1];
                
                self.locate.state = [[provinces objectAtIndex:row] objectForKey:@"state"];
                self.locate.city = [cities objectAtIndex:0];
                break;
            case 1:
                self.locate.city = [cities objectAtIndex:row];
                break;
            default:
                break;
        }
    }
    
//    if([self.delegate respondsToSelector:@selector(pickerDidChaneStatus:)]) {
//        [self.delegate pickerDidChaneStatus:self];
//    }

}


#pragma mark - animation

- (void)showInView:(UIView *) view
{
    self.frame = CGRectMake(0, view.frame.size.height, self.frame.size.width, self.frame.size.height);
    [view addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, view.frame.size.height - self.frame.size.height, self.frame.size.width, self.frame.size.height);
    }];
    
}

- (void)cancelPicker
{
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.frame = CGRectMake(0, self.frame.origin.y+self.frame.size.height, self.frame.size.width, self.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         [self removeFromSuperview];
                         
                     }];
    
}


//-(void)setDelegateAction:(void(^)(HZLocation *))action{
//    
////    DelegateAction * a;
//    EventDelegateAction * ea = [[EventDelegateAction alloc] initWithAction:action];
//    ea.withObjectSameLifecycle = self;
//    //self.delegate
//}
@end




