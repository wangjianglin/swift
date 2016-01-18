//
//  FormGeneralRowDescriptor.swift
//  LinCore
//
//  Created by lin on 12/25/14.
//  Copyright (c) 2014 lin. All rights reserved.
//

import UIKit


public enum FormRowType {
    case Button
    case BooleanSwitch
    case BooleanCheck
    case SegmentedControl
    case Picker
    case Date
    case Time
    case DateAndTime
    case MultipleSelector
//    case Custom
}

public class FormGeneralRowDescriptor:FormRowDescriptor{
    public var dateFormatter: NSDateFormatter!
    
    private var cellClass:AnyClass!;
    private var _rowType:FormRowType;
    public var rowType:FormRowType{
        return _rowType;
    }
    
    struct Static {
        static var onceDefaultCellClass: dispatch_once_t = 0
        static var defaultCellClasses: Dictionary<FormRowType, FormBaseCell.Type> = [:]
    }
    
    public init(title: String,name: String,rowType:FormRowType,value:NSObject? = nil) {
        self._rowType = rowType;
        super.init(title: title, name: name,value:value);
    }
    
    private class func defaultCellClassForRowType(rowType: FormRowType) -> FormBaseCell.Type {
        dispatch_once(&Static.onceDefaultCellClass) {
//            Static.defaultCellClasses[FormRowType.Text] = FormTextFieldCell.self
//            Static.defaultCellClasses[FormRowType.Phone] = FormTextFieldCell.self
//            Static.defaultCellClasses[FormRowType.URL] = FormTextFieldCell.self
//            Static.defaultCellClasses[FormRowType.Email] = FormTextFieldCell.self
//            Static.defaultCellClasses[FormRowType.Password] = FormTextFieldCell.self
            Static.defaultCellClasses[FormRowType.Button] = FormButtonCell.self
            Static.defaultCellClasses[FormRowType.BooleanSwitch] = FormSwitchCell.self
            Static.defaultCellClasses[FormRowType.BooleanCheck] = FormCheckCell.self
            Static.defaultCellClasses[FormRowType.SegmentedControl] = FormSegmentedControlCell.self
            Static.defaultCellClasses[FormRowType.Picker] = FormPickerCell.self
            Static.defaultCellClasses[FormRowType.Date] = FormDateCell.self
            Static.defaultCellClasses[FormRowType.Time] = FormDateCell.self
            Static.defaultCellClasses[FormRowType.DateAndTime] = FormDateCell.self
            Static.defaultCellClasses[FormRowType.MultipleSelector] = FormSelectorCell.self
        }
        return Static.defaultCellClasses[rowType]!
    }
    
    public override func formBaseCellClassFromRowDescriptor() -> FormBaseCell.Type! {
        
        var formBaseCellClass: FormBaseCell.Type!
        
        if cellClass == nil { // fallback to default cell class
            formBaseCellClass = FormGeneralRowDescriptor.defaultCellClassForRowType(rowType)
        }
        else {
            formBaseCellClass = cellClass as? FormBaseCell.Type
        }
        
        assert(formBaseCellClass != nil, "cellClass must be a FormBaseCell derived class value.")
        
        return formBaseCellClass
    }
}
