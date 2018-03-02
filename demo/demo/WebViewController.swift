//
//  WebViewController.swift
//  demo
//
//  Created by lin on 6/10/16.
//  Copyright © 2016 lin. All rights reserved.
//

import Foundation
//import CessWeb
import CessCore
import CessUtil

open class WebViewController : UIViewController{
    
    //将文件copy到tmp目录
//    func fileURLForBuggyWKWebView8() -> URL {
//        // Some safety checks
//        let startFilePath = pathFor(Documents.bundle, path: "buyers")!
//        let fileURL:URL = URL.baseURL(withPath: startFilePath) as NSURL;
//        var error:NSError? = nil;
//        if (!fileURL.isFileURL || !fileURL.checkResourceIsReachableAndReturnError(&error)) {
////            throw error ?? Error(
////                domain: "BuggyWKWebViewDomain",
////                code: 1001,
////                userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("URL must be a file URL.", comment:"")])
//        }
//        
//        // Create "/temp/www" directory
//        let fm = FileManager.default
//        let tmpDirURL = NSURL.fileURL(withPath: NSTemporaryDirectory()).appendingPathComponent("www")
//        try! fm.createDirectory(at: tmpDirURL, withIntermediateDirectories: true, attributes: nil)
//        
//        // Now copy given file to the temp directory
//        let dstURL = tmpDirURL.appendingPathComponent(fileURL.lastPathComponent)
//        
////        let _ = try? fileURL.removeItemAtURL(dstURL)
//        try? fm.copyItem(at: fileURL as URL, to: dstURL)
//        
//        // Files in "/temp/www" load flawlesly :)
//        return (dstURL as NSURL) as URL
//    }
    
//    private var _webView:LinWebView?;
//    
//    open override func loadView() {
//        _webView = LinWebView();
//        self.view = _webView!;
//        
//        self.view.backgroundColor = UIColor.init(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.6);
//        
//        let label = UILabel();
//        label.frame = CGRect.init(x: 0, y: 18, width: self.view.frame.size.width, height: 40.0);
//        label.textColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.8);
//        label.textAlignment = NSTextAlignment.center;
//        label.autoresizingMask = UIViewAutoresizing.flexibleWidth;
//        label.text = "翡翠吧吧";
//        label.backgroundColor = UIColor.clear;
//        self.view.addSubview(label);
//        
//        let copyInfo = UILabel();
//        copyInfo.frame = CGRect.init(x: 0, y: self.view.bounds.size.height + self.view.bounds.origin.y - 45, width: self.view.bounds.size.width, height: 40);
//        copyInfo.textColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.8);
//        copyInfo.textAlignment = NSTextAlignment.center;
//        copyInfo.autoresizingMask = UIViewAutoresizing.init(rawValue: UIViewAutoresizing.flexibleWidth.rawValue | UIViewAutoresizing.flexibleTopMargin.rawValue);
//        copyInfo.text = "Copyright 2014-2015 翡翠吧吧 All rights reserved";
//        copyInfo.font = UIFont.init(name: "STHeitiSC-Light", size: 12.0);
//        copyInfo.backgroundColor = UIColor.clear;
//        
//        self.view.addSubview(copyInfo);
//        
//        //        _webView.backgroundColor = UIColor.blue;
//    }
//    
//    open override func viewDidLoad() {
//        
////        fileURLForBuggyWKWebView8();
//        UncaughtExceptionHandler.setExceptionHandler { (e:NSException?) in
//            print(e);
//        }
////        self.loadUrl("/temp/www/index.html)
////            self.loadUrl("web://buyers/index.html?debug=false&debugJs=true&url=http://s.feicuibaba.com&isUpdate=false&channel=own#/login")
//        //        self.loadUrl("web/test.html")
//        _webView?.load("buyers/index.html?debug=false&debugJs=true&url=http://s.feicuibaba.com&isUpdate=false&channel=own#/login")
////        self.loadUrl("http://wx.feicuibaba.com/index.html?debug=false&debugJs=true&isUpdate=false&channel=own#/login")
//    }
}
