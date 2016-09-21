//
//  FormDescriptor.swift
//  SwiftForms
//
//  Created by Miguel Angel Ortuno on 20/08/14.
//  Copyright (c) 2014 Miguel Angel Ortuño. All rights reserved.
//

import UIKit

open class FormDescriptor: NSObject {

    /// MARK: Properties
    
    open var title: String!
    
    open var sections: [FormSectionDescriptor] = []
    
    /// MARK: Public interface
    
    open func addSection(_ section: FormSectionDescriptor) {
        sections.append(section)
    }
    
    open func removeSection(_ section: FormSectionDescriptor) {
        if let index = sections.index(of: section) {
            sections.remove(at: index)
        }
    }
    
    open func formValues() -> Dictionary<String, Any> {
        
        var formValues: Dictionary<String, Any> = [:]

        for section in sections {
            for row in section.rows {
                if row.name != nil{
                    if row.value != nil {
                        formValues[row.name!] = row.value!
                    }
                    else {
                        formValues[row.name!] = NSNull()
                    }
                }
            }
        }
        return formValues
    }
}

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
