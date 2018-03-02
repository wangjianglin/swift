//
//  FormBaseCell.swift
//  LinRac
//
//  Created by 钟亮 on 2017/6/21.
//  Copyright © 2017年 lin. All rights reserved.
//

import Foundation
import ReactiveCocoa
import ReactiveSwift
import Result
import CessCore

extension Reactive where Base: FormRowDescriptor{
    
//    public var checkedValue: Signal<Any?, NoError> {
//        return controlEvents(UIControlEvents.valueChanged).map{$0.value};
//    }
    
    public var value: BindingTarget<Any?> {
        return makeBindingTarget { $0.value = $1 }
    }
    
}
