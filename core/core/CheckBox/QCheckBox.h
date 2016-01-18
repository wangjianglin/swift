//
//  EICheckBox.h
//  EInsure
//
//  Created by ivan on 13-7-9.
//  Copyright (c) 2013年 ivan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QCheckBoxDelegate;

//typedef
//enum QCheckBoxType{
//    Check=0,
//    Radio=1
//} ;

typedef NS_ENUM(NSInteger, QCheckBoxType)
{
    Check=0,
    Radio=1
};

//SWIFT
//@SWIFT()
@interface QCheckBox : UIButton {
    id<QCheckBoxDelegate> __unsafe_unretained _delegate;
    BOOL _checked;
    id _userInfo;
    enum QCheckBoxType _type;
}

@property(nonatomic, assign)id<QCheckBoxDelegate> delegate;
@property(nonatomic, assign)BOOL checked;
@property(nonatomic, assign)enum QCheckBoxType type;
@property(nonatomic, retain)id userInfo;

- (id)initWithDelegate:(id)delegate;

@end

@protocol QCheckBoxDelegate <NSObject>

@optional

- (void)didSelectedCheckBox:(QCheckBox *)checkbox checked:(BOOL)checked;

@end


