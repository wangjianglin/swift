//
//  FormSectionDescriptor.swift
//  SwiftForms
//
//  Created by Miguel Angel Ortuno on 20/08/14.
//  Copyright (c) 2014 Miguel Angel Ortuño. All rights reserved.
//

import UIKit

public class FormSectionDescriptor: NSObject {

    /// MARK: Properties
    
    public var headerTitle: String!
    public var footerTitle: String!
    
    public var rows: [FormRowDescriptor] = []
    
    /// MARK: Public interface
    
    public func addRow(row: FormRowDescriptor) {
        rows.append(row)
    }
    
    public func removeRow(row: FormRowDescriptor) {
        if let index = rows.indexOf(row) {
            rows.removeAtIndex(index)
        }
    }
}

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
