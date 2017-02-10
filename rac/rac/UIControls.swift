//
//  UIControls.swift
//  LinRac
//
//  Created by lin on 20/11/2016.
//  Copyright © 2016 lin. All rights reserved.
//

import Foundation
import LinUtil
import ReactiveCocoa
import ReactiveSwift

extension Reactive where Base: UIButton {
    
    //    public static var touchDown: UIControlEvents { get } // on all touch downs
    public var touchDown:CocoaAction<Base>?{
        get{
            return self.getActionForEvent(UIControlEvents.touchUpOutside,key:"_touch_down_action");
        }
        nonmutating set{
            
            self.setActionForEvent(UIControlEvents.touchUpOutside,action:newValue,key:"_touch_down_action")
        }
    }
    //
    //    public static var touchDownRepeat: UIControlEvents { get } // on multiple touchdowns (tap count > 1)
    public var touchDownRepeat:CocoaAction<Base>?{
        get{
            return self.getActionForEvent(UIControlEvents.touchDownRepeat,key:"_touch_down_repeat_action");
        }
        nonmutating set{
            
            self.setActionForEvent(UIControlEvents.touchDownRepeat,action:newValue,key:"_touch_down_repeat_action")
        }
    }
    //
    //    public static var touchDragInside: UIControlEvents { get }
    public var touchDragInside:CocoaAction<Base>?{
        get{
            return self.getActionForEvent(UIControlEvents.touchDragInside,key:"_touch_drag_in_side_action");
        }
        nonmutating set{
            
            self.setActionForEvent(UIControlEvents.touchDragInside,action:newValue,key:"_touch_drag_in_side_action")
        }
    }
    //
    //    public static var touchDragOutside: UIControlEvents { get }
    public var touchDragOutside:CocoaAction<Base>?{
        get{
            return self.getActionForEvent(UIControlEvents.touchDragOutside,key:"_touch_drag_out_side_action");
        }
        nonmutating set{
            
            self.setActionForEvent(UIControlEvents.touchDragOutside,action:newValue,key:"_touch_drag_out_side_action")
        }
    }
    //
    //    public static var touchDragEnter: UIControlEvents { get }
    public var touchDragEnter:CocoaAction<Base>?{
        get{
            return self.getActionForEvent(UIControlEvents.touchDragEnter,key:"_touch_drag_enter_action");
        }
        nonmutating set{
            
            self.setActionForEvent(UIControlEvents.touchDragEnter,action:newValue,key:"_touch_drag_enter_action")
        }
    }
    //
    //    public static var touchDragExit: UIControlEvents { get }
    public var touchDragExit:CocoaAction<Base>?{
        get{
            return self.getActionForEvent(UIControlEvents.touchDragExit,key:"_touch_drag_exit_action");
        }
        nonmutating set{
            
            self.setActionForEvent(UIControlEvents.touchDragExit,action:newValue,key:"_touch_drag_exit_action")
        }
    }
    //
    //    public static var touchUpInside: UIControlEvents { get }
    public var touchUpInside:CocoaAction<Base>?{
        get{
            return self.getActionForEvent(UIControlEvents.touchUpInside,key:"_touch_up_in_side_action");
        }
        nonmutating set{
            
            self.setActionForEvent(UIControlEvents.touchUpInside,action:newValue,key:"_touch_up_in_side_action")
        }
    }
    //
    //    public static var touchUpOutside: UIControlEvents { get }
    public var touchUpOutside:CocoaAction<Base>?{
        get{
            return self.getActionForEvent(UIControlEvents.touchUpOutside,key:"_touch_up_out_side_action");
        }
        nonmutating set{
            
            self.setActionForEvent(UIControlEvents.touchUpOutside,action:newValue,key:"_touch_up_out_side_action")
        }
    }
    //
    //    public static var touchCancel: UIControlEvents { get }
    public var touchCancel:CocoaAction<Base>?{
        get{
            return self.getActionForEvent(UIControlEvents.touchCancel,key:"_touch_cancel_action");
        }
        nonmutating set{
            
            self.setActionForEvent(UIControlEvents.touchCancel,action:newValue,key:"_touch_cancel_action")
        }
    }
    //
    //
    //    public static var valueChanged: UIControlEvents { get }
    public var valueChanged:CocoaAction<Base>?{
        get{
            return self.getActionForEvent(UIControlEvents.valueChanged,key:"_touch_value_changed_action");
        }
        nonmutating set{
            
            self.setActionForEvent(UIControlEvents.valueChanged,action:newValue,key:"_touch_value_changed_action")
        }
    }
    
    //    public var touchUpOutside:CocoaAction<Base>?{
    //        get{
    //            let a:(action:CocoaAction<Base>?,scope:ScopedDisposable<CompositeDisposable>)? = base.getAssociatedValue(forKey: "_touch_up_out_side_action");
    //             return a?.action;
    //        }
    //        nonmutating set{
    //
    //            if let action = newValue {
    //                base.addTarget(action, action: CocoaAction<Base>.selector, for: UIControlEvents.touchUpOutside)
    //
    //                let disposable = CompositeDisposable()
    //                disposable += { [weak base = self.base] in
    //                    base?.removeTarget(action, action: CocoaAction<Base>.selector, for: UIControlEvents.touchUpOutside)
    //                }
    //
    //                base.setAssociatedValue(value: (newValue, ScopedDisposable(disposable)), forKey: "_touch_up_out_side_action")
    //            }else{
    //                base.setAssociatedValue(value: nil, forKey: "_touch_up_out_side_action")
    //            }
    //        }
    //    }
//    public var touchUpOutside:CocoaAction<Base>?{
//        get{
//            return self.getActionForEvent(UIControlEvents.touchUpOutside,key:"_touch_up_out_side_action");
//        }
//        nonmutating set{
//            
//            self.setActionForEvent(UIControlEvents.touchUpOutside,action:newValue,key:"_touch_up_out_side_action")
//        }
//    }
    
    fileprivate func getActionForEvent(_ event:UIControlEvents,key:StaticString)->CocoaAction<Base>?{
        let a:(action:CocoaAction<Base>,scope:ScopedDisposable<CompositeDisposable>)? = base.getAssociatedValue(forKey: key);
        return a?.action;
    }
    fileprivate func setActionForEvent(_ event:UIControlEvents,action:CocoaAction<Base>?,key:StaticString){
        if let action = action {
            base.addTarget(action, action: CocoaAction<Base>.selector, for: UIControlEvents.touchUpOutside)
            
            let disposable = CompositeDisposable()
            disposable += { [weak base = self.base] in
                base?.removeTarget(action, action: CocoaAction<Base>.selector, for: UIControlEvents.touchUpOutside)
            }
            
            base.setAssociatedValue(value: (action, ScopedDisposable(disposable)), forKey: key)
        }else{
            base.setAssociatedValue(value: nil, forKey: key)
        }
    }
    //    private func setEventAction(_ event:UIControlEvents,action:CocoaAction<Base>?){
    //        let s = self.trigger(for: event);
    ////        let action:CocoaAction<()>? = nil;
    ////        base.setAssociatedValue(value: Any!, forKey: StaticString)
    //        s.observe({[weak base,action] observe in
    //            if let sender = base {
    //                action?.execute(sender);
    //            }
    //        });
    //    }
}
