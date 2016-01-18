//
//  FormTextDescriptor.swift
//  LinCore
//
//  Created by lin on 12/26/14.
//  Copyright (c) 2014 lin. All rights reserved.
//

import Foundation

public enum TextType{
case Text
case Name
case Phone
case URL
case Email
case Password
}
public class FormTextDescriptor:FormRowDescriptor{
    
    public let textType:TextType;
    
    public init(title: String,name: String,textType:TextType,value:NSObject! = nil){
        self.textType = textType;
        super.init(title: title, name: name, value: value);
    }
    
    public override func formBaseCellClassFromRowDescriptor() -> FormBaseCell.Type! {
        
        return FormTextCell.self;
    }
}