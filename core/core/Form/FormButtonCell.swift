//
//  FormButtonCell.swift
//  SwiftForms
//
//  Created by Miguel Angel Ortuno on 21/08/14.
//  Copyright (c) 2014 Miguel Angel Ortuño. All rights reserved.
//

import UIKit

open class FormButtonCell: FormBaseCell {

    /// MARK: Properties
    
    let titleLabel = UILabel()
    
    /// MARK: FormBaseCell
    
    override open func configure() {
        super.configure()
//        titleLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
//        titleLabel.textAlignment = .Center
//        titleLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
//        contentView.addSubview(titleLabel)
//        contentView.addConstraints(layoutConstraints())
    }
    
    override open func update() {
        super.update()
        titleLabel.text = rowDescriptor.title as String
    }
    
    /// MARK: Constraints
    
    fileprivate func layoutConstraints() -> [AnyObject] {
        var result: [AnyObject] = []
        titleLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 500.0), for: .horizontal)
        result.append(NSLayoutConstraint(item: titleLabel, attribute: .height, relatedBy: .equal, toItem: contentView, attribute: .height, multiplier: 1.0, constant: 0.0))
        result.append(NSLayoutConstraint(item: titleLabel, attribute: .width, relatedBy: .equal, toItem: contentView, attribute: .width, multiplier: 1.0, constant: 0.0))
        result.append(NSLayoutConstraint(item: titleLabel, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        result.append(NSLayoutConstraint(item: titleLabel, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        return result
    }
    open override class func formViewController(_ formViewController: FormViewController, didSelectRow: FormBaseCell) {
        let cell = didSelectRow.rowDescriptor as! FormButtonDescriptor;
        if let click = cell.click {
            click();
        }
    }
}

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
