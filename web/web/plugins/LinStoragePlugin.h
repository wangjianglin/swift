//
//  LinStoragePlugin.h
//  web
//
//  Created by lin on 14-9-22.
//
//

#import <Foundation/Foundation.h>
#import "LinWebPlugin.h"


@interface LinStoragePlugin:LinWebPlugin

-(Json*)setItem:(Json*)args;
-(NSString*)getItem:(Json*)args;
-(Json*)removeItem:(Json*)args;

@end
