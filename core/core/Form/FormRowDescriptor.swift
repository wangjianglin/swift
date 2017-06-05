//
//  FormRowDescriptor.swift
//  SwiftForms
//
//  Created by Miguel Angel Ortuno on 20/08/14.
//  Copyright (c) 2014 Miguel Angel Ortuño. All rights reserved.
//

import UIKit



public typealias TitleFormatter = (Any) -> String!

open class FormRowDescriptor: NSObject {
    
    /// MARK: Properties
    
    open var title: String!
    open var name: String!
    open var imageName: String!
    
    fileprivate var _value:Any?;
    open var value: Any? {
        set {
            if let vc = self.valueChange{
                let oldValue = self._value;
                self._value = newValue;
                vc(newValue, oldValue);
            }else{
                self._value = newValue;
            }
        }
        get {return _value;}
    }
    open var valueChange:((_ newValue:Any?,_ oldValue:Any?)->())?;
    //public var options: [NSObject]!
    
    open var titleFormatter: TitleFormatter!
    
    open var cellStyle: UITableViewCellStyle = .value1
    //public var cellClass: AnyClass!
    //public var cellConfiguration: Dictionary<String, NSObject> = [:]
    //public var cellAccessoryView: UIView!
    
    
    //public var selectorControllerClass: AnyClass!
    
    //表示是否允许编辑
    open var enabled:Bool = false;
    
    //背影颜色
    open var backgroundColor:UIColor?;
    
    /// MARK: Init
    
    public init(title: String,name: String,value:NSObject! = nil) {
        self.name = name
        self.title = title
//        self.imageName = ""
        self._value = value
    }
    
    public init(title: String,imageName: String,name: String,value:NSObject! = nil) {
        self.name = name
        self.title = title
        self.imageName = imageName
        self._value = value
    }
    
    
    /// MARK: Public interface
    
    //    public func titleForOptionAtIndex(index: Int) -> String! {
    //        return titleForOptionValue(options[index])
    //    }
    
    open func titleForOptionValue(_ optionValue: Any) -> String! {
        if titleFormatter != nil {
            return titleFormatter(optionValue)
        }
        else if optionValue is String {
            return optionValue as! String
        }
        return "\(optionValue)"
    }
    
    
    
    
    //public func formBaseCellClassFromRowDescriptor(rowDescriptor: FormRowDescriptor) -> FormBaseCell.Type! {
    open func formBaseCellClassFromRowDescriptor() -> FormBaseCell.Type! {
        
        return FormBaseCell.self;
    }
}

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
