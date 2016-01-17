//
//  HZAreaPickerViews.swift
//  LinControls
//
//  Created by lin on 1/27/15.
//  Copyright (c) 2015 lin. All rights reserved.
//

import Foundation
import LinUtil

//public class HZAreaPickerViewDelegateImpl : HZAreaPickerDelegate{
//    
//    - (void)pickerDidChaneStatus:(HZAreaPickerView *)picker;
//}


extension HZAreaPickerView{
    public func setDelegateAction(action:(AnyObject)->()){
        var delegateAction = EventDelegateAction(action: action);
        delegateAction.withObjectSameLifecycle = self;
        self.target = delegateAction;
        self.action = "action:";
    }
}