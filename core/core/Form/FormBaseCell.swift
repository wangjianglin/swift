//
//  FormBaseCell.swift
//  SwiftForms
//
//  Created by Miguel Angel Ortuno on 20/08/14.
//  Copyright (c) 2014 Miguel Angel Ortuño. All rights reserved.
//

import UIKit

open class FormBaseCell: UITableViewCell {

    /// MARK: Properties
    
    open var rowDescriptor: FormRowDescriptor! {
        didSet {
            if let backgroundColor = self.rowDescriptor.backgroundColor{
//                contentView.backgroundColor = backgroundColor;
                self.backgroundColor = backgroundColor
            }
            self.update()
        }
    }
    
    /// MARK: Init
    
    required override public init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /// MARK: Public interface
    fileprivate var valueLabel:UILabel?;
    
    open func configure() {
        /// override
        //self.textLabel?.text=self.rowDescriptor.title;
        valueLabel = UILabel();
        valueLabel!.textAlignment = NSTextAlignment.right;
        valueLabel!.translatesAutoresizingMaskIntoConstraints = false;
        contentView.addSubview(valueLabel!);
        contentView.addConstraints([
            NSLayoutConstraint(item: valueLabel!, attribute: .left, relatedBy: .equal, toItem: self.textLabel!, attribute: .left, multiplier: 1.0, constant: 0.0),NSLayoutConstraint(item: valueLabel!, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1.0, constant: -30.0),NSLayoutConstraint(item: valueLabel!, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1.0, constant: 0.0),NSLayoutConstraint(item: valueLabel!, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1.0, constant: 0.0)]);
        accessoryType = .none
    }
    
    open func update() {
        /// override
        self.textLabel?.text=self.rowDescriptor.title;
        if let value = self.rowDescriptor.value as? String{
            valueLabel?.text = value;
        }else{
            valueLabel?.text = "";
        }
    }
    
    open class func formRowCellHeight() -> CGFloat {
        return 44.0
    }
    
    open class func formViewController(_ formViewController: FormViewController, didSelectRow: FormBaseCell) {
    }
}

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
