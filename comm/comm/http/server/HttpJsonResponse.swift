//
//  HttpJsonResponse.swift
//  LinComm
//
//  Created by lin on 5/16/16.
//  Copyright © 2016 lin. All rights reserved.
//

import LinUtil

open class HttpJsonResponse : HttpTextResponse{
    
    public init(json:Json){
        super.init(text:json.toString())
    }
}
