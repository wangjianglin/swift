//
//  FormSegueDescriptor.swift
//  LinCore
//
//  Created by lin on 12/25/14.
//  Copyright (c) 2014 lin. All rights reserved.
//

import UIKit

public class FormSegueDescriptor:FormRowDescriptor{
    
    private var _segue:String;
    public var segue:String{
        return _segue;
    }
    public init(title:String,segue:String){
        self._segue = segue;
        super.init(title: title, name: "");
    }
    
    override public func formBaseCellClassFromRowDescriptor() -> FormBaseCell.Type! {
        
        return FormSegueCell.self;
    }
}
