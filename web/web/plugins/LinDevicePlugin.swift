//
//  LinDevicePlugin.swift
//  LinWeb
//
//  Created by lin on 9/19/16.
//  Copyright © 2016 lin. All rights reserved.
//

import Foundation

open class LinDevicePlugin : LinAbstractWebPlugin{
//-(Json*)productName:(Json*)args{
//    return [[Json alloc] initWithObject:@"iPhone"];
    open func productName()->String{
        return "iPhone";
    }
//}
}
