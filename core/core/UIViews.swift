//
//  UIView.swift
//  LinCore
//
//  Created by lin on 1/18/15.
//  Copyright (c) 2015 lin. All rights reserved.
//

import Foundation
import UIKit
import LinUtil



extension Ext where Base:UIView{
    
    public static func getRootViewController()->UIViewController?{
        return rootViewControllerImpl();
    }
    public var rootViewController:UIViewController?{
        var window = UIApplication.shared.keyWindow;
        
        if window == nil || window!.windowLevel != UIWindowLevelNormal
        {
            
            let windows = UIApplication.shared.windows;
            for tmpWin in windows {
                if tmpWin.windowLevel == UIWindowLevelNormal {
                    window = tmpWin;
                    break;
                }
            }
        }
        if let window = window {
            if window.subviews.count > 0 {
                let frontView = window.subviews[0];
                let nextResponder = frontView.next;
                
                if nextResponder is UIViewController {
                    return nextResponder as? UIViewController;
                }else{
                    return window.rootViewController;
                }
            }
        }
        return nil;
    }
    
    fileprivate static func rootViewControllerImpl()->UIViewController?{
        //    UIViewController *result = nil;
        
        var window = UIApplication.shared.keyWindow;
        
        if window == nil || window!.windowLevel != UIWindowLevelNormal
        {
            
            let windows = UIApplication.shared.windows;
            for tmpWin in windows {
                if tmpWin.windowLevel == UIWindowLevelNormal {
                    window = tmpWin;
                    break;
                }
            }
        }
        
        if let window = window {
            if window.subviews.count > 0 {
                let frontView = window.subviews[0];
                let nextResponder = frontView.next;
                
                if nextResponder is UIViewController {
                    return nextResponder as? UIViewController;
                }else{
                    return window.rootViewController;
                }
            }
        }
        
        return nil;
    }
    
    public var viewController:UIViewController?{
        var next = self.base.superview;
        while next != nil {
            let resp = next!.next;
            if resp is UIViewController {
                return resp as? UIViewController
            }
            next = next?.superview;
        }
        return nil;
    }
    
}

extension Ext where Base:UIView {
    
    static func autoSet(priority:UILayoutPriority,constraint:@escaping ALConstraintsBlock) {
        UIView.autoSetPriority(priority, forConstraints: constraint)
    }
    func autoPinEdgeWithsuperView(edge:ALEdge)->NSLayoutConstraint {
        return self.base.autoPinEdge(toSuperviewEdge: edge)
    }
    func autoPinEdgeWithSuperviewEdge(edge:ALEdge,inset:CGFloat)->NSLayoutConstraint {
        return self.base.autoPinEdge(toSuperviewEdge: edge, withInset: inset)
    }
    func autoPinEdgeWithSuperviewEdge(edge:ALEdge,inset:CGFloat,relation:NSLayoutRelation)->NSLayoutConstraint{
        return self.base.autoPinEdge(toSuperviewEdge: edge, withInset: inset, relation: relation)
    }
    
    func autoPinEdgesWithSuperViewEdgesWithInset(insets:UIEdgeInsets)->[Any]{
        return self.base.autoPinEdgesToSuperviewEdges(with: insets)
    }
    func autoPinEdgesWithSuperViewEdgesWithInset(insets:UIEdgeInsets,edge:ALEdge) ->[Any]{
        return self.base.autoPinEdgesToSuperviewEdges(with: insets, excludingEdge: edge)
    }
    
    func autoPin(edge:ALEdge,toEdge:ALEdge,offView:UIView) ->NSLayoutConstraint{
        return self.base.autoPinEdge(edge, to: toEdge, of: offView)
    }
    
    func autoPin(edge:ALEdge,toEdge:ALEdge,offView:UIView,offSet:CGFloat)->NSLayoutConstraint{
        return self.base.autoPinEdge(edge, to: toEdge, of: offView, withOffset: offSet)
    }
    
    func autoPin(edge:ALEdge,toEdge:ALEdge,offView:UIView,offSet:CGFloat,relation:NSLayoutRelation)->NSLayoutConstraint{
        return self.base.autoPinEdge(edge, to: toEdge, of: offView, withOffset: offSet, relation: relation)
    }
    
    // Align Axes
    
    func atuAlign(axis:ALAxis,withSameAxisofView:UIView)->NSLayoutConstraint {
        return self.base.autoAlignAxis(axis, toSameAxisOf: withSameAxisofView)
    }
 
    func atuAlign(axis:ALAxis,withSameAxisofView:UIView,offSet:CGFloat)->NSLayoutConstraint {
        return self.base.autoAlignAxis(axis, toSameAxisOf: withSameAxisofView, withOffset: offSet)
    }
    
    //k Match Dimensions
    
    func autoMatchDimension(dimension:ALDimension,toDimension:ALDimension,ofView:UIView)->NSLayoutConstraint {
        return self.base.autoMatch(dimension, to: toDimension, of: ofView)
    }
    
    func autoMatchDimension(dimension:ALDimension,toDimension:ALDimension,ofView:UIView,offSet:CGFloat)->NSLayoutConstraint {
        return self.base.autoMatch(dimension, to: toDimension, of: ofView, withOffset: offSet)
    }
    
    func autoMatchDimension(dimension:ALDimension,toDimension:ALDimension,ofView:UIView,offSet:CGFloat,relation:NSLayoutRelation)->NSLayoutConstraint {
        return self.base.autoMatch(dimension, to: toDimension, of: ofView, withOffset: offSet,relation:relation)
    }
    func autoMatchDimension(dimension:ALDimension,toDimension:ALDimension,ofView:UIView,multipler:CGFloat)->NSLayoutConstraint {
        return self.base.autoMatch(dimension, to: toDimension, of: ofView, withMultiplier: multipler)
    }
    func autoMatchDimension(dimension:ALDimension,toDimension:ALDimension,ofView:UIView,multipler:CGFloat,relation:NSLayoutRelation)->NSLayoutConstraint {
        return self.base.autoMatch(dimension, to: toDimension, of: ofView, withMultiplier: multipler, relation: relation)
    }
    
    // Set Dimensions
    
    func autoSetDimensionWithSize(size:CGSize)->[Any] {
        return self.base.autoSetDimensions(to: size)
    }
    
    func autoSetDimesion(dimension:ALDimension,toSize:CGFloat)->NSLayoutConstraint {
        return self.base.autoSetDimension(dimension, toSize: toSize)
    }
    func autoSetDimension(dimension:ALDimension,toSize:CGFloat,relation:NSLayoutRelation)->NSLayoutConstraint {
        return self.base.autoSetDimension(dimension, toSize:toSize, relation: relation)
    }

    
}



