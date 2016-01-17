//
//  FormBaseCell.swift
//  SwiftForms
//
//  Created by Miguel Angel Ortuno on 20/08/14.
//  Copyright (c) 2014 Miguel Angel Ortuño. All rights reserved.
//

import UIKit

public class FormBaseCell: UITableViewCell {

    /// MARK: Properties
    
    public var rowDescriptor: FormRowDescriptor! {
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
    private var valueLabel:UILabel?;
    
    public func configure() {
        /// override
        //self.textLabel?.text=self.rowDescriptor.title;
        valueLabel = UILabel();
        valueLabel!.textAlignment = NSTextAlignment.Right;
        valueLabel!.translatesAutoresizingMaskIntoConstraints = false;
        contentView.addSubview(valueLabel!);
        contentView.addConstraints([
            NSLayoutConstraint(item: valueLabel!, attribute: .Left, relatedBy: .Equal, toItem: self.textLabel!, attribute: .Left, multiplier: 1.0, constant: 0.0),NSLayoutConstraint(item: valueLabel!, attribute: .Right, relatedBy: .Equal, toItem: contentView, attribute: .Right, multiplier: 1.0, constant: -30.0),NSLayoutConstraint(item: valueLabel!, attribute: .Top, relatedBy: .Equal, toItem: contentView, attribute: .Top, multiplier: 1.0, constant: 0.0),NSLayoutConstraint(item: valueLabel!, attribute: .Bottom, relatedBy: .Equal, toItem: contentView, attribute: .Bottom, multiplier: 1.0, constant: 0.0)]);
        accessoryType = .None
    }
    
    public func update() {
        /// override
        self.textLabel?.text=self.rowDescriptor.title;
        if let value = self.rowDescriptor.value as? String{
            valueLabel!.text = value;
        }else{
            valueLabel!.text = "";
        }
    }
    
    public class func formRowCellHeight() -> CGFloat {
        return 44.0
    }
    
    public class func formViewController(formViewController: FormViewController, didSelectRow: FormBaseCell) {
    }
}

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
