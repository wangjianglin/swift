//
//  LinConfigParser.m
//  LinWeb
//
//  Created by lin on 4/12/15.
//  Copyright (c) 2015 lin. All rights reserved.
//

#import "LinConfigParser.h"



@interface LinConfigParser (){
    NSString* pluginName;
}

@property (nonatomic, readwrite, strong) NSMutableDictionary* plugins;
@property (nonatomic, readwrite, strong) NSMutableDictionary* settings;
@property (nonatomic, readwrite, strong) NSMutableArray* whitelist;
@property (nonatomic, readwrite, strong) NSMutableArray* startupPlugins;
@property (nonatomic, readwrite, strong) NSString* startPage;

@end

@implementation LinConfigParser

//@synthesize pluginsDict, settings, whitelistHosts, startPage, startupPluginNames;

//- (id)init
//{
//    self = [super init];
//    if (self != nil) {
//        
//    }
//    return self;
//}

- (void)parser:(NSXMLParser*)parser didStartElement:(NSString*)elementName namespaceURI:(NSString*)namespaceURI qualifiedName:(NSString*)qualifiedName attributes:(NSDictionary*)attributeDict
{
    if ([elementName isEqualToString:@"preference"]) {
        self.settings[[attributeDict[@"name"] lowercaseString]] = attributeDict[@"value"];
    } else if ([elementName isEqualToString:@"plugin"]) { // store feature name to use with correct parameter set
        pluginName = [attributeDict[@"name"] lowercaseString];
    } else if ((pluginName != nil) && [elementName isEqualToString:@"param"]) {
        NSString* paramName = [attributeDict[@"name"] lowercaseString];
        id value = attributeDict[@"value"];
        if ([paramName isEqualToString:@"ios-package"]) {
            self.plugins[pluginName] = value;
        }
        BOOL paramIsOnload = ([paramName isEqualToString:@"onload"] && [@"true" isEqualToString : value]);
        BOOL attribIsOnload = [@"true" isEqualToString :[attributeDict[@"onload"] lowercaseString]];
        if (paramIsOnload || attribIsOnload) {
            [self.startupPlugins addObject:pluginName];
        }
    } else if ([elementName isEqualToString:@"access"]) {
        [self.whitelist addObject:attributeDict[@"origin"]];
    } else if ([elementName isEqualToString:@"content"]) {
        self.startPage = attributeDict[@"src"];
    }
}

- (void)parser:(NSXMLParser*)parser didEndElement:(NSString*)elementName namespaceURI:(NSString*)namespaceURI qualifiedName:(NSString*)qualifiedName
{
    if ([elementName isEqualToString:@"plugin"]) { // no longer handling a feature so release
        pluginName = nil;
    }
}

- (void)parser:(NSXMLParser*)parser parseErrorOccurred:(NSError*)parseError
{
    NSAssert(NO, @"config.xml parse error line %ld col %ld", (long)[parser lineNumber], (long)[parser columnNumber]);
}

//@end
//
//@implementation LinConfigParser

-(instancetype)init{
    return [self initWithXML:@"web.xml"];
}
-(instancetype)initWithXML:(NSString*)xml
{
    self = [super init];
    if (self) {
       
        self.plugins = [[NSMutableDictionary alloc] initWithCapacity:30];
        self.settings = [[NSMutableDictionary alloc] initWithCapacity:30];
        self.whitelist = [[NSMutableArray alloc] initWithCapacity:30];
        [self.whitelist addObject:@"file:///*"];
        [self.whitelist addObject:@"content:///*"];
        [self.whitelist addObject:@"data:///*"];
        self.startupPlugins = [[NSMutableArray alloc] initWithCapacity:8];
        pluginName = nil;
        
        
        NSArray * defaultPlugins = @[@"LinAppPlugin",@"LinDevicePlugin",@"LinStoragePlugin",@"LinHttpDNSPlugin"];
        
        
        NSArray * defaultPluginNames = @[@"app",@"device",@"storage",@"httpDns"];
        
        for (int n=0; n<[defaultPlugins count]; n++) {
//            obj = [[NSClassFromString(defaultPlugins[n]) alloc] initWithWebView:self->_webView];
//            if (obj != nil) {
//                [pluginObjects setValue:obj forKey:defaultPluginNames[n]];
//            }
            self.plugins[[defaultPluginNames[n] lowercaseString]] = defaultPlugins[n];
        }
        
        
        LinConfigParser* delegate = self;//[[LinConfigParser alloc] init];
        
        // read from config.xml in the app bundle
        NSString* path = [[NSBundle mainBundle] pathForResource:xml ofType:nil];
        
    //    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
    //        NSAssert(NO, @"ERROR: web.xml does not exist. Please run cordova-ios/bin/cordova_plist_to_config_xml path/to/project.");
    //        return;
    //    }
        
        if (path != nil) {
        
            NSURL* url = [NSURL fileURLWithPath:path];
            
            NSXMLParser * configParser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    //        if (configParser == nil) {
    //            NSLog(@"Failed to initialize XML parser.");
    //            return;
    //        }
            [configParser setDelegate:((id < NSXMLParserDelegate >)delegate)];
            [configParser parse];
            
            // Get the plugin dictionary, whitelist and settings from the delegate.
        //    self.pluginsMap = delegate.pluginsDict;
    //        self.startupPluginNames = delegate.startupPluginNames;
    //    //    self.whitelist = [[CDVWhitelist alloc] initWithArray:delegate.whitelistHosts];
    //        self.settings = delegate.settings;
    //        
    //        // And the start folder/page.
    //    //    if(self.wwwFolderName == nil){
    //    //        self.wwwFolderName = @"www";
    //    //    }
    //        self.startPage = delegate.startPage;
            if (self.startPage == nil) {
                self.startPage = @"index.html";
            }
        }
    }
    return self;
    // Initialize the plugin objects dict.
//    self.pluginObjects = [[NSMutableDictionary alloc] initWithCapacity:20];
}

@end
