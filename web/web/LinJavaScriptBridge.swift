//
//  LinJavaScriptBridge.swift
//  LinWeb
//
//  Created by lin on 6/11/16.
//  Copyright © 2016 lin. All rights reserved.
//

import Foundation
import WebKit
import LinUtil

class LinJavaScriptBridge {
    
    private static var __once: () = { 
            YRSingle.parser = LinConfigParser();
            YRSingle.nullPlugin = NullWebPlugin();
        }()
    
    struct YRSingle {
        static var parser:LinConfigParser!;
        static var nullPlugin:NullWebPlugin!;
        static var predicate:Int = 0;
    }
    
    class NullWebPlugin {
        
    }
    
    private var _plugins = Dictionary<String,Any>();
    private var _webView:LinWebView;
    private var _queue = Queue(count: 5);
    
    init(webView:LinWebView){
        
        self._webView = webView;
        
        _ = LinJavaScriptBridge.__once
        
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
    
    private func pluginObj(_ name:String)->LinWebPlugin!{
        var obj:Any? = _plugins[name];
        if let obj = obj {
            if let obj = obj as? LinWebPlugin{
                return obj;
            }
            return nil;
        }
        objc_sync_enter(self);
        
        obj = _plugins[name];
        if obj == nil {
            var plugins = YRSingle.parser.plugins;
            let cls:AnyClass? = plugins[name];
            
            if cls is LinWebPlugin.Type {
                _plugins[name] = (cls as! LinWebPlugin.Type).init(webView: _webView);
            }else{
                _plugins[name] = YRSingle.nullPlugin;
            }
        }
        
        objc_sync_exit(self);
        
        obj = _plugins[name];
//        if let obj = obj {
            if let obj = obj as? LinWebPlugin{
                return obj;
            }
            return nil;
//        }
        
//        return nil;
    }
    
    
    private func actions(action:String)->String?{
        
        switch action {
        case "platform":
            return UIDevice.current.systemName;
        case "productName":
            return UIDevice.current.name;
        case "versionName":
            return UIDevice.current.systemVersion;
        case "version":
            return "\((UIDevice.current.systemVersion as NSString).floatValue)";
        case "model":
            return UIDevice.current.model;
        case "uuid":
            return "";
        default:
            return nil;
        }
        
    }
    
    
    internal func pluginAction(args:Json,completion:@escaping (String?)->Void){
        _queue.asynQueue {[weak self] in
            self?.pluginActionImpl(args: args, completion: completion);
        }
    }
    
    private func pluginActionImpl(args:Json,completion:(String?)->Void){
    
        let name = args["plugin"].asString("");
        let action = args["action"].asString("");
        
            if name == nil || name == "" {
                completion(self.actions(action: action));
                return;
            }
        
        let plugin:LinWebPlugin! = self.pluginObj(name);
        if plugin == nil {
            completion(nil);
            return;
        }
        
        var actionSel:Selector = Selector("\(action):");
        
        var isResponse = plugin.responds(to: actionSel);
        
        var result:Unmanaged<AnyObject>!;
        if !isResponse {
            actionSel = Selector(action);
            isResponse = plugin.responds(to: actionSel);
            if isResponse {
                result = plugin.perform(actionSel);
            }
        }else{
            result = plugin.perform(actionSel, with: args["params"]);
        }
        
        
        var rString:String! = "{}";
        
        if let result = result {
            var tmpResult:Any? = result.takeUnretainedValue();
            if let asynResult:AsynResult = tmpResult as? AsynResult {
                
                tmpResult = asynResult.waitResult()
            }
            
            if let tmpResult = tmpResult {
                switch  tmpResult{
                    case let json as Json:
                        rString = json.description;
                    case let s as String:
                        rString = "\"\(s)\"";
                    default:
                        rString = "\(tmpResult)";
                }
            }
        }
        rString = rString.replacingOccurrences(of: "\n", with: "\\n", options: String.CompareOptions.caseInsensitive, range: nil);
        rString = rString.replacingOccurrences(of: "\r", with: "\\r", options: String.CompareOptions.caseInsensitive, range: nil);
        rString = rString.replacingOccurrences(of: "\t", with: "\\t", options: String.CompareOptions.caseInsensitive, range: nil);
        completion(rString);
    }
    
}

