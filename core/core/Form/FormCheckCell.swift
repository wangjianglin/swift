//
//  FormCheckCell.swift
//  SwiftForms
//
//  Created by Miguel Angel Ortuno on 22/08/14.
//  Copyright (c) 2014 Miguel Angel Ortuño. All rights reserved.
//

import UIKit

public class FormCheckCell: FormBaseCell {

    /// MARK: FormBaseCell
    
    override public func configure() {
        super.configure()
        selectionStyle = .Default
        accessoryType = .None
    }
    
    override public func update() {
        super.update()
        textLabel?.text = rowDescriptor.title
        
        if rowDescriptor.value == nil {
            rowDescriptor.value = false
        }
        
        accessoryType = (rowDescriptor.value as! Bool) ? .Checkmark : .None
    }
    
    override public class func formViewController(formViewController: FormViewController, didSelectRow selectedRow: FormBaseCell) {
        
        if let row = selectedRow as? FormCheckCell {
            row.check()
        }
    }
    
    /// MARK: Private interface
    
    private func check() {
        if rowDescriptor.value != nil {
            rowDescriptor.value = !(rowDescriptor.value as! Bool)
        }
        else {
            rowDescriptor.value = true
        }
        accessoryType = (rowDescriptor.value as! Bool) ? .Checkmark : .None
    }
}

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
