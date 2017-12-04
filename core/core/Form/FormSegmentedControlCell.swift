//
//  FormSegmentedControlCell.swift
//  SwiftForms
//
//  Created by Miguel Angel Ortuno on 21/08/14.
//  Copyright (c) 2014 Miguel Angel Ortuño. All rights reserved.
//

import UIKit

open class FormSegmentedControlCell: FormBaseCell {

    /// MARK: Properties
    
    let titleLabel = UILabel()
    let segmentedControl = UISegmentedControl()
    
    fileprivate var customConstraints: [NSLayoutConstraint]!
    
    /// MARK: FormBaseCell
    
    override open func configure() {
        super.configure()
        selectionStyle = .none
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 500), for: .horizontal)
        segmentedControl.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 500), for: .horizontal)
        titleLabel.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
        contentView.addSubview(titleLabel)
        contentView.addSubview(segmentedControl)
        contentView.addConstraints(layoutConstraints());
        segmentedControl.addTarget(self, action: #selector(FormSegmentedControlCell.valueChanged(_:)), for: .valueChanged)
    }
    
    override open func update() {
        super.update()
        titleLabel.text = rowDescriptor.title
        updateSegmentedControl()
        
//        var idx = 0
//        if rowDescriptor.value != nil {
////            for optionValue in rowDescriptor.options {
////                if optionValue == rowDescriptor.value {
////                    segmentedControl.selectedSegmentIndex = idx
////                    break
////                }
////                ++idx
////            }
//        }
    }
    
    /// MARK: Constraints
    
    fileprivate func layoutConstraints() -> [NSLayoutConstraint] {
        var result: [NSLayoutConstraint] = []
        titleLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 500), for: .horizontal)
        result.append(NSLayoutConstraint(item: titleLabel, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        result.append(NSLayoutConstraint(item: segmentedControl, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        return result
    }
    
    override open func updateConstraints() {
        
        if customConstraints != nil {
            contentView.removeConstraints(customConstraints)
        }
        
        let views = ["titleLabel" : titleLabel, "segmentedControl" : segmentedControl]
        
        if titleLabel.text != nil && (titleLabel.text!).characters.count > 0 {
            customConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[titleLabel]-16-[segmentedControl]-16-|", options: NSLayoutFormatOptions(rawValue: 0), metrics:nil, views: views)
        }
        else {
            customConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[segmentedControl]-16-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
        }
        
        contentView.addConstraints(customConstraints)
        super.updateConstraints()
    }
    
    /// MARK: Actions
    
    @objc func valueChanged(_ sender: UISegmentedControl) {
//        let optionValue = rowDescriptor.options[sender.selectedSegmentIndex]
//        rowDescriptor.value = optionValue
    }
    
    /// MARK: Private
    
    fileprivate func updateSegmentedControl() {
        segmentedControl.removeAllSegments()
//        var idx = 0
//        for optionValue in rowDescriptor.options {
//            segmentedControl.insertSegmentWithTitle(rowDescriptor.titleForOptionValue(optionValue), atIndex: idx, animated: false)
//            ++idx
//        }
    }
}

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
