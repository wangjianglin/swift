//
//  LinConfigParser.h
//  LinWeb
//
//  Created by lin on 4/12/15.
//  Copyright (c) 2015 lin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LinConfigParser : NSObject<NSXMLParserDelegate>

-(instancetype)initWithXML:(NSString*)xml;
-(instancetype)init;
@property (nonatomic, readonly, strong) NSMutableDictionary* plugins;
@property (nonatomic, readonly, strong) NSMutableDictionary* settings;
@property (nonatomic, readonly, strong) NSMutableArray* whitelist;
@property (nonatomic, readonly, strong) NSMutableArray* startupPlugins;
@property (nonatomic, readonly, strong) NSString* startPage;
@end


