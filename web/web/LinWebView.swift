//
//  LinWebView.swift
//  LinWeb
//
//  Created by lin on 6/10/16.
//  Copyright © 2016 lin. All rights reserved.
//

import WebKit
import LinUtil
import JavaScriptCore

public class LinWebView : UIView {
    
    public enum WebType{
        case uiWebView
        case wkWebView
    }
    
    private var uiWebView:LinUIWebView?;
    private var wkWebView:LinWKWebView?;
    
    public var origin:UIView{
        if let uiWebView = uiWebView {
            return uiWebView;
        }
        return wkWebView!;
    }
    
    private let type:LinWebView.WebType;// = LinWebView.WebType.uiWebView;
    
    public init(type:LinWebView.WebType){
        self.type = type;
        super.init(frame:CGRect(x: 0, y: 0, width: 0, height: 0));
        self.initView();
    }
    
    private func initView(){
        if type == LinWebView.WebType.uiWebView {
            self.uiWebView = LinUIWebView.init(webView: self);
            
            uiWebView?.frame = frame;
            
            self.addSubview(uiWebView!);
            
            uiWebView?.autoresizingMask = UIViewAutoresizing.init(rawValue: UIViewAutoresizing.flexibleHeight.rawValue | UIViewAutoresizing.flexibleWidth.rawValue);
            
            uiWebView?.backgroundColor = UIColor.clear;
        }else{
            self.wkWebView = LinWKWebView.init(webView: self);
            
            wkWebView?.frame = frame;
            
            self.addSubview(wkWebView!);
            
            wkWebView?.autoresizingMask = UIViewAutoresizing.init(rawValue: UIViewAutoresizing.flexibleHeight.rawValue | UIViewAutoresizing.flexibleWidth.rawValue);
            
            wkWebView?.backgroundColor = UIColor.clear;
        }
        
        self.backgroundColor = UIColor.gray;
    }
    override init(frame: CGRect) {
        type = LinWebView.WebType.uiWebView
        super.init(frame: frame);
        self.initView();
    }
    
    private var completionHandler:((Any?)->())? = nil;
    
    public func evaluateJavaScript(js:String,completionHandler:((Any?)->())? = nil){
        if let uiWebView = self.uiWebView {
            let value = uiWebView.stringByEvaluatingJavaScript(from: js);
            completionHandler?(value);
        }
        
        if let wkWebView = self.wkWebView {
            wkWebView.evaluateJavaScript(js, completionHandler: { (value, error) in
                completionHandler?(value);
            })
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func addSubview(_ view: UIView) {
        super.addSubview(view);
        self.bringWebView();
    }
    
    private func bringWebView(){
        if let uiWebView = self.uiWebView {
            super.bringSubview(toFront: uiWebView);
        }
        
        if let wkWebView = self.wkWebView {
            super.bringSubview(toFront: wkWebView);
        }
    }
    
    open override func bringSubview(toFront view: UIView){
        super.bringSubview(toFront: view);
        self.bringWebView();
    }
    
    public func load(url:String){
        self.uiWebView?.load(url: url);
    }
}
