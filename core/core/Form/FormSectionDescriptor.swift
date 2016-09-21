//
//  FormSectionDescriptor.swift
//  SwiftForms
//
//  Created by Miguel Angel Ortuno on 20/08/14.
//  Copyright (c) 2014 Miguel Angel Ortuño. All rights reserved.
//

import UIKit

open class FormSectionDescriptor: NSObject {

    /// MARK: Properties
    
    open var headerTitle: String!
    open var footerTitle: String!
    
    open var rows: [FormRowDescriptor] = []
    
    /// MARK: Public interface
    
    open func addRow(_ row: FormRowDescriptor) {
        rows.append(row)
    }
    
    open func removeRow(_ row: FormRowDescriptor) {
        if let index = rows.index(of: row) {
            rows.remove(at: index)
        }
    }
}

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
