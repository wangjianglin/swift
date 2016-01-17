//
//  FormDescriptor.swift
//  SwiftForms
//
//  Created by Miguel Angel Ortuno on 20/08/14.
//  Copyright (c) 2014 Miguel Angel Ortuño. All rights reserved.
//

import UIKit

public class FormDescriptor: NSObject {

    /// MARK: Properties
    
    public var title: String!
    
    public var sections: [FormSectionDescriptor] = []
    
    /// MARK: Public interface
    
    public func addSection(section: FormSectionDescriptor) {
        sections.append(section)
    }
    
    public func removeSection(section: FormSectionDescriptor) {
        if let index = sections.indexOf(section) {
            sections.removeAtIndex(index)
        }
    }
    
    public func formValues() -> Dictionary<String, NSObject> {
        
        var formValues: Dictionary<String, NSObject> = [:]

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
