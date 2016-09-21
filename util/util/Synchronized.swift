//
//  Synchronized.swift
//  LinUtil
//
//  Created by lin on 1/8/15.
//  Copyright (c) 2015 lin. All rights reserved.
//

import Foundation


public func synchronized<T>(_ object: AnyObject, closure: @escaping () -> T) -> T {
    var result: Any? = nil
    objc_synchronized(object) {
        result = closure()
    }
    return result as! T
}
public func synchronized(_ object: AnyObject, closure: @escaping () -> Void) {
    objc_synchronized(object, closure)
}
