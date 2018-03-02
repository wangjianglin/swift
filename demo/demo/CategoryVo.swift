//
//  CategoryVo.swift
//  puer
//
//  Created by lin on 19/02/2017.
//  Copyright © 2017 lin. All rights reserved.
//

import Foundation
import LinComm


public class CategoryVO : HttpModel{
    
    @objc dynamic var testVstr:String = ""
    @objc dynamic var testVdoubel:Double = 0.0
    @objc dynamic var testVint:Int = 0
    @objc dynamic var testVbool:Bool = false
    @objc dynamic var testVstrArray:[String] = []
    public var password:String{
        
        get{ return self["password"].asString("");}
        set{ self.setValue(newValue as NSString, forName:"password");}
    }
    
}




