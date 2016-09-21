//
//  HttpTextResponse.swift
//  LinComm
//
//  Created by lin on 5/16/16.
//  Copyright © 2016 lin. All rights reserved.
//

import Foundation

open class HttpTextResponse : AbstractHttpResponse{
    
    public init(text:String){
        super.init();
        self.responseObject = text.data(using: String.Encoding.utf8) as AnyObject?;
    }
}
