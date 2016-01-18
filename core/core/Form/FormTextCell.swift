//
//  FormTextFieldCell.swift
//  SwiftForms
//
//  Created by Miguel Ángel Ortuño Ortuño on 20/08/14.
//  Copyright (c) 2014 Miguel Angel Ortuño. All rights reserved.
//

import UIKit

public class FormTextCell: FormBaseCell {

    /// MARK: Properties
    
    //let titleLabel = UILabel()
    //let textField = UITextField()
    private let valueLabel = UILabel();
    
    private var customConstraints: [AnyObject]!
    private var rightLayoutConstraint:NSLayoutConstraint?;
    
    /// MARK: FormBaseCell
    
    override public func configure() {
        //super.configure()
        
        selectionStyle = .None
        
        //titleLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        //textField.setTranslatesAutoresizingMaskIntoConstraints(false)

        //titleLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        //textField.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        
        //contentView.addSubview(titleLabel)
        //contentView.addSubview(textField)
        
        //contentView.addConstraints(layoutConstraints())
        
        //textField.addTarget(self, action: "editingChanged:", forControlEvents: .EditingChanged)
        valueLabel.textAlignment = NSTextAlignment.Right;
        valueLabel.translatesAutoresizingMaskIntoConstraints = false;
        contentView.addSubview(valueLabel);
        
        contentView.addConstraints([
            NSLayoutConstraint(item: valueLabel, attribute: .Left, relatedBy: .Equal, toItem: self.textLabel, attribute: .Left, multiplier: 1.0, constant: 0.0),
//            NSLayoutConstraint(item: valueLabel, attribute: .Right, relatedBy: .Equal, toItem: contentView, attribute: .Right, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: valueLabel, attribute: .Top, relatedBy: .Equal, toItem: contentView, attribute: .Top, multiplier: 1.0, constant: 0.0),NSLayoutConstraint(item: valueLabel, attribute: .Bottom, relatedBy: .Equal, toItem: contentView, attribute: .Bottom, multiplier: 1.0, constant: 0.0)]);
            
        rightLayoutConstraint = NSLayoutConstraint(item: valueLabel, attribute: .Right, relatedBy: .Equal, toItem: contentView, attribute: .Right, multiplier: 1.0, constant: 0.0);
        contentView.addConstraint(rightLayoutConstraint!);
        accessoryType = .DisclosureIndicator
    }
    
    //private let editController:FormTextEditController!;
    private class var editController:FormTextEditController{
        struct YRSingleton{
            static var predicate:dispatch_once_t = 0
            static var instance:FormTextEditController? = nil
        }
        dispatch_once(&YRSingleton.predicate,{
            YRSingleton.instance = FormTextEditController()
        })
        return YRSingleton.instance!
    }
    
    
    public override class func formViewController(formViewController: FormViewController, didSelectRow: FormBaseCell) {
       
        let rowDescriptor:FormTextDescriptor = didSelectRow.rowDescriptor as! FormTextDescriptor;
        if !rowDescriptor.enabled {
            return;
        }
        let cell:FormTextCell = didSelectRow as! FormTextCell;
        editController.value = rowDescriptor.value as? String;
        editController.textType = rowDescriptor.textType;
        editController.valueChange = cell.valueChange;
        editController.title = rowDescriptor.title;
        
        formViewController.navigationController?.pushViewController(editController, animated: true);
    }
    
    
    private func valueChange(value:String){
        valueLabel.text = "\(value)";
        self.rowDescriptor.value = value;
    }
    
    public override func update() {
        contentView.removeConstraint(rightLayoutConstraint!);
        
        if rowDescriptor.enabled {
            accessoryType = .DisclosureIndicator;
            rightLayoutConstraint = NSLayoutConstraint(item: valueLabel, attribute: .Right, relatedBy: .Equal, toItem: contentView, attribute: .Right, multiplier: 1.0, constant: 0.0);
        }else{
            accessoryType = .None
            rightLayoutConstraint = NSLayoutConstraint(item: valueLabel, attribute: .Right, relatedBy: .Equal, toItem: contentView, attribute: .Right, multiplier: 1.0, constant: -20.0);
        }
        contentView.addConstraint(rightLayoutConstraint!);
        
        self.textLabel?.text = rowDescriptor.title;
        valueLabel.text = "\(rowDescriptor.value!)";
        
        //titleLabel.text = rowDescriptor.title
//        textField.text = rowDescriptor.value as? String
//    
//        textField.secureTextEntry = false
//        textField.clearButtonMode = .WhileEditing
//        
//        var growDescriptor = rowDescriptor as FormGeneralRowDescriptor;
//        switch( growDescriptor.rowType ) {
//        case .Text:
//            textField.autocorrectionType = .Default
//            textField.autocapitalizationType = .Sentences
//            textField.keyboardType = .Default
//        case .Name:
//            textField.autocorrectionType = .No
//            textField.autocapitalizationType = .Words
//            textField.keyboardType = .Default
//        case .Phone:
//            textField.keyboardType = .PhonePad
//        case .URL:
//            textField.autocorrectionType = .No
//            textField.autocapitalizationType = .None
//            textField.keyboardType = .URL
//        case .Email:
//            textField.autocorrectionType = .No
//            textField.autocapitalizationType = .None
//            textField.keyboardType = .EmailAddress
//        case .Password:
//            textField.autocorrectionType = .No
//            textField.autocapitalizationType = .None
//            textField.keyboardType = .ASCIICapable
//            textField.secureTextEntry = true
//        default:
//            break
//        }
    }
    
    /// MARK: Constraints
    
//    private func layoutConstraints() -> [AnyObject] {
//        var result: [AnyObject] = []
//        titleLabel.setContentHuggingPriority(500, forAxis: .Horizontal)
//        result.append(NSLayoutConstraint(item: titleLabel, attribute: .Height, relatedBy: .Equal, toItem: contentView, attribute: .Height, multiplier: 1.0, constant: 0.0))
//        //.append(NSLayoutConstraint(item: textField, attribute: .Height, relatedBy: .Equal, toItem: contentView, attribute: .Height, multiplier: 1.0, constant: 0.0))
//        result.append(NSLayoutConstraint(item: titleLabel, attribute: .CenterY, relatedBy: .Equal, toItem: contentView, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
//        //result.append(NSLayoutConstraint(item: textField, attribute: .CenterY, relatedBy: .Equal, toItem: contentView, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
//        return result
//    }
    
//    override public func updateConstraints() {
    
//        if customConstraints != nil {
//            contentView.removeConstraints(customConstraints)
//        }
//        
//        var views = ["titleLabel" : titleLabel, "textField" : textField]
//        
//        if self.imageView?.image != nil {
//            
//            views["imageView"] = imageView
//            
//            if titleLabel.text != nil && countElements(titleLabel.text!) > 0 {
//                customConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:[imageView]-[titleLabel]-[textField]-4-|", options: NSLayoutFormatOptions(0), metrics: nil, views: views)
//            }
//            else {
//                customConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:[imageView]-[textField]-4-|", options: NSLayoutFormatOptions(0), metrics: nil, views: views)
//            }
//        }
//        else {
//            if titleLabel.text != nil && countElements(titleLabel.text!) > 0 {
//                customConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-16-[titleLabel]-[textField]-4-|", options: NSLayoutFormatOptions(0), metrics: nil, views: views)
//            }
//            else {
//                customConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-16-[textField]-4-|", options: NSLayoutFormatOptions(0), metrics: nil, views: views)
//            }
//        }
//        
//        contentView.addConstraints(customConstraints)
//        super.updateConstraints()
//    }
    
    /// MARK: Actions
    
//    func editingChanged(sender: UITextField) {
//        //rowDescriptor.value = sender.text
//    }
}

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
