//
//  UITableView.swift
//  LinRac
//
//  Created by lin on 12/02/2017.
//  Copyright © 2017 lin. All rights reserved.
//

import Foundation
import UIKit
import ReactiveCocoa
import ReactiveSwift
import CessUtil
import CessCore

private var refreshKey = 0;
private var loadmoreKey = 0;
extension Reactive where Base: UIScrollView{
    
    public var refresh:CocoaAction<Base>?{
        get{
            return self.getActionForKey(key:&refreshKey);
        }
        nonmutating set{
            
            self.setHeaderEvent(newValue)
        }
    }
    
    public var loadmore:CocoaAction<Base>?{
        get{
            return self.getActionForKey(key:&loadmoreKey);
        }
        nonmutating set{
            
            self.setFooterEvent(newValue)
        }
    }
    
    fileprivate func getActionForKey(key:KeyAddr)->CocoaAction<Base>?{
        let action:CocoaAction<Base>? = base.getAssociatedValue(forAddress: key);
        return action;
    }


    fileprivate func setHeaderEvent(_ action:CocoaAction<Base>?){
        if let action = action {
            
            base.mj_header = MJRefreshNormalHeader.init(refreshingBlock: { [weak base = self.base] in
                if let base = base {
                    action.execute(base);
                }
            });
            
            action.addComplete({[weak base] (_) in
                base?.mj_header?.endRefreshing();
            })
            
        }else{
            base.mj_header = nil;
        }
        
        base.setAssociatedValue(value: (action), forAddress: &refreshKey)
    }
    
    fileprivate func setFooterEvent(_ action:CocoaAction<Base>?){
        if let action = action {
            base.mj_footer = MJRefreshBackNormalFooter.init(refreshingBlock: { [weak base = self.base] in
                if let base = base {
                    action.execute(base);
                }
            });
            action.addComplete({[weak base] (_) in
                base?.mj_footer?.endRefreshing();
            })
            
        }else{
            base.mj_footer = nil;
        }

        base.setAssociatedValue(value: action, forAddress: &loadmoreKey)

    }
    
    
}
