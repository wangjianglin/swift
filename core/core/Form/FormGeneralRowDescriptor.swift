//
//  FormGeneralRowDescriptor.swift
//  LinCore
//
//  Created by lin on 12/25/14.
//  Copyright (c) 2014 lin. All rights reserved.
//

import UIKit


public enum FormRowType {
    case button
    case booleanSwitch
    case booleanCheck
    case segmentedControl
    case picker
    case date
    case time
    case dateAndTime
    case multipleSelector
//    case Custom
}

open class FormGeneralRowDescriptor:FormRowDescriptor{
    fileprivate static var __once: () = {
//            Static.defaultCellClasses[FormRowType.Text] = FormTextFieldCell.self
//            Static.defaultCellClasses[FormRowType.Phone] = FormTextFieldCell.self
//            Static.defaultCellClasses[FormRowType.URL] = FormTextFieldCell.self
//            Static.defaultCellClasses[FormRowType.Email] = FormTextFieldCell.self
//            Static.defaultCellClasses[FormRowType.Password] = FormTextFieldCell.self
            Static.defaultCellClasses[FormRowType.button] = FormButtonCell.self
            Static.defaultCellClasses[FormRowType.booleanSwitch] = FormSwitchCell.self
            Static.defaultCellClasses[FormRowType.booleanCheck] = FormCheckCell.self
            Static.defaultCellClasses[FormRowType.segmentedControl] = FormSegmentedControlCell.self
            Static.defaultCellClasses[FormRowType.picker] = FormPickerCell.self
            Static.defaultCellClasses[FormRowType.date] = FormDateCell.self
            Static.defaultCellClasses[FormRowType.time] = FormDateCell.self
            Static.defaultCellClasses[FormRowType.dateAndTime] = FormDateCell.self
            Static.defaultCellClasses[FormRowType.multipleSelector] = FormSelectorCell.self
        }()
    open var dateFormatter: DateFormatter!

    

    fileprivate var cellClass:AnyClass!;

    fileprivate var _rowType:FormRowType;

    open var rowType:FormRowType{

        return _rowType;

    }

    

    struct Static {

        static var onceDefaultCellClass: Int = 0

        static var defaultCellClasses: Dictionary<FormRowType, FormBaseCell.Type> = [:]

    }

    

    public init(title: String,name: String,rowType:FormRowType,value:NSObject? = nil) {

        self._rowType = rowType;

        super.init(title: title, name: name,value:value);

    }

    

    fileprivate class func defaultCellClassForRowType(_ rowType: FormRowType) -> FormBaseCell.Type {

        _ = FormGeneralRowDescriptor.__once

        return Static.defaultCellClasses[rowType]!
    }
    
    open override func formBaseCellClassFromRowDescriptor() -> FormBaseCell.Type! {
        
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
