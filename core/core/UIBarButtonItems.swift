//
//  UIBarButtonItems.swift
//  LinCore
//
//  Created by lin on 1/23/15.
//  Copyright (c) 2015 lin. All rights reserved.
//

import Foundation
import UIKit
import LinUtil

extension UIBarButtonItem{
    
    public func setDelegateAction(action:((send:AnyObject)->())){
        
        
        var delegateAction = EventDelegateAction(action:action);
        delegateAction.withObjectSameLifecycle = self;
        
        self.target = delegateAction;
        self.action = "action:";
    }
    
    public func removeDelegateAction(){
        
        self.target = nil;
        self.action = nil;
    }
}


//
//public typedef NS_ENUM(NSUInteger, ANNavBarLoaderPosition)_ = {
//    /**
//    *  Will show UIActivityIndicatorView in place of title view
//    */
//    ANNavBarLoaderPositionCenter = 0,
//    /**
//    *  Will show UIActivityIndicatorView in place of left item
//    */
//    ANNavBarLoaderPositionLeft,
//    /**
//    *  Will show UIActivityIndicatorView in place of right item
//    */
//    ANNavBarLoaderPositionRight
//};

//public enum ANNavBarLoaderPosition: UInt {
//    case Center
//    case Left
//    case Right
//}


extension UIBarButtonItem{
    
    private struct AssociatedKeys {
        static var ANLoaderPositionAssociationKey = "ANLoaderPositionAssociationKey"
        static var ANSubstitutedViewAssociationKey = "ANSubstitutedViewAssociationKey"
    }
    
    
    private func startPreUIView()->UIView?{
        
        
        let isSet: AnyObject! = objc_getAssociatedObject(self, &AssociatedKeys.ANLoaderPositionAssociationKey);
        if let isSet: AnyObject = isSet{
            if(isSet as! NSObject == true){
                let componentToRestore:AnyObject! = objc_getAssociatedObject(self, &AssociatedKeys.ANSubstitutedViewAssociationKey);
                return componentToRestore as? UIView;
                
            }
        }
        return self.customView;
    }
    
    public func startAnimation(){

        var v:UIView? = self.valueForKey("view") as! UIView?;
 
        objc_setAssociatedObject(self, &AssociatedKeys.ANLoaderPositionAssociationKey, true, (objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC));
        
        var preView = self.startPreUIView();
        objc_setAssociatedObject(self, &AssociatedKeys.ANSubstitutedViewAssociationKey, preView, (objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC));
        
        
        if let v = v {
            var loader = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray);
            loader.color = UIColor.blueColor();
            
            loader.frame = CGRectMake(0, 0, v.bounds.width, v.bounds.height);
            self.customView = loader;
            loader.startAnimating();
        }else{
            dispatch_async(dispatch_get_main_queue(), {[weak self] () -> Void in
                self?.startAnimation();
            });
        }
  
    }
    
    public func stopAnimation(){
        
        var isSet: AnyObject! = objc_getAssociatedObject(self, &AssociatedKeys.ANLoaderPositionAssociationKey);
        if let isSet: AnyObject = isSet{
            if(isSet as! NSObject == true){
                var componentToRestore:AnyObject! = objc_getAssociatedObject(self, &AssociatedKeys.ANSubstitutedViewAssociationKey);
                self.customView = componentToRestore as? UIView;
                
                 objc_setAssociatedObject(self, &AssociatedKeys.ANLoaderPositionAssociationKey, false, (objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC));
            }
        }
    }

}