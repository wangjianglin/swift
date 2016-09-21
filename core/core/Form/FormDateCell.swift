//
//  FormDateCell.swift
//  SwiftForms
//
//  Created by Miguel Angel Ortuno on 22/08/14.
//  Copyright (c) 2014 Miguel Angel Ortuño. All rights reserved.
//

import UIKit

open class FormDateCell: FormBaseCell {

    /// MARK: Properties
    
    fileprivate let hiddenTextField = UITextField(frame: CGRect.zero)
    fileprivate let datePicker = UIDatePicker()
    
    fileprivate let defaultDateFormatter = DateFormatter()
    
    /// MARK: FormBaseCell
    
    override open func configure() {
        super.configure()
        contentView.addSubview(hiddenTextField)
        hiddenTextField.inputView = datePicker
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(FormDateCell.valueChanged(_:)), for: .valueChanged)
    }
    
    override open func update() {
        super.update()
        textLabel?.text = rowDescriptor.title
        
        let growDescriptor = rowDescriptor as! FormGeneralRowDescriptor;
        switch( growDescriptor.rowType) {
        case .date:
            datePicker.datePickerMode = .date
            defaultDateFormatter.dateStyle = .long
            defaultDateFormatter.timeStyle = .none
        case .time:
            datePicker.datePickerMode = .time
            defaultDateFormatter.dateStyle = .none
            defaultDateFormatter.timeStyle = .short
        default:
            datePicker.datePickerMode = .dateAndTime
            defaultDateFormatter.dateStyle = .long
            defaultDateFormatter.timeStyle = .short
        }
        
        if rowDescriptor.value != nil {
            let date = rowDescriptor.value as? Date
            datePicker.date = date!
            detailTextLabel?.text = self.getDateFormatter().string(from: date!)
        }
    }
    
    override open class func formViewController(_ formViewController: FormViewController, didSelectRow selectedRow: FormBaseCell) {
        
        let row: FormDateCell! = selectedRow as? FormDateCell
        
        if row.rowDescriptor.value == nil {
            let date = Date()
            row.rowDescriptor.value = date
            row.detailTextLabel?.text = row.getDateFormatter().string(from: date)
        }
        
        row.hiddenTextField.becomeFirstResponder()
    }
    
    /// MARK: Actions
    
    func valueChanged(_ sender: UIDatePicker) {
        rowDescriptor.value = sender.date
        detailTextLabel?.text = getDateFormatter().string(from: sender.date)
    }
    
    /// MARK: Private interface
    
    fileprivate func getDateFormatter() -> DateFormatter {
        
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
