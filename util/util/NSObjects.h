//
//  NSObject+NSObjects.h
//  LinUtil
//
//  Created by lin on 2/10/15.
//  Copyright (c) 2015 lin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (NSObjects)
- (id)performSelector:(SEL)selector withObjects:(NSArray *)objects;
@end
