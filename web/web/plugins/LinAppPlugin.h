//
//  LinAppPlugin.h
//  web
//
//  Created by lin on 14-6-27.
//
//

#import <Foundation/Foundation.h>
#import "LinWebPlugin.h"
#import "AsynResult.h"

@interface LinAppPlugin : LinWebPlugin

-(Json *)identifier:(Json *)args;

-(Json *)version:(Json *)args;

-(Json *)bulid:(Json *)args;

-(Json*)copy:(Json*)args;

-(Json *)saveImage:(Json *)args;

-(Json*)info:(Json*)args;

-(Json*)alert:(Json*)args;

-(AsynResult*)confirm:(Json*)args;
//-(Json*)confirm:(Json*)args;

-(Json*)openUrl:(Json*)args;


//- (void)openURL:(CDVInvokedUrlCommand*)command;
//
//- (void)getDir:(CDVInvokedUrlCommand*)command;
//
//- (void)createDocumentDir:(CDVInvokedUrlCommand*)command;
//
//- (void)getDocumentFiles:(CDVInvokedUrlCommand*)command;
//
//- (void)uuid:(CDVInvokedUrlCommand*)command;
//
////+ (NSString*)getUUID;
//
//- (void)notification:(CDVInvokedUrlCommand*)command;
//
//- (void)cancelAllLocalNotifications:(CDVInvokedUrlCommand*)command;
//
//- (void)version:(CDVInvokedUrlCommand*)command;
//
//- (void)applicationIconBadgeNumber:(CDVInvokedUrlCommand*)command;

//-(Json*)version:(Json*)args;
@end
