//
//  LinWebView.swift
//  LinWeb
//
//  Created by lin on 6/11/16.
//  Copyright © 2016 lin. All rights reserved.
//

import Foundation
import WebKit
import LinUtil

private class __LinWKWebView_UIAlertView : UIAlertView,UIAlertViewDelegate{
    fileprivate var alertCompletionHandler: (() -> Void)!;
    fileprivate var confirmCompletionHandler: ((Bool) -> Void)!;
    fileprivate var inputCompletionHandler: ((String?) -> Void)!;
    
    fileprivate var type:Int = 0;
    
    open func alertView(_ alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int){
//        let alert = alertView as! __LineWKWebView_UIAlertView;
        if self.type == 0 {
            self.alertCompletionHandler();
            return;
        }
        
        if self.type == 1{
            if buttonIndex == 0 {
                self.confirmCompletionHandler(false);
            }else{
                self.confirmCompletionHandler(true);
            }
        }
        
        if self.type == 2 {
            let text = alertView.textField(at: 0)?.text;
            
            self.inputCompletionHandler(text);
        }
    }
}
private class __LineWKWebView_LinWebViewDelegate :NSObject, WKScriptMessageHandler,WKUIDelegate,WKNavigationDelegate {
    
    fileprivate var bridge:LinJavaScriptBridge!;
    
    open func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage){
        print(message.body)
    }
    
    // MARK: - WKUIDelegate
    open func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Swift.Void){
        
        let alert = __LinWKWebView_UIAlertView(title: "", message: message, delegate: nil, cancelButtonTitle: "确定");
        
        alert.delegate = alert;
        alert.alertCompletionHandler  = completionHandler;
        alert.type = 0;
        
        alert.show();
        
    }
    
    open func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {

        let alert = __LinWKWebView_UIAlertView(title: "", message: message, delegate: nil, cancelButtonTitle: "取消", otherButtonTitles: "确定");
        alert.delegate = alert;
        alert.confirmCompletionHandler = completionHandler;
        alert.type = 1;
        alert.show();
    }
    
    open func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {

        let json = Json.init(string: defaultText ?? "");
        if json.isError {
            let alert = __LinWKWebView_UIAlertView(title: "", message: defaultText, delegate: nil, cancelButtonTitle: "确定");
            alert.type = 2;
            alert.delegate = alert;
            alert.alertViewStyle = .plainTextInput;
            alert.inputCompletionHandler = completionHandler;
            
            alert.show();
        }else{
            self.bridge.pluginAction(args: json, completion: completionHandler);
        }
    }
    
    open func webViewDidClose(_ webView: WKWebView) {
        print(#function)
    }
    
    // MARK: - WKNavigationDelegate
    
    // 决定导航的动作，通常用于处理跨域的链接能否导航。WebKit对跨域进行了安全检查限制，不允许跨域，因此我们要对不能跨域的链接
    // 单独处理。但是，对于Safari是允许跨域的，不用这么处理。
//    func webView(_ webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
//        print(#function)
//        
////        let hostname = navigationAction.request.URL?.host?.lowercaseString
//        let hostname = navigationAction.request.url?.host?.lowercased() as NSString?;
//        
//        print(hostname)
//        decisionHandler(.allow)
//        // 处理跨域问题
////        if navigationAction.navigationType == .linkActivated && !hostname!.contains(".baidu.com") {
////            // 手动跳转
////            UIApplication.shared.openURL(navigationAction.request.url!)
////            
////            // 不允许导航
////            decisionHandler(.cancel)
////        } else {
//////            self.progressView.alpha = 1.0
//////            self.pro
////            
////            decisionHandler(.allow)
////        }
//    }
    
    open func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void){
        print("=================================")
        decisionHandler(.allow)
    }
    
    
    /*! @abstract Decides whether to allow or cancel a navigation after its
     response is known.
     @param webView The web view invoking the delegate method.
     @param navigationResponse Descriptive information about the navigation
     response.
     @param decisionHandler The decision handler to call to allow or cancel the
     navigation. The argument is one of the constants of the enumerated type WKNavigationResponsePolicy.
     @discussion If you do not implement this method, the web view will allow the response, if the web view can show it.
     */
    open func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Swift.Void){
        print("decidePolicyFor navigationResponse:=================================")
        decisionHandler(.allow);
    }
    
    
    /*! @abstract Invoked when a main frame navigation starts.
     @param webView The web view invoking the delegate method.
     @param navigation The navigation.
     */
    open func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!){
        print("didStartProvisionalNavigation:=================================")
    }
    
    
    /*! @abstract Invoked when a server redirect is received for the main
     frame.
     @param webView The web view invoking the delegate method.
     @param navigation The navigation.
     */
    open func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!){
        print("didReceiveServerRedirectForProvisionalNavigation:=================================")
    }
    
    
    /*! @abstract Invoked when an error occurs while starting to load data for
     the main frame.
     @param webView The web view invoking the delegate method.
     @param navigation The navigation.
     @param error The error that occurred.
     */
    open func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error){
        print("didFailProvisionalNavigation:=================================")
    }
    
    
    /*! @abstract Invoked when content starts arriving for the main frame.
     @param webView The web view invoking the delegate method.
     @param navigation The navigation.
     */
    open func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!){
        print("didCommit:=================================")
    }
    
    
    /*! @abstract Invoked when a main frame navigation completes.
     @param webView The web view invoking the delegate method.
     @param navigation The navigation.
     */
    open func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!){
        print("didFinish:=================================")
    }
    
    
    /*! @abstract Invoked when an error occurs during a committed main frame
     navigation.
     @param webView The web view invoking the delegate method.
     @param navigation The navigation.
     @param error The error that occurred.
     */
    open func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error){
        print("didFail:=================================")
    }
    
    
    /*! @abstract Invoked when the web view needs to respond to an authentication challenge.
     @param webView The web view that received the authentication challenge.
     @param challenge The authentication challenge.
     @param completionHandler The completion handler you must invoke to respond to the challenge. The
     disposition argument is one of the constants of the enumerated type
     NSURLSessionAuthChallengeDisposition. When disposition is NSURLSessionAuthChallengeUseCredential,
     the credential argument is the credential to use, or nil to indicate continuing without a
     credential.
     @discussion If you do not implement this method, the web view will respond to the authentication challenge with the NSURLSessionAuthChallengeRejectProtectionSpace disposition.
     */
    open func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Swift.Void){
        print("=================================")
    }
    
    
    /*! @abstract Invoked when the web view's web content process is terminated.
     @param webView The web view whose underlying web content process was terminated.
     */
    open func webViewWebContentProcessDidTerminate(_ webView: WKWebView){
        print("=================================")
    }

    
}




open class LinWKWebView : WKWebView{
    
    static var __once:() = {
        URLProtocol.registerClass(LinWebURLProtocol.self);
    }()

    
    fileprivate var handler = __LineWKWebView_LinWebViewDelegate();
    
    fileprivate var bridge:LinJavaScriptBridge!;
    
    internal init(webView:LinWebView){
        
        
        _ = LinWKWebView.__once;
        
        let configuretion = WKWebViewConfiguration()
        
        // Webview的偏好设置
        configuretion.preferences = WKPreferences()
        configuretion.preferences.minimumFontSize = 10
        configuretion.preferences.javaScriptEnabled = true
        
        
        // 默认是不能通过JS自动打开窗口的，必须通过用户交互才能打开
//        configuretion.preferences.javaScriptCanOpenWindowsAutomatically = false
        
        // 通过js与webview内容交互配置
        configuretion.userContentController = WKUserContentController()
        
        // 添加一个JS到HTML中，这样就可以直接在JS中调用我们添加的JS方法
        let script = WKUserScript(source: "Object.defineProperty(window, 'IOSWebFlag', {value: true,writable:false,enumerable: false,configurable: false});" +
            
            "Object.defineProperty(window, 'IOSBridge', {" +
            "get: function() {" +
            "    return function(plugin,action,params){" +
            "       var config = {plugin:plugin,action:action,params:params};" +
            "       var c = JSON.stringify(config || '{}');" +
            "       return prompt('',c);" +
            "   }" +
            "}," +
            "enumerable: false," +
            "configurable: false" +
    "});",
                                  injectionTime: .atDocumentStart,// 在载入时就添加JS
            forMainFrameOnly: true) // 只添加到mainFrame中
        configuretion.userContentController.addUserScript(script)
//        configuretion.userContentController.
        
        // 添加一个名称，就可以在JS通过这个名称发送消息：
        // window.webkit.messageHandlers.AppModel.postMessage({body: 'xxx'})
//        configuretion.userContentController.add(handler, name: "AppModel")
        
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0), configuration: configuretion);
        
        self.bridge = LinJavaScriptBridge(webView: webView);
        self.handler.bridge = self.bridge;
        self.uiDelegate = self.handler;
        
        self.navigationDelegate = self.handler;
        
        
        
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    open func loadUrl(_ url:String!){
        self.uiDelegate = self.handler;
        if url == nil {
            self.loadHTMLString("error.", baseURL:nil);
            return;
        }
        var appReq:URLRequest! = nil;
        if url.lowercased().hasPrefix("http://") || url.lowercased().hasPrefix("https://") || url.lowercased().hasPrefix("web://") {
            if let nsurl = URL(string:url) {
                appReq = URLRequest(url:nsurl, cachePolicy:URLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval:20.0);
            }
        }else{
            
            let startURL = URL(string:url);
            if let path = startURL?.path {
                
//                if let startFilePath = pathFor(Documents.bundle, path: path) {
                if let startFilePath = pathFor(Documents.tmp, path: "www/"+path) {
                
                    var appURL:URL? = URL(fileURLWithPath:startFilePath);
                    
                    let r = url.rangeOfCharacter(from: CharacterSet(charactersIn: "?#"));
                    if let r = r {
                        let queryAndOrFragment = url.substring(from: r.lowerBound);
                        
                        appURL = URL(string: queryAndOrFragment,relativeTo: appURL);
                    }
                    
                    if let appURL = appURL{
//                        if #available(iOS 9.0, *) {
//                            super.loadFileURL(appURL, allowingReadAccessTo: appURL)
//                            return;
//                        } else {
//                            // Fallback on earlier versions
//                        };
                        appReq = URLRequest(url: appURL, cachePolicy: URLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: 15.0);
                    }
                }
            }
        }
        
        if let appReq = appReq{
            self.load(appReq);
//            if #available(iOS 9.0, *) {
//                super.loadFileURL(appReq.url!, allowingReadAccessTo: appReq.url!);
//            } else {
//                // Fallback on earlier versions
//            };
        }else{
            self.loadHTMLString("url error.", baseURL:nil);
        }
        
    }
    
    // MARK: - WKScriptMessageHandler
    func userContentController(_ userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
        print(message.body)
        if message.name == "AppModel" {
            print("message name is AppModel")
        }
    }
}
