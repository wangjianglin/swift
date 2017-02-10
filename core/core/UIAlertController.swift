//
//  AlertView.swift
//  LinControls
//
//  Created by lin on 1/8/15.
//  Copyright (c) 2015 lin. All rights reserved.
//

import UIKit
import LinUtil


public extension UIAlertController{
    
    public class func showAlert(vc:UIViewController,title:String = "",message:String = ""){
        let _vc = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert);
        let action = UIAlertAction.init(title: "确定", style: UIAlertActionStyle.default, handler: {[weak _vc](action:UIAlertAction) in
            _vc?.dismiss(animated: true, completion: nil);
        });
        _vc.addAction(action);
        vc.present(_vc, animated: true, completion: nil);
        
    }
    
    public class func showActionSheet(vc:UIViewController,title:String = "",message:String = ""){
        let _vc = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertControllerStyle.actionSheet);
        let action = UIAlertAction.init(title: "确定", style: UIAlertActionStyle.default, handler: {[weak _vc](action:UIAlertAction) in
            _vc?.dismiss(animated: true, completion: nil);
        });
        _vc.addAction(action);
        vc.present(_vc, animated: true, completion: nil);
    }
}

//open class AlertView{
public extension UIAlertView{
    
    public class func show(_ titie:String,message:String,buttonTitle:String){
        UIAlertView(title: titie, message: message, delegate: nil, cancelButtonTitle: buttonTitle).show();
    }
    
    public class func show(_ message:String){
        UIAlertView(title: "", message: message, delegate: nil, cancelButtonTitle: "确定").show();
    }
}

public extension UIAlertView{
    
    struct YSignal{
        fileprivate static var install:__LinCore_UIAlertViewDelegateImpl?;
    }
 
    fileprivate static var __once:() = {
    
        YSignal.install = __LinCore_UIAlertViewDelegateImpl();
    }()
    
    fileprivate var delegateAction:__LinCore_UIAlertViewDelegateImpl{
        
        _ = UIAlertView.__once;
        
        YSignal.install?.withObjectSameLifecycle = self;
        
        self.delegate = YSignal.install;
        return YSignal.install!;
    }
    public var alertViewCancelAction:((_ alertView:UIAlertView)->())?{
        set{
            delegateAction._alertViewCancelAction = newValue;
        }
        get{
            return delegateAction._alertViewCancelAction;
        }
    }
    public var clickedButtonAtIndexAction:((_ alertView:UIAlertView,_ buttonIndex:Int)->())?{
        set{
            delegateAction._clickedButtonAtIndexAction = newValue;
        }
        get{
            return delegateAction._clickedButtonAtIndexAction;
        }
    }
    public var willPresentAlertViewAction:((_ alertView:UIAlertView)->())?{
        set{
            delegateAction._willPresentAlertViewAction = newValue;
        }
        get{
            return delegateAction._willPresentAlertViewAction;
        }
    }
    public var didPresentAlertViewAction:((_ alertView:UIAlertView)->())?{
        set{
            delegateAction._didPresentAlertViewAction = newValue;
        }
        get{
            return delegateAction._didPresentAlertViewAction;
        }
    }
    public var willDismissWithButtonIndexAction:((_ alertView:UIAlertView,_ buttonIndex:Int)->())?{
        set{
            delegateAction._willDismissWithButtonIndexAction = newValue;
        }
        get{
            return delegateAction._willDismissWithButtonIndexAction;
        }
    }
    public var didDismissWithButtonIndexAction:((_ alertView:UIAlertView,_ buttonIndex:Int)->())?{
        set{
            delegateAction._didDismissWithButtonIndexAction = newValue;
        }
        get{
            return delegateAction._didDismissWithButtonIndexAction;
        }
    }
    public var alertViewShouldEnableFirstOtherButtonAction:((_ alertView:UIAlertView)->Bool)?{
        set{
            delegateAction._alertViewShouldEnableFirstOtherButtonAction = newValue;
        }
        get{
            return delegateAction._alertViewShouldEnableFirstOtherButtonAction;
        }
    }
}


fileprivate class __LinCore_UIAlertViewDelegateImpl : DelegateAction,UIAlertViewDelegate{
    fileprivate var _alertViewCancelAction:((_ alertView:UIAlertView)->())?;
    fileprivate var _clickedButtonAtIndexAction:((_ alertView:UIAlertView,_ buttonIndex:Int)->())?;
    fileprivate var _willPresentAlertViewAction:((_ alertView:UIAlertView)->())?;
    fileprivate var _didPresentAlertViewAction:((_ alertView:UIAlertView)->())?;
    fileprivate var _willDismissWithButtonIndexAction:((_ alertView:UIAlertView,_ buttonIndex:Int)->())?;
    fileprivate var _didDismissWithButtonIndexAction:((_ alertView:UIAlertView,_ buttonIndex:Int)->())?;
    fileprivate var _alertViewShouldEnableFirstOtherButtonAction:((_ alertView:UIAlertView)->Bool)?;
    
    fileprivate override init() {
        super.init();
    }
    
    @objc fileprivate func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int){
        if let clickedButtonAtIndexAction = self._clickedButtonAtIndexAction {
            clickedButtonAtIndexAction(alertView, buttonIndex);
        }
    }
    
    // Called when we cancel a view (eg. the user clicks the Home button). This is not called when the user clicks the cancel button.
    // If not defined in the delegate, we simulate a click in the cancel button
    @objc fileprivate func alertViewCancel(_ alertView: UIAlertView){
        if let alertViewCancelAction = self._alertViewCancelAction {
            alertViewCancelAction(alertView);
        }
    }
    
    @objc fileprivate func willPresent(_ alertView: UIAlertView){
        if let willPresentAlertViewAction = self._willPresentAlertViewAction {
            willPresentAlertViewAction(alertView);
        }
    }
    
    @objc fileprivate func didPresent(_ alertView: UIAlertView){
        if let didPresentAlertViewAction = self._didPresentAlertViewAction {
            didPresentAlertViewAction(alertView);
        }
    }
    
    @objc fileprivate func alertView(_ alertView: UIAlertView, willDismissWithButtonIndex buttonIndex: Int){
        if let willDismissWithButtonIndexAction = self._willDismissWithButtonIndexAction {
            willDismissWithButtonIndexAction(alertView, buttonIndex);
        }
    }
    
    @objc fileprivate func alertView(_ alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int){
        if let didDismissWithButtonIndexAction = self._didDismissWithButtonIndexAction{
            didDismissWithButtonIndexAction(alertView, buttonIndex);
        }
    }
    
    @objc fileprivate func alertViewShouldEnableFirstOtherButton(_ alertView: UIAlertView) -> Bool{
        if let alertViewShouldEnableFirstOtherButtonAction = self._alertViewShouldEnableFirstOtherButtonAction {
            return alertViewShouldEnableFirstOtherButtonAction(alertView);
        }
        return true;
    }
    
}
