//
//  UIView.swift
//  LinCore
//
//  Created by lin on 1/18/15.
//  Copyright (c) 2015 lin. All rights reserved.
//

import Foundation
import UIKit

extension UIView{
    
    //    (view2?.convertRect(CGRectMake(0, 0, 0, 0), toView: self.view)
    public func contentRect()->CGRect{
        return self.contentRectImpl(self);
    }
    private func contentRectImpl(view:UIView)->CGRect{
        var rect = CGRectMake(0, 0, 0, 0);
        
        for item in self.subviews {
            
            if let item = item as? UIView {
                
                var subRect:CGRect!;
                
                if let sv = item as? UIScrollView {
                    subRect = sv.bounds;
                }else{
                    subRect = item.contentRect();
                }
                let itemRect = item.bounds;
                let r = self.mergeRect(subRect,rect2:itemRect);
                let r2 = item.convertRect(r, toView: view)
                rect = self.mergeRect(r2, rect2: rect);
            }
        }
        
        return rect;
    }
    
    private func mergeRect(rect1:CGRect,rect2:CGRect)->CGRect{
        var result = CGRectMake(0, 0, 0, 0);
        result.origin.x = rect1.origin.x > rect2.origin.x ? rect2.origin.x : rect1.origin.x;
        
        result.origin.y = rect1.origin.y > rect2.origin.y ? rect2.origin.y : rect1.origin.y;
        
        var maxX = rect2.width + rect2.origin.x;
        if maxX < rect1.width + rect1.origin.x {
            maxX = rect1.width + rect1.origin.x
        }
        
        result.size.width = maxX - result.origin.x;
        
        var maxY = rect2.height + rect2.origin.y;
        if maxY < rect1.height + rect1.origin.y {
            maxY = rect1.height + rect1.origin.y
        }
        
        result.size.height = maxY - result.origin.y;
        
        return result;
    }
}
