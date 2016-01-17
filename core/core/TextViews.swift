//
//  TextView.swift
//  LinControls
//
//  Created by lin on 1/20/15.
//  Copyright (c) 2015 lin. All rights reserved.
//

import Foundation
import UIKit


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
        
        defaultCenter.addObserver(self, selector: "textViewDidBeginEditing:", name: UITextViewTextDidBeginEditingNotification, object: self);
        defaultCenter.addObserver(self, selector: "textViewDidEndEditing:", name: UITextViewTextDidEndEditingNotification, object: self);

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
            
            let doneBarButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "doneButtonIsClicked:");
            
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
        
        defaultCenter.addObserver(self,selector:"keyboardDidShow:",name:UIKeyboardDidShowNotification,object:nil);
        
        defaultCenter.addObserver(self,selector:"keyboardWillHide:",name:UIKeyboardWillHideNotification,object:nil);
        
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