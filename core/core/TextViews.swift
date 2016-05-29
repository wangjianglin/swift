//
//  TextView.swift
//  LinControls
//
//  Created by lin on 1/20/15.
//  Copyright (c) 2015 lin. All rights reserved.
//

import Foundation
import UIKit
import LinUtil


//private var set_toolbar_dispatch_queue:dispatch_queue_attr_t{
//    struct YRSingleton{
//        static var predicate:dispatch_once_t = 0
//        static var instance:dispatch_queue_attr_t? = nil
//    }
//    dispatch_once(&YRSingleton.predicate,{
//        YRSingleton.instance = dispatch_queue_create("UITextView_set_toolbar_dispatch_queue", nil);
//    })
//    return YRSingleton.instance!
//}

extension UITextView{
    
//    let UITextViewTextDidBeginEditingNotification: NSString!
//    let UITextViewTextDidChangeNotification: NSString!
//    let UITextViewTextDidEndEditingNotification: NSString!
//    
    public func setup(){
        
        let defaultCenter = NSNotificationCenter.defaultCenter();
        
        defaultCenter.addObserver(self, selector: #selector(UITextViewDelegate.textViewDidBeginEditing(_:)), name: UITextViewTextDidBeginEditingNotification, object: self);
        defaultCenter.addObserver(self, selector: #selector(UITextViewDelegate.textViewDidEndEditing(_:)), name: UITextViewTextDidEndEditingNotification, object: self);

//        toolbar.frame = CGRectMake(0, 0, self.window.frame.size.width, 44);
        
        
        self.setToolbar();
    }
    
    //MARK: - UITextView notifications
    
    private func setToolbar(){
        
//        if self.window == nil {
//            
//            dispatch_async(set_toolbar_dispatch_queue, { () -> Void in
//                dispatch_async(dispatch_get_main_queue(), {() in
//                    self.setToolbar();
//                });
//            })
//            
//        }else{
            let toolbar = UIToolbar(frame: CGRectMake(0, 0, 100, 44));
            
            toolbar.barStyle = UIBarStyle.Default;
            
            let doneBarButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: #selector(UITextView.doneButtonIsClicked(_:)));
            
            let spaceBarButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil);
            
            let barButtonItems = [spaceBarButton,doneBarButton];
            
            toolbar.items = barButtonItems;
            self.inputAccessoryView = toolbar;
//        }
        //return toolbar;
    }
    
    //- (void)textFieldDidBeginEditing:(NSNotification *) notification
    public func textViewDidBeginEditing(notification:NSNotification){
        //println("begin...");
        
        
        //var textView = notification.object as UITextView;
 
        let defaultCenter = NSNotificationCenter.defaultCenter();
        
        defaultCenter.addObserver(self,selector:#selector(UITextView.keyboardDidShow(_:)),name:UIKeyboardDidShowNotification,object:nil);
        
        defaultCenter.addObserver(self,selector:#selector(UITextView.keyboardWillHide(_:)),name:UIKeyboardWillHideNotification,object:nil);
        
//        defaultCenter.addObserver(self,selector:"UIDeviceOrientationDidChangeNotificationFun:",name:UIDeviceOrientationDidChangeNotification,object:nil);
        
        preUIDeviceOrientationDidChangeNotification = UIDevice.currentDevice().orientation;
//        if orientation == preUIDeviceOrientationDidChangeNotification {
//            return;
//        }
//        preUIDeviceOrientationDidChangeNotification = orientation;
        
        //self.setBarButtonNeedsDisplayAtTag(textView.tag);
        
        //if ([self.superview isKindOfClass:[UIScrollView class]] && self.scrollView == nil)
        //self.scrollView = (UIScrollView*)self.superview;
        
        //[self selectInputView:textField];
        //self.setInputAccessoryView = toolbar;
        
        //self.inputView = self.getToolbar();
        //[self setDoneCommand:NO];
        //[self setToolbarCommand:NO];
        self.becomeFirstResponder();
    }
    
    //-(void) keyboardDidShow:(NSNotification *) notification
    public func keyboardDidShow(notification:NSNotification)
    {
        var info = notification.userInfo;
        
        let aValue = info![UIKeyboardFrameBeginUserInfoKey] as! NSValue;
        //var aValue = info objectForKey:UIKeyboardFrameBeginUserInfoKey];
        let keyboardSize = aValue.CGRectValue().size;
        self.scrollToTextView(keyboardSize);
    
    }
    public func keyboardWillHide(notification:NSNotification)
    {
        //println("**********************");
        var frame = self.window!.frame;
        frame.origin.y = 0;
        self.window?.frame = frame;
        
        self.resignFirstResponder();
    }
    
    public func doneButtonIsClicked(sender:AnyObject)
    {
        var frame = self.window!.frame;
        frame.origin.y = 0;
        frame.origin.x = 0;
        self.window?.frame = frame;
        
        self.resignFirstResponder();
    }
    
    private func selectInputView(){
        
    }

//    public func UIDeviceOrientationDidChangeNotificationFun(notification:NSNotification){
//        var orientation = UIDevice.currentDevice().orientation;
//        if orientation == preUIDeviceOrientationDidChangeNotification {
//            return;
//        }
//        preUIDeviceOrientationDidChangeNotification = orientation;
//        
//        var defaultCenter = NSNotificationCenter.defaultCenter();
//        defaultCenter.removeObserver(self,name:UIKeyboardDidShowNotification,object:nil);
//        
//        defaultCenter.removeObserver(self,name:UIKeyboardWillHideNotification,object:nil);
//        defaultCenter.removeObserver(self,name:UIDeviceOrientationDidChangeNotification,object:nil);
//        
//        var frame = self.window!.frame;
//        frame.origin.y = 0;
//        frame.origin.x = 0;
//        self.window?.frame = frame;
//    }
    //[[UIDevicecurrentDevice]orientation]UIDeviceOrientationDidChangeNotification
//    
    public func textViewDidEndEditing(notification:NSNotification){

        let defaultCenter = NSNotificationCenter.defaultCenter();
//        func removeObserver(observer: AnyObject, name aName: String?, object anObject: AnyObject?)
        defaultCenter.removeObserver(self,name:UIKeyboardDidShowNotification,object:nil);
        
        defaultCenter.removeObserver(self,name:UIKeyboardWillHideNotification,object:nil);
        
        var frame = self.window!.frame;
        frame.origin.y = 0;
        frame.origin.x = 0;
        self.window?.frame = frame;
    }
    
    private func scrollToTextView(keyboardSize:CGSize)
    {
        var frame = self.window!.frame;
        
        var rect = self.bounds;
        rect.origin = self.convertPoint(rect.origin, toView: self.window!);
        
        let aRect = self.window!.bounds;
        
        
        if aRect.origin.y + aRect.size.height - rect.origin.y < keyboardSize.height + 40 {
            frame.origin.y = aRect.origin.y + aRect.size.height - rect.origin.y - keyboardSize.height - 40 - 40;
        }
        self.window?.frame = frame;
    }
    
}

private var preUIDeviceOrientationDidChangeNotification:UIDeviceOrientation?


//MARK:actoins


private class __UITextViewLinCoreDelegateAction : DelegateAction,UITextViewDelegate {
//    @private
    private var _target:UITextView?;
////}
////
////-initWithTarget:(UITextView*)target;
////-(void)textFieldDidBeginEditing:(NSNotification *) notification;
////-(void) keyboardDidShow:(NSNotification *) notification;
////-(void)keyboardWillHide:(NSNotification*)notification;
////-(void)doneButtonIsClicked:(NSObject*)sender;
////-(void)textFieldDidEndEditing:(NSNotification*)notification;
////-(void)deviceOrientationDidChangeNotification:(NSNotification*)notification;
////
////@end
//
//@interface UITextViewsLinCoreDelegateActionImple : DelegateAction<UITextViewDelegate>{
//    @public
    private var _textViewDidChange:((textView:UITextView)->())?;
    private var _textViewShouldBeginEditing:((textView:UITextView)->Bool)?;
    private var _textViewShouldEndEditing:((textView:UITextView)->Bool)?;
    private var _textViewDidBeginEditing:((textView:UITextView)->())?;
    private var _textViewDidEndEditing:((textView:UITextView)->())?;
    private var _textViewDidChangeSelection:((textView:UITextView)->())?;
    private var _textViewShouldChangeTextInRange:((textView: UITextView, shouldChangeTextInRange: NSRange, replacementText: String)->Bool)?;
    

    private var _textViewShouldInteraceWithURL:((textView: UITextView, shouldInteractWithURL: NSURL, inRange: NSRange) -> Bool)?
    
    private var _textViewShouldInteractWithTextAttachment:((textView: UITextView, shouldInteractWithTextAttachment: NSTextAttachment, inRange: NSRange) -> Bool)?
    
    @objc private func textViewShouldBeginEditing(textView: UITextView) -> Bool{
        return _textViewShouldBeginEditing?(textView: textView) ?? true;
    }
    
    @objc private func textViewShouldEndEditing(textView: UITextView) -> Bool{
        return self._textViewShouldEndEditing?(textView: textView) ?? true;
    }
    
    @objc private func textViewDidBeginEditing(textView: UITextView){
        self._textViewDidBeginEditing?(textView: textView);
    }
    
    @objc private func textViewDidEndEditing(textView: UITextView){
        self._textViewDidEndEditing?(textView: textView);
    }
    
    @objc private func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool{
        return self._textViewShouldChangeTextInRange?(textView: textView,shouldChangeTextInRange: range,replacementText: text) ?? true;
    }
    
    @objc private func textViewDidChange(textView: UITextView){
        self._textViewDidChange?(textView: textView);
    }
    
    @objc private func textViewDidChangeSelection(textView: UITextView){
        self._textViewDidChangeSelection?(textView: textView);
    }
    
    @objc private func textView(textView: UITextView, shouldInteractWithURL URL: NSURL, inRange characterRange: NSRange) -> Bool{
        return self._textViewShouldInteraceWithURL?(textView: textView,shouldInteractWithURL: URL,inRange: characterRange) ?? true;
    }
    
    @objc private func textView(textView: UITextView, shouldInteractWithTextAttachment textAttachment: NSTextAttachment, inRange characterRange: NSRange) -> Bool{
        return self._textViewShouldInteractWithTextAttachment?(textView: textView,shouldInteractWithTextAttachment: textAttachment,inRange: characterRange) ?? true;
    }


}

extension UITextView{
    
    private var actionDelegate:__UITextViewLinCoreDelegateAction{
        
        let d = self.delegate;
        if d is __UITextViewLinCoreDelegateAction {
            return d as! __UITextViewLinCoreDelegateAction;
        }
        
        let da = __UITextViewLinCoreDelegateAction();
        self.delegate = da;
        da.withObjectSameLifecycle = self;
        return da;
    }

    public var textViewDidChange:((textView:UITextView)->())?{
        get{
            return actionDelegate._textViewDidChange;
        }
        set{
            actionDelegate._textViewDidChange = newValue;
        }
    }
    public var textViewShouldBeginEditing:((textView:UITextView)->Bool)?{
        get{
            return actionDelegate._textViewShouldBeginEditing;
        }
        set{
            actionDelegate._textViewShouldBeginEditing = newValue;
        }
    }
    public var textViewShouldEndEditing:((textView:UITextView)->Bool)?{
        get{
            return actionDelegate._textViewShouldEndEditing;
        }
        set{
            actionDelegate._textViewShouldEndEditing = newValue;
        }
    }
    public var textViewDidBeginEditing:((textView:UITextView)->())?{
        get{
            return actionDelegate._textViewDidBeginEditing;
        }
        set{
            actionDelegate._textViewDidBeginEditing = newValue;
        }
    }
    public var textViewDidEndEditing:((textView:UITextView)->())?{
        get{
            return actionDelegate._textViewDidEndEditing;
        }
        set{
            actionDelegate._textViewDidEndEditing = newValue;
        }
    }
    public var textViewDidChangeSelection:((textView:UITextView)->())?{
        get{
            return actionDelegate._textViewDidChangeSelection;
        }
        set{
            actionDelegate._textViewDidChangeSelection = newValue;
        }
    }
    public var textViewShouldChangeTextInRange:((textView: UITextView, shouldChangeTextInRange: NSRange, replacementText: String)->Bool)?{
        get{
            return actionDelegate._textViewShouldChangeTextInRange;
        }
        set{
            actionDelegate._textViewShouldChangeTextInRange = newValue;
        }
    }
}

//-(UITextViewsLinCoreDelegateActionImple*)delegateAction{
//    id action = self.delegate;
//    if ([action isKindOfClass:[UITextViewsLinCoreDelegateActionImple class]]) {
//        return action;
//    }
//    UITextViewsLinCoreDelegateActionImple * delegateA = [[UITextViewsLinCoreDelegateActionImple alloc] init];
//    delegateA.withObjectSameLifecycle = self;
//    self.delegate = delegateA;
//    return delegateA;
//}
//
//-(void (^)(UITextView *))textViewDidChange{
//    return [self delegateAction]->_textViewDidChange;
//}
//
//-(void)setTextViewDidChange:(void (^)(UITextView *))textViewDidChange{
//    [self delegateAction]->_textViewDidChange = textViewDidChange;
//}
//
//-(BOOL (^)(UITextView *))textViewShouldBeginEditing{
//    return [self delegateAction]->_textViewShouldBeginEditing;
//}
//
//-(void)setTextViewShouldBeginEditing:(BOOL (^)(UITextView *))textViewShouldBeginEditing{
//    [self delegateAction]->_textViewShouldBeginEditing = textViewShouldBeginEditing;
//}
//
//-(BOOL (^)(UITextView *))textViewShouldEndEditing{
//    return [self delegateAction]->_textViewShouldEndEditing;
//}
//
//-(void)setTextViewShouldEndEditing:(BOOL (^)(UITextView *))textViewShouldEndEditing{
//    [self delegateAction]->_textViewShouldEndEditing = textViewShouldEndEditing;
//}
//
//-(void (^)(UITextView *))textViewDidBeginEditing{
//    return [self delegateAction]->_textViewDidBeginEditing;
//}
//
//-(void)setTextViewDidBeginEditing:(void (^)(UITextView *))textViewDidBeginEditing{
//    [self delegateAction]->_textViewDidBeginEditing = textViewDidBeginEditing;
//}
//
//-(void (^)(UITextView *))textViewDidEndEditing{
//    return [self delegateAction]->_textViewDidEndEditing;
//}
//
//-(void)setTextViewDidEndEditing:(void (^)(UITextView *))textViewDidEndEditing{
//    [self delegateAction]->_textViewDidEndEditing = textViewDidEndEditing;
//}
//
//-(BOOL (^)(UITextView *, NSRange, NSString *))textView{
//    return [self delegateAction]->_textView;
//}
//
//-(void)setTextView:(BOOL (^)(UITextView *, NSRange, NSString *))textView{
//    [self delegateAction]->_textView = textView;
//}
//
//
//-(void)setup{
//    NSNotificationCenter * defaultConter = [NSNotificationCenter defaultCenter];
//    UITextViewLinCoreDelegateAction * delegateAction = [[UITextViewLinCoreDelegateAction alloc] initWithTarget:self];
//    
//    [defaultConter addObserver:delegateAction selector:@selector(textFieldDidBeginEditing:) name:UITextViewTextDidBeginEditingNotification object:self];
//    [defaultConter addObserver:delegateAction selector:@selector(textFieldDidEndEditing:) name:UITextViewTextDidEndEditingNotification object:self];
//    
//    delegateAction.withObjectSameLifecycle = self;
//}
//
//@end