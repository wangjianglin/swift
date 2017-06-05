//
//  FormSwitchCell.swift
//  SwiftForms
//
//  Created by Miguel Angel Ortuno on 21/08/14.
//  Copyright (c) 2014 Miguel Angel Ortuño. All rights reserved.
//

import UIKit

open class FormSwitchCell: FormBaseCell {

    /// MARK: Properties
    
    let switchView = UISwitch()
    
    /// MARK: FormBaseCell
    
    override open func configure() {
        super.configure()
        selectionStyle = .none
        accessoryView = switchView
        switchView.addTarget(self, action: #selector(FormSwitchCell.valueChanged(_:)), for: .valueChanged)
        //switchView.enabled = false;
    }
    
    override open func update() {
        super.update()
//        textLabel?.text = rowDescriptor.title
        switchView.isEnabled = rowDescriptor.enabled;
        
        if rowDescriptor.value != nil {
            switchView.isOn = rowDescriptor.value as! Bool
        }
        else {
            switchView.isOn = false
        }
    }
    
    /// MARK: Actions
    
    func valueChanged(_: UISwitch) {
        rowDescriptor.value = switchView.isOn as Bool
    }
}

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
