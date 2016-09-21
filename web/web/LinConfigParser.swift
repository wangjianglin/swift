//
//  LinConfigParser.swift
//  LinWeb
//
//  Created by lin on 6/10/16.
//  Copyright © 2016 lin. All rights reserved.
//

import Foundation


class LinConfigParser:NSObject,XMLParserDelegate {
    
//}@interface LinConfigParser (){
//    NSString* pluginName;
//}
//
//@property (nonatomic, readwrite, strong) NSMutableDictionary* plugins;
//@property (nonatomic, readwrite, strong) NSMutableDictionary* settings;
//@property (nonatomic, readwrite, strong) NSMutableArray* whitelist;
//@property (nonatomic, readwrite, strong) NSMutableArray* startupPlugins;
//@property (nonatomic, readwrite, strong) NSString* startPage;
//
//@end
//
//@implementation LinConfigParser
//
////@synthesize pluginsDict, settings, whitelistHosts, startPage, startupPluginNames;
//
////- (id)init
////{
////    self = [super init];
////    if (self != nil) {
////
////    }
////    return self;
////}
//
//- (void)parser:(NSXMLParser*)parser didStartElement:(NSString*)elementName namespaceURI:(NSString*)namespaceURI qualifiedName:(NSString*)qualifiedName attributes:(NSDictionary*)attributeDict
//{
//    if ([elementName isEqualToString:@"preference"]) {
//        self.settings[[attributeDict[@"name"] lowercaseString]] = attributeDict[@"value"];
//    } else if ([elementName isEqualToString:@"plugin"]) { // store feature name to use with correct parameter set
//        pluginName = [attributeDict[@"name"] lowercaseString];
//    } else if ((pluginName != nil) && [elementName isEqualToString:@"param"]) {
//        NSString* paramName = [attributeDict[@"name"] lowercaseString];
//        id value = attributeDict[@"value"];
//        if ([paramName isEqualToString:@"ios-package"]) {
//            self.plugins[pluginName] = value;
//        }
//        BOOL paramIsOnload = ([paramName isEqualToString:@"onload"] && [@"true" isEqualToString : value]);
//        BOOL attribIsOnload = [@"true" isEqualToString :[attributeDict[@"onload"] lowercaseString]];
//        if (paramIsOnload || attribIsOnload) {
//            [self.startupPlugins addObject:pluginName];
//        }
//    } else if ([elementName isEqualToString:@"access"]) {
//        [self.whitelist addObject:attributeDict[@"origin"]];
//    } else if ([elementName isEqualToString:@"content"]) {
//        self.startPage = attributeDict[@"src"];
//    }
//    }
//    
//    - (void)parser:(NSXMLParser*)parser didEndElement:(NSString*)elementName namespaceURI:(NSString*)namespaceURI qualifiedName:(NSString*)qualifiedName
//{
//    if ([elementName isEqualToString:@"plugin"]) { // no longer handling a feature so release
//        pluginName = nil;
//    }
//    }
//    
//    - (void)parser:(NSXMLParser*)parser parseErrorOccurred:(NSError*)parseError
//{
//    NSAssert(NO, @"config.xml parse error line %ld col %ld", (long)[parser lineNumber], (long)[parser columnNumber]);
//}
//
////@end
////
////@implementation LinConfigParser
//
//-(instancetype)init{
//    return [self initWithXML:@"web.xml"];
//}
//-(instancetype)initWithXML:(NSString*)xml
//{
    private var _pluginName:String?
    
    private var _plugins = Dictionary<String,AnyClass>();
    var plugins:Dictionary<String,AnyClass>{
        return _plugins;
    }
    
    private var _startPlugins = [String]();
    var startPlugins:[String]{
        return _startPlugins;
    }
    private var _settings = Dictionary<String,String>();
    var settings:Dictionary<String,String>{
        return _settings;
    }
    
    private var _whitelist = [String]();
    var whitelist:[String]{
        return _whitelist;
    }
    
    private var _startPage:String!;
    var startPage:String{
        return _startPage;
    }
    
    convenience override init(){
        self.init(xml: "web.xml")
    }
    
    init(xml:String){
        super.init();
//    }
//    self = [super init];
//    if (self) {
//        
//        self.plugins = [[NSMutableDictionary alloc] initWithCapacity:30];
//        self.settings = [[NSMutableDictionary alloc] initWithCapacity:30];
//        self.whitelist = [[NSMutableArray alloc] initWithCapacity:30];
//        [self.whitelist addObject:@"file:///*"];
//        [self.whitelist addObject:@"content:///*"];
//        [self.whitelist addObject:@"data:///*"];
//        self.startupPlugins = [[NSMutableArray alloc] initWithCapacity:8];
//        pluginName = nil;
//        
//        
//        NSArray * defaultPlugins = @[@"LinAppPlugin",@"LinDevicePlugin",@"LinStoragePlugin",@"LinHttpDNSPlugin"];
//        
//        let defaultPlugins = ["LinWeb.LinAppPlugin","LinDevicePlugin","LinStoragePlugin","LinHttpDNSPlugin"]
        let defaultPlugins:[AnyClass] = [LinAppPlugin.self,LinDevicePlugin.self,LinStoragePlugin.self,LinHttpDNSPlugin.self];
        let defaultPluginNames = ["app","device","storage","httpDns"];
        
        for n in 0 ..< defaultPlugins.count {
//            if let cls = NSClassFromString(defaultPlugins[n]){
//            _plugins[defaultPluginNames[n].lowercased()] = cls;
//            }
            _plugins[defaultPluginNames[n].lowercased()] = defaultPlugins[n];
        }
//        
//        NSArray * defaultPluginNames = @[@"app",@"device",@"storage",@"httpDns"];
//        
//        for (int n=0; n<[defaultPlugins count]; n++) {
//            //            obj = [[NSClassFromString(defaultPlugins[n]) alloc] initWithWebView:self->_webView];
//            //            if (obj != nil) {
//            //                [pluginObjects setValue:obj forKey:defaultPluginNames[n]];
//            //            }
//            self.plugins[[defaultPluginNames[n] lowercaseString]] = defaultPlugins[n];
//        }
//        
//        
//        LinConfigParser* delegate = self;//[[LinConfigParser alloc] init];
//        
//        // read from config.xml in the app bundle
//        NSString* path = [[NSBundle mainBundle] pathForResource:xml ofType:nil];
        let path = Bundle.main.path(forResource: xml, ofType: nil);
        if let path = path {
//            return;
//        }
        if !FileManager.default.fileExists(atPath: path) {
            return;
        }
//        
//        //    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
//        //        NSAssert(NO, @"ERROR: web.xml does not exist. Please run cordova-ios/bin/cordova_plist_to_config_xml path/to/project.");
//        //        return;
//        //    }
//        
//        if (path != nil) {
//            
//            NSURL* url = [NSURL fileURLWithPath:path];
        let url = URL(fileURLWithPath: path);
            
            let configParser = XMLParser(contentsOf: url);
            
            configParser?.delegate = self;
            configParser?.parse();
            
            if self._startPage == nil {
                self._startPage = "index.html"
            }
//            
//            NSXMLParser * configParser = [[NSXMLParser alloc] initWithContentsOfURL:url];
//            //        if (configParser == nil) {
//            //            NSLog(@"Failed to initialize XML parser.");
//            //            return;
//            //        }
//            [configParser setDelegate:((id < NSXMLParserDelegate >)delegate)];
//            [configParser parse];
//            
//            // Get the plugin dictionary, whitelist and settings from the delegate.
//            //    self.pluginsMap = delegate.pluginsDict;
//            //        self.startupPluginNames = delegate.startupPluginNames;
//            //    //    self.whitelist = [[CDVWhitelist alloc] initWithArray:delegate.whitelistHosts];
//            //        self.settings = delegate.settings;
//            //
//            //        // And the start folder/page.
//            //    //    if(self.wwwFolderName == nil){
//            //    //        self.wwwFolderName = @"www";
//            //    //    }
//            //        self.startPage = delegate.startPage;
//            if (self.startPage == nil) {
//                self.startPage = @"index.html";
//            }
        }
    }
//    return self;
    // Initialize the plugin objects dict.
    //    self.pluginObjects = [[NSMutableDictionary alloc] initWithCapacity:20];
    
    //- (void)parser:(NSXMLParser*)parser didStartElement:(NSString*)elementName namespaceURI:(NSString*)namespaceURI qualifiedName:(NSString*)qualifiedName attributes:(NSDictionary*)attributeDict
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
    
    //{
    //    if ([elementName isEqualToString:@"preference"]) {
        if elementName == "preference" {
            if let name = attributeDict["name"]?.lowercased() {
                _settings[name] = attributeDict["value"];
            }
        }else if elementName == "plugin" {
            _pluginName = attributeDict["name"]?.lowercased();
        }
    //        self.settings[[attributeDict[@"name"] lowercaseString]] = attributeDict[@"value"];
    //    } else if ([elementName isEqualToString:@"plugin"]) { // store feature name to use with correct parameter set
    //        pluginName = [attributeDict[@"name"] lowercaseString];
    //    } else if ((pluginName != nil) && [elementName isEqualToString:@"param"]) {
        else if _pluginName != nil && elementName == "param" {
    //        NSString* paramName = [attributeDict[@"name"] lowercaseString];
            if let paramName = attributeDict["name"]?.lowercased() {
                if let value = attributeDict["value"] {
                    if paramName == "ios-package" {
                    
                        _plugins[_pluginName!] = NSClassFromString(value);
                        
                    }else if paramName == "onload" && value == "true" {
                        if !_startPlugins.contains(_pluginName!){
                            _startPlugins.append(_pluginName!);
                        }
                    }
                }else if attributeDict["onload"]?.lowercased() == "true" {
                    if !_startPlugins.contains(_pluginName!){
                        _startPlugins.append(_pluginName!);
                    }
                }
            }
    //        id value = attributeDict[@"value"];
    //        if ([paramName isEqualToString:@"ios-package"]) {
    //            self.plugins[pluginName] = value;
    //        }
    //        BOOL paramIsOnload = ([paramName isEqualToString:@"onload"] && [@"true" isEqualToString : value]);
    //        BOOL attribIsOnload = [@"true" isEqualToString :[attributeDict[@"onload"] lowercaseString]];
    //        if (paramIsOnload || attribIsOnload) {
    //            [self.startupPlugins addObject:pluginName];
    //        }
    //    } else if ([elementName isEqualToString:@"access"]) {
        }else if elementName == "access"{
            if let origin = attributeDict["origin"] {
            _whitelist.append(origin);
            }
    //        [self.whitelist addObject:attributeDict[@"origin"]];
    //    } else if ([elementName isEqualToString:@"content"]) {
        }else if elementName == "content" {
            self._startPage = attributeDict["src"];
        }
    //        self.startPage = attributeDict[@"src"];
    //    }
        }
    //
    //    - (void)parser:(NSXMLParser*)parser didEndElement:(NSString*)elementName namespaceURI:(NSString*)namespaceURI qualifiedName:(NSString*)qualifiedName
    //{
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "plugin" {
            _pluginName = nil;
        }
    }
    //    if ([elementName isEqualToString:@"plugin"]) { // no longer handling a feature so release
    //        pluginName = nil;
    //    }
    //    }
    //
    //    - (void)parser:(NSXMLParser*)parser parseErrorOccurred:(NSError*)parseError
    //{
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: NSError) {
        
    }
    //    NSAssert(NO, @"config.xml parse error line %ld col %ld", (long)[parser lineNumber], (long)[parser columnNumber]);
    //}

}
