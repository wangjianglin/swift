//
//  Model.swift
//  LinComm
//
//  Created by lin on 5/28/16.
//  Copyright © 2016 lin. All rights reserved.
//

import Foundation
import LinUtil

open class HttpModel : JsonModel{
    
    required public override init(json: Json){
        super.init(json: json);
    }
    
    public override init(){
        super.init();
    }
}
