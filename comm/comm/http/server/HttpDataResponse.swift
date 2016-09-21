//
//  HttpDataResponse.swift
//  LinComm
//
//  Created by lin on 5/16/16.
//  Copyright © 2016 lin. All rights reserved.
//

import Foundation


open class HttpDataResponse : AbstractHttpResponse{
    
    public init(data:Data) {
        super.init();
        self.responseObject = data as AnyObject?;
    }
}
