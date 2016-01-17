//
//  FormRowDescriptor.swift
//  SwiftForms
//
//  Created by Miguel Angel Ortuno on 20/08/14.
//  Copyright (c) 2014 Miguel Angel Ortuño. All rights reserved.
//

import UIKit



public typealias TitleFormatter = (NSObject) -> String!

public class FormRowDescriptor: NSObject {

    /// MARK: Properties
    
    public var title: String!
    public var name: String!
    
    private var _value:NSObject?;
    public var value: NSObject? {
        set {
            if let vc = self.valueChange{
                let oldValue = self._value;
                self._value = newValue;
                vc(oldValue: oldValue, newValue: newValue);
            }else{
                self._value = newValue;
            }
        }
        get {return _value;}
    }
    public var valueChange:((oldValue:NSObject?,newValue:NSObject?)->())?;
    //public var options: [NSObject]!
    
    public var titleFormatter: TitleFormatter!
    
    public var cellStyle: UITableViewCellStyle = .Value1
    //public var cellClass: AnyClass!
    //public var cellConfiguration: Dictionary<String, NSObject> = [:]
    //public var cellAccessoryView: UIView!
    
    
    //public var selectorControllerClass: AnyClass!
    
    //表示是否允许编辑
    public var enabled:Bool = false;
    
    //背影颜色
    public var backgroundColor:UIColor?;
    
    /// MARK: Init
    
    public init(title: String,name: String,value:NSObject! = nil) {
        self.name = name
        self.title = title
        self._value = value;
    }
    
    
    
    /// MARK: Public interface
    
//    public func titleForOptionAtIndex(index: Int) -> String! {
//        return titleForOptionValue(options[index])
//    }
    
    public func titleForOptionValue(optionValue: NSObject) -> String! {
        if titleFormatter != nil {
            return titleFormatter(optionValue)
        }
        else if optionValue is String {
            return optionValue as! String
        }
        return "\(optionValue)"
    }

    
    
    
    //public func formBaseCellClassFromRowDescriptor(rowDescriptor: FormRowDescriptor) -> FormBaseCell.Type! {
    public func formBaseCellClassFromRowDescriptor() -> FormBaseCell.Type! {
        
        return FormBaseCell.self;
    }
}

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
