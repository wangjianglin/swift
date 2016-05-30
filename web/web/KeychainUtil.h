//
//  KeychainUtil.h
//  ses
//
//  Created by lin on 14-7-7.
//
//

#import <Foundation/Foundation.h>

@interface KeychainUtil : NSObject{
    
}
@property NSString* service;

-(id) initWithService:(NSString *)service;

- (void)save:(NSString *)key data:(id)value ;

- (id)load:(NSString *)key;

- (void)delete:(NSString *)key;

@end
