//
//  Buttons.swift
//  LinCore
//
//  Created by lin on 1/20/15.
//  Copyright (c) 2015 lin. All rights reserved.
//

import UIKit
import LinUtil


extension Ext where Base : UIControl{
    
    public func addActionForEvent(_ event:UIControlEvents,action:@escaping ((AnyObject)->())){
        
        let delegateAction = EventDelegateAction(action:action);
        delegateAction.ext.withObjectSameLifecycle = base;
        
        base.addTarget(delegateAction,action: #selector(EventDelegateAction.action(_:)), for: event);
    }
    
}
