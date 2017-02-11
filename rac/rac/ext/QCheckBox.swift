//
//  CheckBox.swift
//  LinRac
//
//  Created by lin on 11/02/2017.
//  Copyright © 2017 lin. All rights reserved.
//

import Foundation
import LinCore
import ReactiveSwift
import ReactiveCocoa
import Result

extension Reactive where Base: QCheckBox{

    public var checked: Signal<Bool, NoError> {
        return controlEvents(UIControlEvents.valueChanged).map{$0.checked};
    }

}
