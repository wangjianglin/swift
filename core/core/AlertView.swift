//
//  AlertView.swift
//  LinControls
//
//  Created by lin on 1/8/15.
//  Copyright (c) 2015 lin. All rights reserved.
//

import UIKit
import LinUtil

public class AlertView{
    
    public class func show(titie:String,message:String,buttonTitle:String){
        UIAlertView(title: titie, message: message, delegate: nil, cancelButtonTitle: buttonTitle).show();
    }
    
    public class func show(message:String){
        UIAlertView(title: "", message: message, delegate: nil, cancelButtonTitle: "确定").show();
    }
}

public extension UIAlertView{
    
    private var delegateAction:__LinCore_UIAlertViewDelegateImpl{
        struct YSignal{
            static var predicate:dispatch_once_t = 0;
            static var install:__LinCore_UIAlertViewDelegateImpl?;
        }
        
        dispatch_once(&YSignal.predicate) {
            YSignal.install = __LinCore_UIAlertViewDelegateImpl();
            YSignal.install?.withObjectSameLifecycle = self;
        }
        self.delegate = YSignal.install;
        return YSignal.install!;
    }
    public var alertViewCancelAction:((alertView:UIAlertView)->())?{
        set{
            delegateAction.alertViewCancelAction = newValue;
        }
        get{
            return delegateAction.alertViewCancelAction;
        }
    }
    public var clickedButtonAtIndexAction:((alertView:UIAlertView,buttonIndex:Int)->())?{
        set{
            delegateAction.clickedButtonAtIndexAction = newValue;
        }
        get{
            return delegateAction.clickedButtonAtIndexAction;
        }
    }
    public var willPresentAlertViewAction:((alertView:UIAlertView)->())?{
        set{
            delegateAction.willPresentAlertViewAction = newValue;
        }
        get{
            return delegateAction.willPresentAlertViewAction;
        }
    }
    public var didPresentAlertViewAction:((alertView:UIAlertView)->())?{
        set{
            delegateAction.didPresentAlertViewAction = newValue;
        }
        get{
            return delegateAction.didPresentAlertViewAction;
        }
    }
    public var willDismissWithButtonIndexAction:((alertView:UIAlertView,buttonIndex:Int)->())?{
        set{
            delegateAction.willDismissWithButtonIndexAction = newValue;
        }
        get{
            return delegateAction.willDismissWithButtonIndexAction;
        }
    }
    public var didDismissWithButtonIndexAction:((alertView:UIAlertView,buttonIndex:Int)->())?{
        set{
            delegateAction.didDismissWithButtonIndexAction = newValue;
        }
        get{
            return delegateAction.didDismissWithButtonIndexAction;
        }
    }
    public var alertViewShouldEnableFirstOtherButtonAction:((alertView:UIAlertView)->Bool)?{
        set{
            delegateAction.alertViewShouldEnableFirstOtherButtonAction = newValue;
        }
        get{
            return delegateAction.alertViewShouldEnableFirstOtherButtonAction;
        }
    }
}


private class __LinCore_UIAlertViewDelegateImpl : DelegateAction,UIAlertViewDelegate{
    private var alertViewCancelAction:((alertView:UIAlertView)->())?;
    private var clickedButtonAtIndexAction:((alertView:UIAlertView,buttonIndex:Int)->())?;
    private var willPresentAlertViewAction:((alertView:UIAlertView)->())?;
    private var didPresentAlertViewAction:((alertView:UIAlertView)->())?;
    private var willDismissWithButtonIndexAction:((alertView:UIAlertView,buttonIndex:Int)->())?;
    private var didDismissWithButtonIndexAction:((alertView:UIAlertView,buttonIndex:Int)->())?;
    private var alertViewShouldEnableFirstOtherButtonAction:((alertView:UIAlertView)->Bool)?;
    
    private override init() {
        super.init();
    }
    
    public func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int){
        if let clickedButtonAtIndexAction = self.clickedButtonAtIndexAction {
            clickedButtonAtIndexAction(alertView: alertView, buttonIndex: buttonIndex);
        }
    }
    
    // Called when we cancel a view (eg. the user clicks the Home button). This is not called when the user clicks the cancel button.
    // If not defined in the delegate, we simulate a click in the cancel button
    public func alertViewCancel(alertView: UIAlertView){
        if let alertViewCancelAction = self.alertViewCancelAction {
            alertViewCancelAction(alertView: alertView);
        }
    }
    
    public func willPresentAlertView(alertView: UIAlertView){
        if let willPresentAlertViewAction = self.willPresentAlertViewAction {
            willPresentAlertViewAction(alertView: alertView);
        }
    }
    
    public func didPresentAlertView(alertView: UIAlertView){
        if let didPresentAlertViewAction = self.didPresentAlertViewAction {
            didPresentAlertViewAction(alertView: alertView);
        }
    }
    
    public func alertView(alertView: UIAlertView, willDismissWithButtonIndex buttonIndex: Int){
        if let willDismissWithButtonIndexAction = self.willDismissWithButtonIndexAction {
            willDismissWithButtonIndexAction(alertView: alertView, buttonIndex: buttonIndex);
        }
    }
    
    public func alertView(alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int){
        if let didDismissWithButtonIndexAction = self.didDismissWithButtonIndexAction{
            didDismissWithButtonIndexAction(alertView: alertView, buttonIndex: buttonIndex);
        }
    }
    
    public func alertViewShouldEnableFirstOtherButton(alertView: UIAlertView) -> Bool{
        if let alertViewShouldEnableFirstOtherButtonAction = self.alertViewShouldEnableFirstOtherButtonAction {
            return alertViewShouldEnableFirstOtherButtonAction(alertView: alertView);
        }
        return true;
    }
    
}