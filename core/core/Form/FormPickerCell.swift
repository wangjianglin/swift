//
//  FormPickerCell.swift
//  SwiftForms
//
//  Created by Miguel Angel Ortuno on 22/08/14.
//  Copyright (c) 2014 Miguel Angel Ortuño. All rights reserved.
//

import UIKit

open class FormPickerCell: FormBaseCell, UIPickerViewDelegate, UIPickerViewDataSource {
    
    /// MARK: Properties
    
    fileprivate let hiddenTextField = UITextField(frame: CGRect.zero)
    fileprivate let picker = UIPickerView()
    
    /// MARK: FormBaseCell
    
    override open func configure() {
        super.configure()
        contentView.addSubview(hiddenTextField)
        picker.delegate = self
        picker.dataSource = self
        hiddenTextField.inputView = picker
    }
    
    override open func update() {
        super.update()
        textLabel?.text = rowDescriptor.title
        
        if rowDescriptor.value != nil {
            detailTextLabel?.text = rowDescriptor.titleForOptionValue(rowDescriptor.value!)
        }
    }
    
    override open class func formViewController(_ formViewController: FormViewController, didSelectRow selectedRow: FormBaseCell) {
        
        if selectedRow.rowDescriptor.value == nil {
//            if let row = selectedRow as? FormPickerCell {
//                let optionValue = selectedRow.rowDescriptor.options[0]
//                selectedRow.rowDescriptor.value = va
                //selectedRow.detailTextLabel?.text = selectedRow.rowDescriptor.titleForOptionValue(optionValue)
                //row.hiddenTextField.becomeFirstResponder()
//            }
        }
    }
    
    /// MARK: UIPickerViewDelegate
    
    open func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //return rowDescriptor.titleForOptionAtIndex(row)
        return nil;
    }
    
    open func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        let optionValue = rowDescriptor.options[row]
//        rowDescriptor.value = optionValue
//        detailTextLabel?.text = rowDescriptor.titleForOptionValue(optionValue)
    }
    
    /// MARK: UIPickerViewDataSource
    
    open func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    open func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //return rowDescriptor.options.count
        return 0;
    }
}

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
