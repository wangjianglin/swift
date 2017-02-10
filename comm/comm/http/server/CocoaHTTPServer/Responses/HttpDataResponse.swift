//
//  HttpDataResponse.swift
//  LinComm
//
//  Created by lin on 17/10/2016.
//  Copyright © 2016 lin. All rights reserved.
//

import Foundation

open class HttpDataResponse : AbstractServerHttpResponse{
    
    public init(data:Data?) {
        super.init();
        self.responseObject = data as AnyObject?;
    }
}
