//
//  AutoScrollView.swift
//  puer
//
//  Created by lin on 13/02/2017.
//  Copyright © 2017 lin. All rights reserved.
//

import Foundation
import LinUtil


open class AutoScrollView : UIScrollView{
    fileprivate var views = [UIView]();
    
    public enum Dir{
        case Vertical
        case Horizontal
    }
    public var dir = Dir.Vertical;
    
    public var offset = CGSize.init(width: 0, height: 0);
    
    public override init(frame: CGRect) {
        super.init(frame: frame);
        
        Queue.asynThread(self.thread);
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func addSubview(_ view: UIView) {
        super.addSubview(view);
        views.append(view);
    }
    
    private func calcSize()-> CGRect {
        var rect:CGRect!;
        var scount = 0;
        if self.showsHorizontalScrollIndicator {
            scount += 2;
        }
        if self.showsVerticalScrollIndicator {
            scount += 2;
        }
        if views.count > 2 {
            for n in 0 ..< self.views.count - scount {
                let view = self.views[n];
                if view.isHidden {
                    continue;
                }
                let srect = view.convert(view.bounds, to: self);
                
                if rect == nil {
                    rect = srect;
                }else{
                    rect = mergeRect(srect,rect2: rect);
                }
            }
        }
        if rect == nil {
            return CGRect(x: 0, y: 0, width: 0, height: 0);
        }
        
        return rect;
    }
    
    private func mergeRect(_ rect1:CGRect,rect2:CGRect)->CGRect{
        var result = CGRect(x: 0, y: 0, width: 0, height: 0);
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
    
    private var run = true;
    private func thread(){
        var interval:TimeInterval = 0.2;
        while(run){
            if(isHidden){
                interval = 0.4;
                continue;
            }
            if self.resetContentSize() {
                interval = 0.8;
            }else{
                interval = 0.1;
            }
            Thread.sleep(forTimeInterval: interval);
        }
    }
    
    deinit {
        run = false;
    }
    
    private func resetContentSize()->Bool{
        var rect = self.calcSize();
        
        let bounds = self.bounds;
        
        if dir == Dir.Vertical{
            let h = self.bounds.height + 1;
            if rect.height + rect.origin.y <= h {
                rect.size.height = h;
            }
            rect.size.width = bounds.width + offset.width;
        }else{
            let w = self.bounds.width + 1;
            if rect.width + rect.origin.x <= w {
                rect.size.width = w;
            }
            rect.size.height = bounds.height + offset.height;
        }
        rect.size.width += offset.width;
        rect.size.height += offset.height;
        if rect.size.width == self.contentSize.width
            && rect.size.height == self.contentSize.height {
            return false;
        }
        
        Queue.mainQueue{
            self.contentSize = rect.size;
        }
        return true;
    }
    
    open override var contentSize: CGSize{
        get{
            return super.contentSize;
        }
        set{
            super.contentSize = newValue;
        }
    }
}
