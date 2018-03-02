//
//  UIBarButtonItems.swift
//  LinCore
//
//  Created by lin on 1/23/15.
//  Copyright (c) 2015 lin. All rights reserved.
//

import Foundation
import UIKit
import CessUtil

extension UIBarButtonItem{
    
    public func setDelegateAction(_ action:@escaping ((_ send:AnyObject)->())){
        
        
        let delegateAction = EventDelegateAction(action:action);
        delegateAction.ext.withObjectSameLifecycle = self;
//        delegateAction.ext.withObjectSameLifecycle = self;
        
        self.target = delegateAction;
        self.action = #selector(EventDelegateAction.action(_:));
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
    
    fileprivate struct AssociatedKeys {
        static var ANLoaderPositionAssociationKey = "ANLoaderPositionAssociationKey"
        static var ANSubstitutedViewAssociationKey = "ANSubstitutedViewAssociationKey"
    }
    
    
    fileprivate func startPreUIView()->UIView?{
        
        
        let isSet: Any! = objc_getAssociatedObject(self, &AssociatedKeys.ANLoaderPositionAssociationKey)!;
        if let isSet: Any = isSet{
            if(isSet as! Bool == true){
                let componentToRestore:Any! = objc_getAssociatedObject(self, &AssociatedKeys.ANSubstitutedViewAssociationKey);
                return componentToRestore as? UIView;
                
            }
        }
        return self.customView;
    }
    
    public func startAnimation(){

        let v:UIView? = self.value(forKey: "view") as! UIView?;
 
        objc_setAssociatedObject(self, &AssociatedKeys.ANLoaderPositionAssociationKey, true, (objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC));
        
        let preView = self.startPreUIView();
        objc_setAssociatedObject(self, &AssociatedKeys.ANSubstitutedViewAssociationKey, preView, (objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC));
        
        
        if let v = v {
            let loader = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray);
            loader.color = UIColor.blue;
            
            loader.frame = CGRect(x: 0, y: 0, width: v.bounds.width, height: v.bounds.height);
            self.customView = loader;
            loader.startAnimating();
        }else{
            DispatchQueue.main.async(execute: {[weak self] () -> Void in
                self?.startAnimation();
            });
        }
  
    }
    
    public func stopAnimation(){
        
        let isSet: Any! = objc_getAssociatedObject(self, &AssociatedKeys.ANLoaderPositionAssociationKey);
        if let isSet: Any = isSet{
            if(isSet as! Bool == true){
                let componentToRestore:Any! = objc_getAssociatedObject(self, &AssociatedKeys.ANSubstitutedViewAssociationKey);
                self.customView = componentToRestore as? UIView;
                
                 objc_setAssociatedObject(self, &AssociatedKeys.ANLoaderPositionAssociationKey, false, (objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC));
            }
        }
    }

}
