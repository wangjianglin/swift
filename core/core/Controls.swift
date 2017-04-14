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
    
    public func addActionForEvent(_ event:UIControlEvents,action:@escaping ((AnyObject)->())){
        
        let delegateAction = EventDelegateAction(action:action);
        delegateAction.ext.withObjectSameLifecycle = self;
        
        self.addTarget(delegateAction,action: #selector(EventDelegateAction.action(_:)), for: event);
    }
    
}
