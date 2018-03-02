
//
//  FromViewModel.swift
//  demo
//
//  Created by 钟亮 on 2017/6/21.
//  Copyright © 2017年 lin. All rights reserved.
//

import ReactiveSwift
import ReactiveCocoa
import CessCore
import CessRac
import CessComm
import CessUtil
import Photos


class FromViewModel: AbsViewModel<FromController> {

    @objc public dynamic var count:Int = 0
    
    func testCount() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
            
            self.count = 10
            
        })
    }
}
