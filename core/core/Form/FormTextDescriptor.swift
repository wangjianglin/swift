//
//  FormTextDescriptor.swift
//  LinCore
//
//  Created by lin on 12/26/14.
//  Copyright (c) 2014 lin. All rights reserved.
//

import Foundation

public enum TextType{
case text
case name
case phone
case url
case email
case password
}
open class FormTextDescriptor:FormRowDescriptor{
    
    open let textType:TextType;
    
    public init(title: String,name: String,textType:TextType,value:NSObject! = nil){
        self.textType = textType;
        super.init(title: title, name: name, value: value);
    }
    
    open override func formBaseCellClassFromRowDescriptor() -> FormBaseCell.Type! {
        
        return FormTextCell.self;
    }
}
