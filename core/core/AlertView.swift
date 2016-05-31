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
            delegateAction._alertViewCancelAction = newValue;
        }
        get{
            return delegateAction._alertViewCancelAction;
        }
    }
    public var clickedButtonAtIndexAction:((alertView:UIAlertView,buttonIndex:Int)->())?{
        set{
            delegateAction._clickedButtonAtIndexAction = newValue;
        }
        get{
            return delegateAction._clickedButtonAtIndexAction;
        }
    }
    public var willPresentAlertViewAction:((alertView:UIAlertView)->())?{
        set{
            delegateAction._willPresentAlertViewAction = newValue;
        }
        get{
            return delegateAction._willPresentAlertViewAction;
        }
    }
    public var didPresentAlertViewAction:((alertView:UIAlertView)->())?{
        set{
            delegateAction._didPresentAlertViewAction = newValue;
        }
        get{
            return delegateAction._didPresentAlertViewAction;
        }
    }
    public var willDismissWithButtonIndexAction:((alertView:UIAlertView,buttonIndex:Int)->())?{
        set{
            delegateAction._willDismissWithButtonIndexAction = newValue;
        }
        get{
            return delegateAction._willDismissWithButtonIndexAction;
        }
    }
    public var didDismissWithButtonIndexAction:((alertView:UIAlertView,buttonIndex:Int)->())?{
        set{
            delegateAction._didDismissWithButtonIndexAction = newValue;
        }
        get{
            return delegateAction._didDismissWithButtonIndexAction;
        }
    }
    public var alertViewShouldEnableFirstOtherButtonAction:((alertView:UIAlertView)->Bool)?{
        set{
            delegateAction._alertViewShouldEnableFirstOtherButtonAction = newValue;
        }
        get{
            return delegateAction._alertViewShouldEnableFirstOtherButtonAction;
        }
    }
}


private class __LinCore_UIAlertViewDelegateImpl : DelegateAction,UIAlertViewDelegate{
    private var _alertViewCancelAction:((alertView:UIAlertView)->())?;
    private var _clickedButtonAtIndexAction:((alertView:UIAlertView,buttonIndex:Int)->())?;
    private var _willPresentAlertViewAction:((alertView:UIAlertView)->())?;
    private var _didPresentAlertViewAction:((alertView:UIAlertView)->())?;
    private var _willDismissWithButtonIndexAction:((alertView:UIAlertView,buttonIndex:Int)->())?;
    private var _didDismissWithButtonIndexAction:((alertView:UIAlertView,buttonIndex:Int)->())?;
    private var _alertViewShouldEnableFirstOtherButtonAction:((alertView:UIAlertView)->Bool)?;
    
    private override init() {
        super.init();
    }
    
    @objc private func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int){
        if let clickedButtonAtIndexAction = self._clickedButtonAtIndexAction {
            clickedButtonAtIndexAction(alertView: alertView, buttonIndex: buttonIndex);
        }
    }
    
    // Called when we cancel a view (eg. the user clicks the Home button). This is not called when the user clicks the cancel button.
    // If not defined in the delegate, we simulate a click in the cancel button
    @objc private func alertViewCancel(alertView: UIAlertView){
        if let alertViewCancelAction = self._alertViewCancelAction {
            alertViewCancelAction(alertView: alertView);
        }
    }
    
    @objc private func willPresentAlertView(alertView: UIAlertView){
        if let willPresentAlertViewAction = self._willPresentAlertViewAction {
            willPresentAlertViewAction(alertView: alertView);
        }
    }
    
    @objc private func didPresentAlertView(alertView: UIAlertView){
        if let didPresentAlertViewAction = self._didPresentAlertViewAction {
            didPresentAlertViewAction(alertView: alertView);
        }
    }
    
    @objc private func alertView(alertView: UIAlertView, willDismissWithButtonIndex buttonIndex: Int){
        if let willDismissWithButtonIndexAction = self._willDismissWithButtonIndexAction {
            willDismissWithButtonIndexAction(alertView: alertView, buttonIndex: buttonIndex);
        }
    }
    
    @objc private func alertView(alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int){
        if let didDismissWithButtonIndexAction = self._didDismissWithButtonIndexAction{
            didDismissWithButtonIndexAction(alertView: alertView, buttonIndex: buttonIndex);
        }
    }
    
    @objc private func alertViewShouldEnableFirstOtherButton(alertView: UIAlertView) -> Bool{
        if let alertViewShouldEnableFirstOtherButtonAction = self._alertViewShouldEnableFirstOtherButtonAction {
            return alertViewShouldEnableFirstOtherButtonAction(alertView: alertView);
        }
        return true;
    }
    
}