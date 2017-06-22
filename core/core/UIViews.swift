//
//  UIView.swift
//  LinCore
//
//  Created by lin on 1/18/15.
//  Copyright (c) 2015 lin. All rights reserved.
//

import Foundation
import UIKit

extension UIView{
    
   
    public class func getRootViewController()->UIViewController?{
        return rootViewControllerImpl();
    }
    public var rootViewController:UIViewController?{
        return UIView.rootViewControllerImpl();
    }
    
    fileprivate class func rootViewControllerImpl()->UIViewController?{
        //    UIViewController *result = nil;
        
        var window = UIApplication.shared.keyWindow;
        
        if window == nil || window!.windowLevel != UIWindowLevelNormal
        {
            let windows = UIApplication.shared.windows;
            for tmpWin in windows {
                if tmpWin.windowLevel == UIWindowLevelNormal {
                    window = tmpWin;
                    break;
                }
            }
        }
        
        if let window = window {
            if window.subviews.count > 0 {
                let frontView = window.subviews[0];
                let nextResponder = frontView.next;
                
                if nextResponder is UIViewController {
                    return nextResponder as? UIViewController;
                }else{
                    return window.rootViewController;
                }
            }
        }
        
        return nil;
    }
    
    public var viewController:UIViewController?{
        var next = self.superview;
        while next != nil {
            let resp = next!.next;
            if resp is UIViewController {
                return resp as? UIViewController
            }
            next = next?.superview;
        }
        return nil;
    }
    
}
