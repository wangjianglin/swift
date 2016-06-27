//
//  LinJavaScriptBridge.swift
//  LinWeb
//
//  Created by lin on 6/11/16.
//  Copyright © 2016 lin. All rights reserved.
//

import Foundation
import WebKit

class LinJavaScriptBridge {
    
    struct YRSingle {
        static var parser:LinConfigParser!;
        static var nullPlugin:NullWebPlugin!;
        static var predicate:dispatch_once_t = 0;
    }
    
    class NullWebPlugin: LinAbstractWebPlugin {
        
    }
    
    private var _plugins = Dictionary<String,LinWebPlugin>();
    private var _webView:WKWebView;
    
    init(webView:WKWebView){
        
        self._webView = webView;
        
        dispatch_once(&YRSingle.predicate) { 
            YRSingle.parser = LinConfigParser();
            YRSingle.nullPlugin = NullWebPlugin(webView: webView);
        }
        
        for item in YRSingle.parser.startPlugins {
            var plugins = YRSingle.parser.plugins;
            let cls:AnyClass? = plugins[item];
            
            if cls is LinConfigParser.Type {
                _plugins[item] = (cls as! LinWebPlugin.Type).init(webView: webView);
            }else{
                _plugins[item] = YRSingle.nullPlugin;
            }
        }
    }
    
    private func pluginObj(name:String)->LinWebPlugin!{
        var obj:LinWebPlugin? = _plugins[name];
        if let obj = obj {
            if obj is NullWebPlugin{
                return nil;
            }
            return obj;
        }
        objc_sync_enter(self);
        
        obj = _plugins[name];
        if obj == nil {
            var plugins = YRSingle.parser.plugins;
            let cls:AnyClass? = plugins[name];
            
            if cls is LinConfigParser.Type {
                _plugins[name] = (cls as! LinWebPlugin.Type).init(webView: _webView);
            }else{
                _plugins[name] = YRSingle.nullPlugin;
            }
        }
        
        objc_sync_exit(self);
        
        obj = _plugins[name];
        if let obj = obj {
            if obj is NullWebPlugin{
                return nil;
            }
            return obj;
        }
        
        return nil;
    }
}
