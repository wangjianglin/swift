//
//  Buttons.swift
//  LinCore
//
//  Created by lin on 1/20/15.
//  Copyright (c) 2015 lin. All rights reserved.
//

import UIKit
import LinUtil

extension UIControl{
    
    public func addActionForEvent(event:UIControlEvents,action:((AnyObject)->())){
        
        let delegateAction = EventDelegateAction(action:action);
        delegateAction.withObjectSameLifecycle = self;
        
        self.addTarget(delegateAction,action: "action:", forControlEvents: event);
    }
    
}
