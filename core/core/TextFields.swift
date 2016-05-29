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
        
        let defaultCenter = NSNotificationCenter.defaultCenter();
        
        defaultCenter.addObserver(self, selector: #selector(UITextFieldDelegate.textFieldDidBeginEditing(_:)), name: UITextFieldTextDidBeginEditingNotification, object: self);
        defaultCenter.addObserver(self, selector: #selector(UITextFieldDelegate.textFieldDidEndEditing(_:)), name: UITextFieldTextDidEndEditingNotification, object: self);
        
        //        toolbar.frame = CGRectMake(0, 0, self.window.frame.size.width, 44);
        
        
    }
    
    //MARK: - UITextView notifications
    
    private func getToolbar()->UIToolbar{
        let toolbar = UIToolbar(frame: CGRectMake(0, 0, self.window!.frame.size.width, 44));
        
        toolbar.barStyle = UIBarStyle.Default;
        
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: #selector(UITextField.doneButtonIsClicked(_:)));
        
//        UIBarButtonItem   *SpaceButton=[[UIBarButtonItem alloc]  initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace     target:nil   action:nil];
//        [buttons addObject:SpaceButton];
//        [SpaceButton release];
        
        let spaceBarButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil);
        
        let barButtonItems = [spaceBarButton,doneBarButton];
        toolbar.items = barButtonItems;
        
        return toolbar;
    }
    
    //- (void)textFieldDidBeginEditing:(NSNotification *) notification
    public func textFieldDidBeginEditing(notification:NSNotification){
//        println("begin...");
        
        
//        var textField = notification.object as UITextField;
        
        let defaultCenter = NSNotificationCenter.defaultCenter();
        
        defaultCenter.addObserver(self,selector:#selector(UITextField.keyboardDidShow(_:)),name:UIKeyboardDidShowNotification,object:nil);
        
        defaultCenter.addObserver(self,selector:#selector(UITextField.keyboardWillHide(_:)),name:UIKeyboardWillHideNotification,object:nil);
        
        defaultCenter.addObserver(self,selector:#selector(UITextField.keyboardWillHide(_:)),name:UIDeviceOrientationDidChangeNotification,object:nil);
        
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
    public func keyboardDidShow(notification:NSNotification)
    {
        var info = notification.userInfo;
        
        let aValue = info![UIKeyboardFrameBeginUserInfoKey] as! NSValue;
        //var aValue = info objectForKey:UIKeyboardFrameBeginUserInfoKey];
        let keyboardSize = aValue.CGRectValue().size;
        //var keyboardSize = [aValue CGRectValue].size;
        self.scrollToTextView(keyboardSize);
        
    }
    public func keyboardWillHide(notification:NSNotification)
    {
        self.resignFirstResponder();
    }
    
    public func doneButtonIsClicked(sender:AnyObject)
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
    public func textFieldDidEndEditing(notification:NSNotification){
        let defaultCenter = NSNotificationCenter.defaultCenter();
        //        func removeObserver(observer: AnyObject, name aName: String?, object anObject: AnyObject?)
        defaultCenter.removeObserver(self,name:UIKeyboardDidShowNotification,object:nil);
        
        defaultCenter.removeObserver(self,name:UIKeyboardWillHideNotification,object:nil);
        
        self.hiddenWindow();
    }
    
    private func hiddenWindow(){
        var frame = self.window!.frame;
        frame.origin.y = 0;
        frame.origin.x = 0;
        self.window?.frame = frame;
        self.resignFirstResponder();
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



private class _UITextFieldLinCoreDelegateAction : DelegateAction,UITextFieldDelegate{
    
    private var _textFieldShouldBeginEditing:((textField: UITextField) -> Bool)?
    private var _textFieldDidBeginEditing:((textField: UITextField)->())?; // became first responder
    private var _textFieldShouldEndEditing:((textField: UITextField) -> Bool)? // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
    private var _textFieldDidEndEditing:((textField: UITextField)->())? // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
    
    private var _textFieldshouldChangeCharactersInRange:((textField: UITextField, shouldChangeCharactersInRange: NSRange, replacementString: String) -> Bool)?; // return NO to not change text
    
    private var _textFieldShouldClear:((textField: UITextField) -> Bool)? // called when clear button pressed. return NO to ignore (no notifications)
    private var _textFieldShouldReturn:((textField: UITextField) -> Bool)? // called when 'return' key pressed. return NO to ignore.
    
    
    //====
    
    @objc func textFieldShouldBeginEditing(textField: UITextField) -> Bool{ // return NO to disallow editing.{
        return self._textFieldShouldBeginEditing?(textField: textField) ?? true;
    }
    @objc func textFieldDidBeginEditing(textField: UITextField){ // became first responder
        self._textFieldDidBeginEditing?(textField: textField);
    }
    @objc func textFieldShouldEndEditing(textField: UITextField) -> Bool{ // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
        return self._textFieldShouldEndEditing?(textField: textField) ?? true;
    }
    @objc func textFieldDidEndEditing(textField: UITextField){ // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
        self._textFieldDidEndEditing?(textField: textField);
    }
    
    @objc func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool{ // return NO to not change text
        return self._textFieldshouldChangeCharactersInRange?(textField: textField,shouldChangeCharactersInRange: range,replacementString: string) ?? true;
    }
    
    @objc func textFieldShouldClear(textField: UITextField) -> Bool{ // called when clear button pressed. return NO to ignore (no notifications)
        return self._textFieldShouldClear?(textField: textField) ?? true;
    }
    @objc func textFieldShouldReturn(textField: UITextField) -> Bool{ // called when 'return' key pressed. return NO to ignore.
        return self._textFieldShouldReturn?(textField: textField) ?? true;
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
    
    private var actionDelegate:_UITextFieldLinCoreDelegateAction{
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
    public var textFieldShouldBeginEditing:((textField: UITextField) -> Bool)?{
        get{
            return actionDelegate._textFieldShouldBeginEditing;
        }
        set{
            actionDelegate._textFieldShouldBeginEditing = newValue;
        }
    }
    public var textFieldDidBeginEditing:((textField: UITextField)->())?{ // became first responder
        get{
            return actionDelegate._textFieldDidBeginEditing;
        }
        set{
            actionDelegate._textFieldDidBeginEditing = newValue;
        }
    }
    public var textFieldShouldEndEditing:((textField: UITextField) -> Bool)?{ // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
        get{
            return actionDelegate._textFieldShouldEndEditing;
        }
        set{
            actionDelegate._textFieldShouldEndEditing = newValue;
        }
    }
    public var textFieldDidEndEditing:((textField: UITextField)->())?{ // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
        get{
            return actionDelegate._textFieldDidEndEditing;
        }
        set{
            actionDelegate._textFieldDidEndEditing = newValue;
        }
    }
    
    public var textFieldshouldChangeCharactersInRange:((textField: UITextField, shouldChangeCharactersInRange: NSRange, replacementString: String) -> Bool)?{ // return NO to not change text
        get{
            return actionDelegate._textFieldshouldChangeCharactersInRange;
        }
        set{
            actionDelegate._textFieldshouldChangeCharactersInRange = newValue;
        }
    }
    
    public var textFieldShouldClear:((textField: UITextField) -> Bool)?{ // called when clear button pressed. return NO to ignore (no notifications)
        get{
            return actionDelegate._textFieldShouldClear;
        }
        set{
            actionDelegate._textFieldShouldClear = newValue;
        }
    }
    public var textFieldShouldReturn:((textField: UITextField) -> Bool)?{ // called when 'return' key pressed. return NO to ignore.
        get{
            return actionDelegate._textFieldShouldReturn;
        }
        set{
            actionDelegate._textFieldShouldReturn = newValue;
        }
    }
    
}
