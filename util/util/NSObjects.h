//
//  NSObject+NSObjects.h
//  LinUtil
//
//  Created by lin on 2/10/15.
//  Copyright (c) 2015 lin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <objc/message.h>

@interface NSObject (NSObjects)
- (id)performSelector:(SEL)selector withObjects:(NSArray *)objects;
@end



NS_ASSUME_NONNULL_BEGIN

const IMP _rac_objc_msgForward;

/// A trampoline of `objc_setAssociatedObject` that is made to circumvent the
/// reference counting calls in the imported version in Swift.
void rac_objc_setAssociatedObject(const void* object, const void* key, id _Nullable value, objc_AssociationPolicy policy);

NS_ASSUME_NONNULL_END

