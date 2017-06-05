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
    fileprivate var valueLabel:UILabel!
    fileprivate var titleLabel:UILabel!
    fileprivate var imgView: UIImageView!

    
    open func configure() {

        valueLabel = UILabel()
        valueLabel!.textAlignment = NSTextAlignment.right;
        valueLabel!.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel = UILabel()
        titleLabel!.translatesAutoresizingMaskIntoConstraints = false
        
        imgView = UIImageView(frame:CGRect.init(x:15, y:10, width:24, height:24))        
        
        
    }
    
    //设置没图标的cell样式
    open func configureNoImage() {
        
        contentView.addSubview(titleLabel!)
        contentView.addSubview(valueLabel!)
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[titleLabel]-10-|", options:NSLayoutFormatOptions(rawValue: 0), metrics:nil, views:["titleLabel":self.titleLabel!,"valueLabel":valueLabel]))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[valueLabel]-30-|", options:NSLayoutFormatOptions(rawValue: 0), metrics:nil, views:["titleLabel":self.titleLabel!,"valueLabel":valueLabel]))
       
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[titleLabel(24)]-10-|", options:NSLayoutFormatOptions(rawValue: 0), metrics:nil, views:["titleLabel":self.titleLabel!,"valueLabel":valueLabel]))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[valueLabel(24)]-10-|", options:NSLayoutFormatOptions(rawValue: 0), metrics:nil, views:["titleLabel":self.titleLabel!,"valueLabel":valueLabel]))
        
    }

    
    //设置有图标的cell样式
    open func configureImage() {
        
        contentView.addSubview(imgView!)
        contentView.addSubview(titleLabel!)
        contentView.addSubview(valueLabel!)
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[imv(24)]-10-[titleLabel]-10-|", options:NSLayoutFormatOptions(rawValue: 0), metrics:nil, views:["imv":imgView,"titleLabel":self.titleLabel!,"valueLabel":valueLabel]))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[imv(24)]-10-[valueLabel]-30-|", options:NSLayoutFormatOptions(rawValue: 0), metrics:nil, views:["imv":imgView,"titleLabel":self.titleLabel!,"valueLabel":valueLabel]))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[imv(24)]-10-|", options:NSLayoutFormatOptions(rawValue: 0), metrics:nil, views:["imv":imgView,"titleLabel":self.titleLabel!,"valueLabel":valueLabel]))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[titleLabel(24)]-10-|", options:NSLayoutFormatOptions(rawValue: 0), metrics:nil, views:["imv":imgView,"titleLabel":self.titleLabel!,"valueLabel":valueLabel]))
         contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[valueLabel(24)]-10-|", options:NSLayoutFormatOptions(rawValue: 0), metrics:nil, views:["imv":imgView,"titleLabel":self.titleLabel!,"valueLabel":valueLabel]))
        
    }
    
    open func update() {
     
        if self.rowDescriptor.imageName == nil {
            
            configureNoImage()
        }else{
            configureImage()
        }

        self.titleLabel?.text = self.rowDescriptor.title
        
        
        
        if let value = self.rowDescriptor.imageName{
           imgView.image = UIImage(named:value)
        }
        
        
        if let value = self.rowDescriptor.value as? String{
            valueLabel?.text = value
            self.accessoryType = .none
        }else{
            valueLabel?.text = ""
            self.accessoryType = .disclosureIndicator
        }
    }
    
    open class func formRowCellHeight() -> CGFloat {
        return 44.5
    }
    
    open class func formViewController(_ formViewController: FormViewController, didSelectRow: FormBaseCell) {
    }
}

