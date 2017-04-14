//
//  UICView.swift
//  LinRac
//
//  Created by lin on 12/04/2017.
//  Copyright © 2017 lin. All rights reserved.
//

import Foundation
import UIKit
import ReactiveCocoa
import ReactiveSwift
import LinUtil

private var refreshKey = 0;
private var loadmoreKey = 0;
extension Reactive where Base: UICollectionView{
    
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
        let a:(action:CocoaAction<Base>,scope:ScopedDisposable<CompositeDisposable>)? = base.getAssociatedValue(forAddress: key);
        return a?.action;
    }
    
    fileprivate func setHeaderEvent(_ action:CocoaAction<Base>?){
        if let action = action {
            base.addHeader(withTarget: action, action: CocoaAction<Base>.selector)
            
            let disposable = CompositeDisposable()
            disposable += { [weak base = self.base] in
                base?.removeHeader();
            }
            
            action.addComplete({[weak base] (_) in
                base?.headerEndRefreshing();
            })
            
            base.setAssociatedValue(value: (action, ScopedDisposable(disposable)), forAddress: &refreshKey)
        }else{
            base.setAssociatedValue(value: nil, forAddress: &refreshKey)
        }
    }
    
    fileprivate func setFooterEvent(_ action:CocoaAction<Base>?){
        if let action = action {
            base.addFooter(withTarget: action, action: CocoaAction<Base>.selector)
            
            let disposable = CompositeDisposable()
            disposable += { [weak base = self.base] in
                base?.removeFooter();
            }
            
            action.addComplete({[weak base] (_) in
                base?.footerEndRefreshing();
            })
            
            base.setAssociatedValue(value: (action, ScopedDisposable(disposable)), forAddress: &loadmoreKey)
        }else{
            base.setAssociatedValue(value: nil, forAddress: &loadmoreKey)
        }
    }
    
    
}
