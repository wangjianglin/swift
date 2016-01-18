//
//  FormDateCell.swift
//  SwiftForms
//
//  Created by Miguel Angel Ortuno on 22/08/14.
//  Copyright (c) 2014 Miguel Angel Ortuño. All rights reserved.
//

import UIKit

public class FormDateCell: FormBaseCell {

    /// MARK: Properties
    
    private let hiddenTextField = UITextField(frame: CGRectZero)
    private let datePicker = UIDatePicker()
    
    private let defaultDateFormatter = NSDateFormatter()
    
    /// MARK: FormBaseCell
    
    override public func configure() {
        super.configure()
        contentView.addSubview(hiddenTextField)
        hiddenTextField.inputView = datePicker
        datePicker.datePickerMode = .Date
        datePicker.addTarget(self, action: "valueChanged:", forControlEvents: .ValueChanged)
    }
    
    override public func update() {
        super.update()
        textLabel?.text = rowDescriptor.title
        
        let growDescriptor = rowDescriptor as! FormGeneralRowDescriptor;
        switch( growDescriptor.rowType) {
        case .Date:
            datePicker.datePickerMode = .Date
            defaultDateFormatter.dateStyle = .LongStyle
            defaultDateFormatter.timeStyle = .NoStyle
        case .Time:
            datePicker.datePickerMode = .Time
            defaultDateFormatter.dateStyle = .NoStyle
            defaultDateFormatter.timeStyle = .ShortStyle
        default:
            datePicker.datePickerMode = .DateAndTime
            defaultDateFormatter.dateStyle = .LongStyle
            defaultDateFormatter.timeStyle = .ShortStyle
        }
        
        if rowDescriptor.value != nil {
            let date = rowDescriptor.value as? NSDate
            datePicker.date = date!
            detailTextLabel?.text = self.getDateFormatter().stringFromDate(date!)
        }
    }
    
    override public class func formViewController(formViewController: FormViewController, didSelectRow selectedRow: FormBaseCell) {
        
        let row: FormDateCell! = selectedRow as? FormDateCell
        
        if row.rowDescriptor.value == nil {
            let date = NSDate()
            row.rowDescriptor.value = date
            row.detailTextLabel?.text = row.getDateFormatter().stringFromDate(date)
        }
        
        row.hiddenTextField.becomeFirstResponder()
    }
    
    /// MARK: Actions
    
    func valueChanged(sender: UIDatePicker) {
        rowDescriptor.value = sender.date
        detailTextLabel?.text = getDateFormatter().stringFromDate(sender.date)
    }
    
    /// MARK: Private interface
    
    private func getDateFormatter() -> NSDateFormatter {
        
        let growDescriptor = rowDescriptor as! FormGeneralRowDescriptor;
        if growDescriptor.dateFormatter != nil {
            return growDescriptor.dateFormatter
        }
        return defaultDateFormatter
    }
}

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
