//
//  FormButtonCell.swift
//  SwiftForms
//
//  Created by Miguel Angel Ortuno on 21/08/14.
//  Copyright (c) 2014 Miguel Angel Ortuño. All rights reserved.
//

import UIKit

public class FormButtonCell: FormBaseCell {

    /// MARK: Properties
    
    let titleLabel = UILabel()
    
    /// MARK: FormBaseCell
    
    override public func configure() {
        super.configure()
//        titleLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
//        titleLabel.textAlignment = .Center
//        titleLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
//        contentView.addSubview(titleLabel)
//        contentView.addConstraints(layoutConstraints())
    }
    
    override public func update() {
        super.update()
        titleLabel.text = rowDescriptor.title as String
    }
    
    /// MARK: Constraints
    
    private func layoutConstraints() -> [AnyObject] {
        var result: [AnyObject] = []
        titleLabel.setContentHuggingPriority(500, forAxis: .Horizontal)
        result.append(NSLayoutConstraint(item: titleLabel, attribute: .Height, relatedBy: .Equal, toItem: contentView, attribute: .Height, multiplier: 1.0, constant: 0.0))
        result.append(NSLayoutConstraint(item: titleLabel, attribute: .Width, relatedBy: .Equal, toItem: contentView, attribute: .Width, multiplier: 1.0, constant: 0.0))
        result.append(NSLayoutConstraint(item: titleLabel, attribute: .CenterY, relatedBy: .Equal, toItem: contentView, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
        result.append(NSLayoutConstraint(item: titleLabel, attribute: .CenterX, relatedBy: .Equal, toItem: contentView, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
        return result
    }
    public override class func formViewController(formViewController: FormViewController, didSelectRow: FormBaseCell) {
        let cell = didSelectRow.rowDescriptor as! FormButtonDescriptor;
        if let click = cell.click {
            click();
        }
    }
}

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
