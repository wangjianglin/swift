//
//  TextFields.swift
//  LinControls
//
//  Created by lin on 1/20/15.
//  Copyright (c) 2015 lin. All rights reserved.
//


import Foundation
import UIKit
import LinUtil

extension UITextField{
    
    //    let UITextViewTextDidBeginEditingNotification: NSString!
    //    let UITextViewTextDidChangeNotification: NSString!
    //    let UITextViewTextDidEndEditingNotification: NSString!
    //
    public func setup(){
        
        let defaultCenter = NotificationCenter.default;
        
        defaultCenter.addObserver(self, selector: #selector(UITextFieldDelegate.textFieldDidBeginEditing(_:)), name: NSNotification.Name.UITextFieldTextDidBeginEditing, object: self);
        defaultCenter.addObserver(self, selector: #selector(UITextFieldDelegate.textFieldDidEndEditing(_:)), name: NSNotification.Name.UITextFieldTextDidEndEditing, object: self);
        
        //        toolbar.frame = CGRectMake(0, 0, self.window.frame.size.width, 44);
        
        
    }
    
    //MARK: - UITextView notifications
    
    private func getToolbar()->UIToolbar{
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.window!.frame.size.width, height: 40));
        
        toolbar.barStyle = UIBarStyle.default;
        
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(UITextField.doneButtonIsClicked(_:)));
        
//        UIBarButtonItem   *SpaceButton=[[UIBarButtonItem alloc]  initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace     target:nil   action:nil];
//        [buttons addObject:SpaceButton];
//        [SpaceButton release];
        
        let spaceBarButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil);
        
        let barButtonItems = [spaceBarButton,doneBarButton];
        toolbar.items = barButtonItems;
        
        return toolbar;
    }
    
    //- (void)textFieldDidBeginEditing:(NSNotification *) notification
    public func textFieldDidBeginEditing(_ notification:Notification){
//        println("begin...");
        
        
//        var textField = notification.object as UITextField;
        
        let defaultCenter = NotificationCenter.default;
        
        defaultCenter.addObserver(self,selector:#selector(UITextField.keyboardDidShow(_:)),name:NSNotification.Name.UIKeyboardDidShow,object:nil);
        
        defaultCenter.addObserver(self,selector:#selector(UITextField.keyboardWillHide(_:)),name:NSNotification.Name.UIKeyboardWillHide,object:nil);
        
        defaultCenter.addObserver(self,selector:#selector(UITextField.keyboardWillHide(_:)),name:NSNotification.Name.UIDeviceOrientationDidChange,object:nil);
        
        //self.setBarButtonNeedsDisplayAtTag(textView.tag);
        
        //if ([self.superview isKindOfClass:[UIScrollView class]] && self.scrollView == nil)
        //self.scrollView = (UIScrollView*)self.superview;
        
        //[self selectInputView:textField];
        //self.setInputAccessoryView = toolbar;
        
        self.inputAccessoryView = self.getToolbar();
        //self.inputView = self.getToolbar();
        //[self setDoneCommand:NO];
        //[self setToolbarCommand:NO];
        self.becomeFirstResponder();
    }
    
    //-(void) keyboardDidShow:(NSNotification *) notification
    public func keyboardDidShow(_ notification:Notification)
    {
        var info = (notification as NSNotification).userInfo;
        
        let aValue = info![UIKeyboardFrameBeginUserInfoKey] as! NSValue;
        //var aValue = info objectForKey:UIKeyboardFrameBeginUserInfoKey];
        let keyboardSize = aValue.cgRectValue.size;
        //var keyboardSize = [aValue CGRectValue].size;
        self.scrollToTextView(keyboardSize);
        
    }
    public func keyboardWillHide(_ notification:Notification)
    {
        self.resignFirstResponder();
    }
    
    public func doneButtonIsClicked(_ sender:AnyObject)
    {
        self.hiddenWindow();
    }
    
    //    - (void) selectInputView:(UITextField *)textField
    //    {
    //    if (_isDateField){
    //    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    //    datePicker.datePickerMode = UIDatePickerModeDate;
    //    [datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    //
    //    if (![textField.text isEqualToString:@""]){
    //    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //    [dateFormatter setDateFormat:@"MM/dd/YY"];
    //    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    //    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    //    [datePicker setDate:[dateFormatter dateFromString:textField.text]];
    //    }
    //    [textField setInputView:datePicker];
    //    }
    //    }
    //
    public func textFieldDidEndEditing(_ notification:Notification){
        let defaultCenter = NotificationCenter.default;
        //        func removeObserver(observer: AnyObject, name aName: String?, object anObject: AnyObject?)
        defaultCenter.removeObserver(self,name:NSNotification.Name.UIKeyboardDidShow,object:nil);
        
        defaultCenter.removeObserver(self,name:NSNotification.Name.UIKeyboardWillHide,object:nil);
        
        self.hiddenWindow();
    }
    
    private func hiddenWindow(){
        var frame = self.window!.frame;
        frame.origin.y = 0;
        frame.origin.x = 0;
        self.window?.frame = frame;
        self.resignFirstResponder();
    }
    
    private func scrollToTextView(_ keyboardSize:CGSize)
    {
        var frame = self.window!.frame;

        var rect = self.bounds;
        rect.origin = self.convert(rect.origin, to: self.window!);

        let aRect = self.window!.bounds;
        
        
        if aRect.origin.y + aRect.size.height - rect.origin.y - rect.height < keyboardSize.height - 10 {
            frame.origin.y = aRect.origin.y + aRect.size.height - rect.origin.y - keyboardSize.height - rect.height - 40;
        }
        self.window?.frame = frame;
    }
    
}



private class _UITextFieldLinCoreDelegateAction : DelegateAction,UITextFieldDelegate{
    
    fileprivate var _textFieldShouldBeginEditing:((_ textField: UITextField) -> Bool)?
    fileprivate var _textFieldDidBeginEditing:((_ textField: UITextField)->())?; // became first responder
    fileprivate var _textFieldShouldEndEditing:((_ textField: UITextField) -> Bool)? // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
    fileprivate var _textFieldDidEndEditing:((_ textField: UITextField)->())? // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
    
    fileprivate var _textFieldshouldChangeCharactersInRange:((_ textField: UITextField, _ shouldChangeCharactersInRange: NSRange, _ replacementString: String) -> Bool)?; // return NO to not change text
    
    fileprivate var _textFieldShouldClear:((_ textField: UITextField) -> Bool)? // called when clear button pressed. return NO to ignore (no notifications)
    fileprivate var _textFieldShouldReturn:((_ textField: UITextField) -> Bool)? // called when 'return' key pressed. return NO to ignore.
    
    
    //====
    
    @objc fileprivate func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{ // return NO to disallow editing.{
        return self._textFieldShouldBeginEditing?(textField) ?? true;
    }
    @objc fileprivate func textFieldDidBeginEditing(_ textField: UITextField){ // became first responder
        self._textFieldDidBeginEditing?(textField);
    }
    @objc fileprivate func textFieldShouldEndEditing(_ textField: UITextField) -> Bool{ // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
        return self._textFieldShouldEndEditing?(textField) ?? true;
    }
    @objc fileprivate func textFieldDidEndEditing(_ textField: UITextField){ // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
        self._textFieldDidEndEditing?(textField);
    }
    
    @objc fileprivate func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{ // return NO to not change text
        return self._textFieldshouldChangeCharactersInRange?(textField,range,string) ?? true;
    }
    
    @objc fileprivate func textFieldShouldClear(_ textField: UITextField) -> Bool{ // called when clear button pressed. return NO to ignore (no notifications)
        return self._textFieldShouldClear?(textField) ?? true;
    }
    @objc fileprivate func textFieldShouldReturn(_ textField: UITextField) -> Bool{ // called when 'return' key pressed. return NO to ignore.
        return self._textFieldShouldReturn?(textField) ?? true;
    }

//-(void (^)(UITextView *))textViewDidChange{
//    return [self delegateAction]->_textViewDidChange;
//}
//
//-(void)setTextViewDidChange:(void (^)(UITextView *))textViewDidChange{
//    [self delegateAction]->_textViewDidChange = textViewDidChange;
//}

}

extension UITextField{
    
    fileprivate var actionDelegate:_UITextFieldLinCoreDelegateAction{
        if let d = self.delegate {
            if d is _UITextFieldLinCoreDelegateAction {
                return d as! _UITextFieldLinCoreDelegateAction;
            }
        }
        let da = _UITextFieldLinCoreDelegateAction();
        da.withObjectSameLifecycle = self;
        self.delegate = da;
        return da;
    }
    public var textFieldShouldBeginEditing:((_ textField: UITextField) -> Bool)?{
        get{
            return actionDelegate._textFieldShouldBeginEditing;
        }
        set{
            actionDelegate._textFieldShouldBeginEditing = newValue;
        }
    }
    public var textFieldDidBeginEditing:((_ textField: UITextField)->())?{ // became first responder
        get{
            return actionDelegate._textFieldDidBeginEditing;
        }
        set{
            actionDelegate._textFieldDidBeginEditing = newValue;
        }
    }
    public var textFieldShouldEndEditing:((_ textField: UITextField) -> Bool)?{ // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
        get{
            return actionDelegate._textFieldShouldEndEditing;
        }
        set{
            actionDelegate._textFieldShouldEndEditing = newValue;
        }
    }
    public var textFieldDidEndEditing:((_ textField: UITextField)->())?{ // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
        get{
            return actionDelegate._textFieldDidEndEditing;
        }
        set{
            actionDelegate._textFieldDidEndEditing = newValue;
        }
    }
    
    public var textFieldshouldChangeCharactersInRange:((_ textField: UITextField, _ shouldChangeCharactersInRange: NSRange, _ replacementString: String) -> Bool)?{ // return NO to not change text
        get{
            return actionDelegate._textFieldshouldChangeCharactersInRange;
        }
        set{
            actionDelegate._textFieldshouldChangeCharactersInRange = newValue;
        }
    }
    
    public var textFieldShouldClear:((_ textField: UITextField) -> Bool)?{ // called when clear button pressed. return NO to ignore (no notifications)
        get{
            return actionDelegate._textFieldShouldClear;
        }
        set{
            actionDelegate._textFieldShouldClear = newValue;
        }
    }
    public var textFieldShouldReturn:((_ textField: UITextField) -> Bool)?{ // called when 'return' key pressed. return NO to ignore.
        get{
            return actionDelegate._textFieldShouldReturn;
        }
        set{
            actionDelegate._textFieldShouldReturn = newValue;
        }
    }
    
}
