//
//  TextFields.swift
//  LinControls
//
//  Created by lin on 1/20/15.
//  Copyright (c) 2015 lin. All rights reserved.
//


import Foundation
import UIKit

extension UITextField{
    
    //    let UITextViewTextDidBeginEditingNotification: NSString!
    //    let UITextViewTextDidChangeNotification: NSString!
    //    let UITextViewTextDidEndEditingNotification: NSString!
    //
    public func setup(){
        
        let defaultCenter = NSNotificationCenter.defaultCenter();
        
        defaultCenter.addObserver(self, selector: "textFieldDidBeginEditing:", name: UITextFieldTextDidBeginEditingNotification, object: self);
        defaultCenter.addObserver(self, selector: "textFieldDidEndEditing:", name: UITextFieldTextDidEndEditingNotification, object: self);
        
        //        toolbar.frame = CGRectMake(0, 0, self.window.frame.size.width, 44);
        
        
    }
    
    //MARK: - UITextView notifications
    
    private func getToolbar()->UIToolbar{
        let toolbar = UIToolbar(frame: CGRectMake(0, 0, self.window!.frame.size.width, 44));
        
        toolbar.barStyle = UIBarStyle.Default;
        
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "doneButtonIsClicked:");
        
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
        
        defaultCenter.addObserver(self,selector:"keyboardDidShow:",name:UIKeyboardDidShowNotification,object:nil);
        
        defaultCenter.addObserver(self,selector:"keyboardWillHide:",name:UIKeyboardWillHideNotification,object:nil);
        
        defaultCenter.addObserver(self,selector:"keyboardWillHide:",name:UIDeviceOrientationDidChangeNotification,object:nil);
        
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