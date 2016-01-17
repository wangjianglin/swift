//
//  LogoutButtonDescriptor.swift
//  seller
//
//  Created by lin on 12/26/14.
//  Copyright (c) 2014 lin. All rights reserved.
//

import UIKit

public class FormButtonDescriptor:FormRowDescriptor{
    
    public init(title:String){
        super.init(title: title, name: "", value: nil);
    }
    
    public override func formBaseCellClassFromRowDescriptor() -> FormBaseCell.Type! {
        
        return FormButtonCell.self;
    }
    
    public var click:(()->())!;
}
