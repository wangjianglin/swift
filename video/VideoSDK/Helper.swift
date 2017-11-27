//
//  Helper.swift
//  VideoSDK
//
//  Created by devjia on 2017/11/9.
//  Copyright © 2017年 devjia. All rights reserved.
//

import Foundation

struct Platform {
    static let isSimulator: Bool = {
        var isSim = false
        #if arch(i386) || arch(x86_64)
            isSim = true
        #endif
        return isSim
    }()
}

struct ScreenSize {
    static let width: CGFloat = {
        return UIScreen.main.bounds.width
    }()
    static let height: CGFloat = {
        return UIScreen.main.bounds.height
    }()
}
