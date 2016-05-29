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
    
    //    (view2?.convertRect(CGRectMake(0, 0, 0, 0), toView: self.view)
    //    public func contentRect()->CGRect{
    //        return self.contentRectImpl(self);
    //    }
    //    private func contentRectImpl(view:UIView)->CGRect{
    //        var rect = CGRectMake(0, 0, 0, 0);
    //
    //        for item in self.subviews {
    //
    //            if let item = item as? UIView {
    //
    //                var subRect:CGRect!;
    //
    //                if let sv = item as? UIScrollView {
    //                    subRect = sv.bounds;
    //                }else{
    //                    subRect = item.contentRect();
    //                }
    //                let itemRect = item.bounds;
    //                let r = self.mergeRect(subRect,rect2:itemRect);
    //                let r2 = item.convertRect(r, toView: view)
    //                rect = self.mergeRect(r2, rect2: rect);
    //            }
    //        }
    //
    //        return rect;
    //    }
    //
    //    private func mergeRect(rect1:CGRect,rect2:CGRect)->CGRect{
    //        var result = CGRectMake(0, 0, 0, 0);
    //        result.origin.x = rect1.origin.x > rect2.origin.x ? rect2.origin.x : rect1.origin.x;
    //
    //        result.origin.y = rect1.origin.y > rect2.origin.y ? rect2.origin.y : rect1.origin.y;
    //
    //        var maxX = rect2.width + rect2.origin.x;
    //        if maxX < rect1.width + rect1.origin.x {
    //            maxX = rect1.width + rect1.origin.x
    //        }
    //
    //        result.size.width = maxX - result.origin.x;
    //
    //        var maxY = rect2.height + rect2.origin.y;
    //        if maxY < rect1.height + rect1.origin.y {
    //            maxY = rect1.height + rect1.origin.y
    //        }
    //
    //        result.size.height = maxY - result.origin.y;
    //
    //        return result;
    //    }
    
//    
    public class func getRootViewController()->UIViewController?{
        return rootViewControllerImpl();
    }
    public var rootViewController:UIViewController?{
        return UIView.rootViewControllerImpl();
    }
    
    private class func rootViewControllerImpl()->UIViewController?{
        //    UIViewController *result = nil;
        
        var window = UIApplication.sharedApplication().keyWindow;
        
        if window == nil || window!.windowLevel != UIWindowLevelNormal
        {
            let windows = UIApplication.sharedApplication().windows;
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
                let nextResponder = frontView.nextResponder();
                
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
//    for UIView* next = [self superview]; next; next = next.superview) {
//    UIResponder *nextResponder = [next nextResponder];
//    if ([nextResponder isKindOfClass:[UIViewController class]]) {
//    return (UIViewController *)nextResponder;
//    }
//    }
//    return nil;
        var next = self.superview;
        while next != nil {
            let resp = next!.nextResponder();
            if resp is UIViewController {
                return resp as? UIViewController
            }
            next = next?.superview;
        }
        return nil;
    }
    
}
