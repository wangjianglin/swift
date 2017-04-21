//
//  ViewController.h
//  LinUtil
//
//  Created by lin on 9/19/16.
//  Copyright © 2016 lin. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface KeyValueDatabase : NSObject

+(KeyValueDatabase*)open: (NSString *)path;



-(int)getItemID:(NSString*)key;


-(void)setItem:(NSString*)key value:(NSString*)value;

-(NSString *)getItem:(NSString*)key;

-(void)removeItem:(NSString*)key;

-(void)removeAll;
@end
