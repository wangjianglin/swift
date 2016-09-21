//
//  LinWebPlugin.swift
//  LinWeb
//
//  Created by lin on 6/10/16.
//  Copyright © 2016 lin. All rights reserved.
//

import Foundation
import WebKit

public protocol LinWebPlugin:NSObjectProtocol{
//    @property (nonatomic, weak,readonly) UIWebView* webView;
    //@property (readonly) NSString * plugin;
    //@property (nonatomic, weak) UIViewController* viewController;
    //@property (nonatomic, weak) id <CDVCommandDelegate> commandDelegate;
    
    //@property (readonly, assign) BOOL hasPendingOperation;
    var webView:LinWebView{get}
    
    //- (instancetype)initWithPlugin:(NSString*)plugin;
//    -(instancetype)initWithWebView:(UIWebView*)webView;
    init(webView:LinWebView);
    //- (void)pluginInitialize;
    //-(Json*)action:(NSString*)action args:(Json*)args;
    
//    - (void)handleOpenURL:(NSNotification*)notification;
    func handleOpenURL(_ notification:Notification);
//    - (void)onAppTerminate;
//    - (void)onMemoryWarning;
//    - (void)onReset;
//    - (void)dispose;
//    
//    /*
//     // see initWithWebView implementation
//     - (void) onPause {}
//     - (void) onResume {}
//     - (void) onOrientationWillChange {}
//     - (void) onOrientationDidChange {}
//     - (void)didReceiveLocalNotification:(NSNotification *)notification;
//     */
//    
//    - (id)appDelegate;
}

@objc
public class LinAbstractWebPlugin : NSObject, LinWebPlugin{
    private let _webView:LinWebView;
    
    public required init(webView: LinWebView) {
        _webView = webView;
    }
    
    public var webView: LinWebView{
        return _webView;
    }
    
    public func handleOpenURL(_ notification: Notification) {
        
    }
}
